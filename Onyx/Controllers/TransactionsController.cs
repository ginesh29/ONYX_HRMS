using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    public class TransactionsController : Controller
    {
        private readonly AuthService _authService;
        private readonly CommonService _commonService;
        private readonly OrganisationService _organisationService;
        private readonly TransactionService _transactionService;
        private readonly LoggedInUserModel _loggedInUser;
        public TransactionsController(AuthService authService, OrganisationService organisationService, CommonService commonService, TransactionService transactionService)
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
                ViewBag.EmpCd = _loggedInUser.LoginId;
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

        #region Leave Transaction
        public IActionResult EmpLeaveApprovals()
        {
            return View();
        }
        public IActionResult FetchEmpLeaveApprovalData()
        {
            var leaveData = _transactionService.GetEmpLeaveApprovalData(_loggedInUser.CompanyCd, _loggedInUser.LoginId, _loggedInUser.UserOrEmployee);
            CommonResponse result = new()
            {
                Data = leaveData,
            };
            return Json(result);
        }
        public IActionResult GetEmpLeaveApproval(string transNo)
        {
            var model = new EmpLeaveApprovalModel();
            var leaveData = _transactionService.GetEmpLeaveApprovalData(_loggedInUser.CompanyCd, _loggedInUser.LoginId, _loggedInUser.UserOrEmployee).FirstOrDefault(m => m.TransNo.Trim() == transNo);
            if (leaveData != null)
            {
                model = new EmpLeaveApprovalModel()
                {
                    TransNo = transNo,
                    EmpCd = leaveData.EmpCd,
                    Emp = leaveData.Emp,
                    Desg = leaveData.Desg,
                    Branch = leaveData.Branch,
                    TransDt = leaveData.TransDt,
                    LvTyp = leaveData.LvTyp,
                    LvFrom = leaveData.LvFrom,
                    LvTo = leaveData.LvTo,
                    LvDateRange = $"{Convert.ToDateTime(leaveData.LvFrom).ToString(CommonSetting.DateFormat)} - {Convert.ToDateTime(leaveData.LvTo).ToString(CommonSetting.DateFormat)}",
                    LvDays = (Convert.ToDateTime(leaveData.LvTo) - Convert.ToDateTime(leaveData.LvFrom)).Days,
                    Reason = leaveData.Reason,
                    Current_Approval_Level = leaveData.Current_Approval_Level,
                    ApprDt = DateTime.Now,
                };
            }
            return PartialView("_EmpLeaveApprovalModal", model);
        }
        public IActionResult SaveLeaveApproval(EmpLeaveApprovalModel model)
        {
            model.ApprBy = _loggedInUser.LoginId;
            model.EntryBy = _loggedInUser.UserAbbr;
            model.ApprDays = model.LvDays + model.WopLvDays;
            _transactionService.SaveLeaveApproval(model);
            var ProcessId = "HRPT11";
            var ActivityAbbr = "UPD";
            var action = model.Status == "Y" ? "approved" : "rejected";
            var Message = $", Leave is {action} With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", ProcessId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Leave {action}"
            };
            return Json(result);
        }
        public IActionResult EmpLeaveConfirmReviseCancel()
        {
            return View();
        }
        public IActionResult SaveLeaveConfirm(EmpLeaveConfirmModel model)
        {
            model.ApprBy = _loggedInUser.LoginId;
            model.ApprDays = model.LvDays + model.WopLvDays;
            _transactionService.SaveLeaveConfirm(model, _loggedInUser.CompanyCd);
            var ProcessId = "HRPT12";
            var ActivityAbbr = "UPD";
            var action = model.Type == (int)LeaveCofirmTypeEnum.Confirm ? "confirmed" : model.Type == (int)LeaveCofirmTypeEnum.Revise ? "revised" : "canceled";
            var Message = $", Leave is {action} With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", ProcessId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Leave {action}"
            };
            return Json(result);
        }
        public IActionResult FetchEmpLeaveData(string type = "")
        {
            var leaveData = _transactionService.GetEmpLeaveData("", type);
            CommonResponse result = new()
            {
                Data = leaveData,
            };
            return Json(result);
        }
        public IActionResult GetEmpLeaveConfirm(string transNo)
        {
            var model = new EmpLeaveConfirmModel();
            var leaveData = _transactionService.GetEmpLeaveData(transNo).FirstOrDefault();
            if (leaveData != null)
            {
                model = new EmpLeaveConfirmModel()
                {
                    TransNo = transNo,
                    EmpCd = leaveData.EmpCd,
                    Emp = leaveData.Emp,
                    Designation = leaveData.Designation,
                    Branch = leaveData.Branch,
                    AppDt = leaveData.AppDt,
                    LvTyp = leaveData.LvTyp,
                    FromDt = leaveData.FromDt,
                    ToDt = leaveData.ToDt,
                    DateRange = $"{Convert.ToDateTime(leaveData.FromDt).ToString(CommonSetting.DateFormat)} - {Convert.ToDateTime(leaveData.ToDt).ToString(CommonSetting.DateFormat)}",
                    LvDays = (Convert.ToDateTime(leaveData.ToDt) - Convert.ToDateTime(leaveData.FromDt)).Days,
                    WpFrom = leaveData.WpFrom,
                    WpTo = leaveData.WpTo,
                    WpDateRange = $"{Convert.ToDateTime(leaveData.WpFrom).ToString(CommonSetting.DateFormat)} - {Convert.ToDateTime(leaveData.WpTo).ToString(CommonSetting.DateFormat)}",
                    WpLvDays = (Convert.ToDateTime(leaveData.WopTo) - Convert.ToDateTime(leaveData.WopFrom)).Days,
                    WopFrom = leaveData.WpFrom,
                    WopTo = leaveData.WpTo,
                    WopDateRange = $"{Convert.ToDateTime(leaveData.WopFrom).ToString(CommonSetting.DateFormat)} - {Convert.ToDateTime(leaveData.WopTo).ToString(CommonSetting.DateFormat)}",
                    WopLvDays = (Convert.ToDateTime(leaveData.WopTo) - Convert.ToDateTime(leaveData.WopFrom)).Days,
                    ApprBy = leaveData.ApprBy,
                    ApprDays = leaveData.ApprDays,
                    ApprDt = DateTime.Now,
                };
                var allowance = _transactionService.GetEmpLeave_Allowances(model, _loggedInUser.CompanyCd);
                model.Ticket = allowance?.FareAmount;
                model.LvSalary = allowance?.LvSalary;
            }
            return PartialView("_EmpLeaveConfirmModal", model);
        }

        public IActionResult EmpDutyResumption()
        {
            return View();
        }
        #endregion

        public IActionResult EmpTransfer()
        {
            return View();
        }
        public IActionResult FetchEmpTransferData()
        {
            var transferData = _transactionService.GetEmpTransferData();
            CommonResponse result = new()
            {
                Data = transferData,
            };
            return Json(result);
        }
        public IActionResult EmpProvisionAdj()
        {
            return View();
        }
    }
}
