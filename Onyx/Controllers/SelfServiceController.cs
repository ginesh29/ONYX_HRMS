using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Models.ViewModels.Report;
using Onyx.Services;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Onyx.Controllers
{
    [Authorize]
    public class SelfServiceController : Controller
    {
        private readonly AuthService _authService;
        private readonly CommonService _commonService;
        private readonly OrganisationService _organisationService;
        private readonly TransactionService _transactionService;
        private readonly ReportService _reportService;
        private readonly LoggedInUserModel _loggedInUser;
        public SelfServiceController(AuthService authService, OrganisationService organisationService, CommonService commonService, TransactionService transactionService, ReportService reportService)
        {
            _authService = authService;
            _commonService = commonService;
            _organisationService = organisationService;
            _loggedInUser = _authService.GetLoggedInUser();
            _transactionService = transactionService;
            _reportService = reportService;
        }

        #region Loan Application
        public IActionResult LoanApplication()
        {
            ViewBag.LoanTypeItems = _organisationService.GetLoanTypes().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.Sdes.Trim(),
            });
            ViewBag.TransactionNextNo = _transactionService.GetNextToolTransNo(_loggedInUser.CompanyCd, "EMPLOAN");
            if (_loggedInUser.UserOrEmployee == "E")
                ViewBag.EmpCd = _loggedInUser.UserCd;
            return View();
        }
        [HttpPost]
        public IActionResult SaveLoanApplication(EmpLoanModel model, string processId, bool confirmed = false)
        {
            var LoanDue = _transactionService.GetEmpLoan_Due(model.EmployeeCode);
            model.EntryBy = _loggedInUser.UserCd;
            if (LoanDue == 0 || confirmed)
            {
                var result = _transactionService.SaveLoan(model);
                var ActivityAbbr = "INS";
                var Message = $"Loan is applied With Trans no = {model.TransNo}";
                _commonService.SetActivityLogDetail(_loggedInUser.ActivityId, processId, ActivityAbbr, Message);
                return Json(result);
            }
            return Json(new CommonResponse
            {
                Success = false,
                Message = $"PREVIOUS LOAN BALANCE UNSETTLED ({LoanDue} AED)."
            });
        }
        #endregion

        #region Leave Application
        public IActionResult LeaveApplication()
        {
            ViewBag.LeaveTypeItems = _organisationService.GetLeaveTypes(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes.Trim(),
            });
            ViewBag.IntLocalTypeItems = _commonService.GetIntLocalTypes();
            ViewBag.TransactionNextNo = _transactionService.GetNextLeaveTransNo();
            if (_loggedInUser.UserOrEmployee == "E")
                ViewBag.EmpCd = _loggedInUser.UserCd;
            return View();
        }
        public IActionResult GetLeaveType(string cd)
        {
            var leaveType = _organisationService.GetLeaveTypes(_loggedInUser.CompanyCd).FirstOrDefault(m => m.Cd.Trim() == cd);
            return Json(leaveType);
        }
        public IActionResult GetBalance(string empCd)
        {
            var leaveTrans = _reportService.GetBalanceTransactions(new BalanceTransactionFilterModel
            {
                EmpCd = empCd,
                ToDate = DateTime.Now
            }, _loggedInUser.CompanyCd).FirstOrDefault();
            return Json(leaveTrans);
        }
        public IActionResult SaveLeaveApplication(EmpLeaveModel model, string processId, bool confirmed = false)
        {
            model.EntryBy = _loggedInUser.UserCd;
            var leaveTrans = _reportService.GetBalanceTransactions(new BalanceTransactionFilterModel
            {
                EmpCd = model.EmployeeCode,
                ToDate = DateTime.Now
            }, _loggedInUser.CompanyCd).FirstOrDefault();
            var LeaveBalance = leaveTrans.LeaveOp + leaveTrans.Leave - leaveTrans.LeaveTaken;
            var dateSp = model.DateRange.Split(" - ");
            model.FromDt = Convert.ToDateTime(dateSp[0]);
            model.ToDt = Convert.ToDateTime(dateSp[1]);
            var lvDays = ExtensionMethod.GetDaysBetweenDateRange(model.FromDt, model.ToDt);
            bool lvExist = _transactionService.ExistingLvApplication(model.EmployeeCode, model.FromDt, model.ToDt);
            bool blockLeave = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "LVSALTIC_VAL").Val == "Y";
            if (!lvExist)
            {
                if ((LeaveBalance >= lvDays) || (confirmed && !blockLeave) || model.LeaveType == "UL")
                {
                    if (LeaveBalance < lvDays)
                    {
                        var toDate = model.FromDt.Value.AddDays(LeaveBalance - 1);
                        model.WpFromDt = model.FromDt.Value;
                        model.WpToDt = toDate;
                        model.WopFromDt = toDate.AddDays(1);
                        model.WopToDt = model.ToDt.Value;
                    }
                    else
                    {
                        model.WpFromDt = model.FromDt.Value;
                        model.WpToDt = model.ToDt.Value;
                    }
                    _transactionService.SaveLeave(model);
                    var ActivityAbbr = "INS";
                    var Message = $"Leave is applied With Trans no = {model.TransNo}";
                    _commonService.SetActivityLogDetail(_loggedInUser.ActivityId, processId, ActivityAbbr, Message);
                    var result = new CommonResponse
                    {
                        Success = true,
                        Message = "Leave applied successfully"
                    };
                    return Json(result);
                }
            }
            return Json(new CommonResponse
            {
                Success = false,
                Message = lvExist ? "Leave already applied on same day or not yet Resume Duty" : LeaveBalance < lvDays ? "You have insufficient Leave Balance" : string.Empty,
                Data = new { confirmation = !lvExist && !confirmed && !blockLeave && model.LeaveType != "UL" }
            });
        }
        #endregion

        #region Leave Salary Application
        public IActionResult LeaveSalaryApplication()
        {
            ViewBag.TransactionNextNo = _transactionService.GetNextLeaveSalaryTransNo();
            if (_loggedInUser.UserOrEmployee == "E")
                ViewBag.EmpCd = _loggedInUser.UserCd;
            return View();
        }
        public IActionResult SaveLeaveSalaryApplication(EmpLeaveSalaryModel model, string processId, bool confirmed = false)
        {
            model.LvSalary ??= 0;
            model.LvTicket ??= 0;
            var leaveTrans = _reportService.GetBalanceTransactions(new BalanceTransactionFilterModel
            {
                EmpCd = model.EmployeeCode,
                ToDate = DateTime.Now
            }, _loggedInUser.CompanyCd).FirstOrDefault();
            var LeaveSalaryBalance = leaveTrans.LvSalaryOp + leaveTrans.LvSalary - leaveTrans.LvSalaryTaken;
            var LeaveTicketBalance = leaveTrans.LvTicketOp + leaveTrans.LvTicket - leaveTrans.LvTicketTaken;
            model.EntryBy = _loggedInUser.UserCd;
            bool blockLeave = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "LVSALTIC_VAL").Val == "Y";
            if (Convert.ToDecimal(LeaveSalaryBalance) >= model.LvSalary || Convert.ToDecimal(LeaveTicketBalance) >= model.LvTicket || (confirmed && !blockLeave))
            {
                _transactionService.SaveLeaveSalary(model);
                var ActivityAbbr = "INS";
                var Message = $"Leave Salary is applied With Trans no = {model.TransNo}";
                _commonService.SetActivityLogDetail(_loggedInUser.ActivityId, processId, ActivityAbbr, Message);
                var result = new CommonResponse
                {
                    Success = true,
                    Message = "Leave Ticket applied successfully"
                };
                return Json(result);
            }
            return Json(new CommonResponse
            {
                Success = false,
                Message = "You have insufficient Leave Salary/Ticket Balance",
                Data = new { confirmation = !confirmed && !blockLeave }
            });
        }
        #endregion

        #region Fund Request Application
        public IActionResult FundRequestApplication()
        {
            ViewBag.FundTypeItems = _organisationService.GetCompanyFundTypes().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.Des.Trim(),
            });
            ViewBag.TransactionNextNo = _transactionService.GetNextEmpFund_TransNo();
            if (_loggedInUser.UserOrEmployee == "E")
                ViewBag.EmpCd = _loggedInUser.UserCd;
            return View();
        }
        public IActionResult SaveFundRequestApplication(EmployeeFundModel model, string processId)
        {
            model.EntryBy = _loggedInUser.UserCd;
            _transactionService.SaveFundRequest(model);
            var ActivityAbbr = "INS";
            var Message = $"Fund request is applied With Trans no = {model.TransNo}";
            _commonService.SetActivityLogDetail(_loggedInUser.ActivityId, processId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = "Fund request applied successfully"
            };
            return Json(result);
        }
        #endregion
    }
}
