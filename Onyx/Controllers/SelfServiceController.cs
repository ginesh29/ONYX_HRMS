using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    public class SelfServiceController : Controller
    {
        private readonly AuthService _authService;
        private readonly CommonService _commonService;
        private readonly OrganisationService _organisationService;
        private readonly TransactionService _transactionService;
        private readonly LoggedInUserModel _loggedInUser;
        public SelfServiceController(AuthService authService, OrganisationService organisationService, CommonService commonService, TransactionService transactionService)
        {
            _authService = authService;
            _commonService = commonService;
            _organisationService = organisationService;
            _loggedInUser = _authService.GetLoggedInUser();
            _transactionService = transactionService;
        }

        #region Loan Application
        public IActionResult LoanApplication()
        {
            ViewBag.LoanTypeItems = _organisationService.GetLoanTypes().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.Sdes.Trim(),
            });
            ViewBag.TransactionNextNo = _transactionService.GetNextLoanTransNo(_loggedInUser.CompanyCd, "EMPLOAN");
            return View();
        }
        [HttpPost]
        public IActionResult SaveLoanApplication(EmpLoanModel model)
        {
            var LoanDue = _transactionService.GetEmpLoan_Due(model.EmployeeCode, model.TransDt);
            if (LoanDue <= 0)
            {
                model.EntryBy = _loggedInUser.UserAbbr;
                var result = _transactionService.SaveLoan(model);
                if (result.Success)
                {
                    var ProcessId = "HRPSS1";
                    var ActivityAbbr = "INS";
                    var Message = $", Loan is applied With Trans no={model.TransNo}";
                    _commonService.SetActivityLogDetail("0", ProcessId, ActivityAbbr, Message);
                }
                return Json(result);
            }
            else
            {
                return Json(new CommonResponse
                {
                    Success = false,
                    Message = $"PREVIOUS LOAN BALANCE UNSETTLED ({LoanDue} AED). SO YOU ARE NOT ELIGIBLE FOR NEW LOAN"
                });
            }

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
            if (!_loggedInUser.UserAbbr.Contains("Admin"))
                ViewBag.EmpCd = _loggedInUser.UserAbbr;
            return View();
        }
        public IActionResult SaveLeaveApplication(EmpLeaveModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var maxLeave = _transactionService.GetEmpMaxLeave(_loggedInUser.CompanyCd, model.LeaveType);
            if (maxLeave >= model.LvTaken)
            {
                _transactionService.SaveLeave(model);
                var ProcessId = "HRPSS2";
                var ActivityAbbr = "INS";
                var Message = $", Leave is applied With Trans no={model.TransNo}";
                _commonService.SetActivityLogDetail("0", ProcessId, ActivityAbbr, Message);
                var result = new CommonResponse
                {
                    Success = true,
                    Message = "Leave applied successfully"
                };
                return Json(result);
            }
            else
            {
                return Json(new CommonResponse
                {
                    Success = false,
                    Message = "Leave Application Maximum Limit Exceeded"
                });
            }

        }
        #endregion

        #region Leave Salary Application
        public IActionResult LeaveSalaryApplication()
        {
            ViewBag.TransactionNextNo = _transactionService.GetNextLeaveSalaryTransNo();
            return View();
        }
        public IActionResult SaveLeaveSalaryApplication(EmpLeaveSalaryModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            _transactionService.SaveLeaveSalary(model);
            var ProcessId = "HRPSS3";
            var ActivityAbbr = "INS";
            var Message = $", Leave Salary is applied With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", ProcessId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = "Leave Ticket applied successfully"
            };
            return Json(result);
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
            ViewBag.TransactionNextNo = _transactionService.GetNextLeaveSalaryTransNo();
            return View();
        }
        public IActionResult SaveFundRequestApplication(EmployeeFundModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            _transactionService.SaveFundRequest(model);
            var ProcessId = "HRPSS4";
            var ActivityAbbr = "INS";
            var Message = $", Fund request is applied With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", ProcessId, ActivityAbbr, Message);
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
