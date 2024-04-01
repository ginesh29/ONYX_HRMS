using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class TransactionsController : Controller
    {
        private readonly AuthService _authService;
        private readonly CommonService _commonService;
        private readonly SettingService _settingService;
        private readonly TransactionService _transactionService;
        private readonly EmployeeService _employeeService;
        private readonly OrganisationService _organisationService;
        private readonly LoggedInUserModel _loggedInUser;
        public TransactionsController(AuthService authService, CommonService commonService, TransactionService transactionService, SettingService settingService, EmployeeService employeeService, OrganisationService organisationService)
        {
            _authService = authService;
            _commonService = commonService;
            _loggedInUser = _authService.GetLoggedInUser();
            _transactionService = transactionService;
            _settingService = settingService;
            _employeeService = employeeService;
            _organisationService = organisationService;
        }

        #region Leave Transaction
        public IActionResult EmpLeaveApprovals()
        {
            return View();
        }
        public IActionResult FetchEmpLeaveApprovalData()
        {
            var leaveData = _transactionService.GetEmpLeaveApprovalData(_loggedInUser.CompanyCd, _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee);
            CommonResponse result = new()
            {
                Data = leaveData,
            };
            return Json(result);
        }
        public IActionResult GetEmpLeaveApproval(string transNo)
        {
            var model = new EmpLeaveApprovalModel();
            var leaveData = _transactionService.GetEmpLeaveApprovalData(_loggedInUser.CompanyCd, _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee).FirstOrDefault(m => m.TransNo.Trim() == transNo);
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
                    LvDays = ExtensionMethod.GetDaysBetweenDateRange(leaveData.LvFrom, leaveData.LvTo),
                    WpDays = ExtensionMethod.GetDaysBetweenDateRange(leaveData.LvFrom, leaveData.LvTo),
                    LvDateRange = ExtensionMethod.GetDateRange(leaveData.LvFrom, leaveData.LvTo),
                    WpDateRange = ExtensionMethod.GetDateRange(leaveData.LvFrom, leaveData.LvTo),
                    Reason = leaveData.Reason,
                    Current_Approval_Level = leaveData.Current_Approval_Level,
                    ApprDt = DateTime.Now.Date,
                    ApprBy = leaveData.Current_Approval.Trim(),
                };
            }
            return PartialView("_EmpLeaveApprovalModal", model);
        }
        public IActionResult GetEmpLeaveDetail(string empCd, DateTime FromDt, DateTime ToDt)
        {
            var leaveDetails = _transactionService.GetEmployee_LeaveHistory(empCd, FromDt, ToDt);
            return PartialView("_EmpLeaveDetailPreviewModal", leaveDetails);
        }
        public IActionResult SaveLeaveApproval(EmpLeaveApprovalModel model, string processId)
        {
            model.ApprBy = _loggedInUser.UserOrEmployee == "E" ? _loggedInUser.UserAbbr : model.ApprBy;
            model.EntryBy = _loggedInUser.UserAbbr;
            model.ApprDays = model.LvDays + model.WopLvDays;
            if (model.Status == "Y")
            {
                if (!string.IsNullOrEmpty(model.WpDateRange))
                {
                    var wpDateSp = model.WpDateRange.Split(" - ");
                    model.WpFrom = Convert.ToDateTime(wpDateSp[0]);
                    model.WpTo = Convert.ToDateTime(wpDateSp[1]);
                }
                if (!string.IsNullOrEmpty(model.WopDateRange))
                {
                    var wopDateSp = model.WopDateRange.Split(" - ");
                    model.WopFrom = Convert.ToDateTime(wopDateSp[0]);
                    model.WopTo = Convert.ToDateTime(wopDateSp[1]);
                }
            }
            _transactionService.SaveLeaveApproval(model);
            var ActivityAbbr = "UPD";
            var action = model.Status == "Y" ? "approved" : "rejected";
            var Message = $", Leave is {action} With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
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
        public IActionResult SaveLeaveConfirm(EmpLeaveConfirmModel model, string processId)
        {
            model.ApprBy = _loggedInUser.UserAbbr;
            model.ApprDays = model.LvDays + model.WopLvDays;
            if (model.Type == (int)LeaveCofirmTypeEnum.Revise)
            {
                var dateSp = model.DateRange.Split(" - ");
                model.FromDt = Convert.ToDateTime(dateSp[0]);
                model.ToDt = Convert.ToDateTime(dateSp[1]);
                if (!string.IsNullOrEmpty(model.WpDateRange))
                {
                    var wpDateSp = model.WpDateRange.Split(" - ");
                    model.WpFrom = Convert.ToDateTime(wpDateSp[0]);
                    model.WpTo = Convert.ToDateTime(wpDateSp[1]);
                }
                if (!string.IsNullOrEmpty(model.WopDateRange))
                {
                    var wopDateSp = model.WopDateRange.Split(" - ");
                    model.WopFrom = Convert.ToDateTime(wopDateSp[0]);
                    model.WopTo = Convert.ToDateTime(wopDateSp[1]);
                }
                //_transactionService.SaveLeaveRevise(model, _loggedInUser.CompanyCd);
            }
            else
                _transactionService.SaveLeaveConfirm(model, _loggedInUser.CompanyCd);
            var ActivityAbbr = "UPD";
            var action = model.Type == (int)LeaveCofirmTypeEnum.Confirm ? "confirmed" : model.Type == (int)LeaveCofirmTypeEnum.Revise ? "revised" : "canceled";
            var Message = $", Leave is {action} With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
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
                    DateRange = ExtensionMethod.GetDateRange(leaveData.FromDt, leaveData.ToDt),
                    LvDays = ExtensionMethod.GetDaysBetweenDateRange(leaveData.FromDt, leaveData.ToDt),
                    WpFrom = leaveData.WpFrom,
                    WpTo = leaveData.WpTo,
                    WpDateRange = leaveData.WpFrom != null && leaveData.WpFrom != null ? ExtensionMethod.GetDateRange(leaveData.WpFrom, leaveData.WpTo) : null,
                    WpLvDays = leaveData.WpFrom != null && leaveData.WpFrom != null ? ExtensionMethod.GetDaysBetweenDateRange(leaveData.WpFrom, leaveData.WpTo) : 0,
                    WopFrom = leaveData.WpFrom,
                    WopTo = leaveData.WpTo,
                    WopDateRange = leaveData.WopFrom != null && leaveData.WopFrom != null ? ExtensionMethod.GetDateRange(leaveData.WopFrom, leaveData.WopTo) : null,
                    WopLvDays = leaveData.WopFrom != null && leaveData.WopFrom != null ? ExtensionMethod.GetDaysBetweenDateRange(leaveData.WopFrom, leaveData.WopTo) : 0,
                    ApprBy = leaveData.ApprBy,
                    ApprDays = leaveData.ApprDays,
                    ApprDt = DateTime.Now.Date
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
        public IActionResult GetDutyResumption(string transNo)
        {
            var model = new EmpDutyResumptionModel();
            var leaveData = _transactionService.GetEmpLeaveData(transNo, "D").FirstOrDefault();
            if (leaveData != null)
            {
                model = new EmpDutyResumptionModel()
                {
                    TransNo = transNo,
                    EmpCd = leaveData.EmpCd.Trim(),
                    Emp = leaveData.Emp,
                    Designation = leaveData.Designation,
                    Branch = leaveData.Branch,
                    AppDt = leaveData.AppDt,
                    LvTyp = leaveData.LvTyp,
                    FromDt = leaveData.FromDt,
                    ToDt = leaveData.ToDt,
                    DateRange = ExtensionMethod.GetDateRange(leaveData.FromDt, leaveData.ToDt),
                    LvDays = ExtensionMethod.GetDaysBetweenDateRange(leaveData.FromDt, leaveData.ToDt),
                    WpFrom = leaveData.WpFrom,
                    WpTo = leaveData.WpTo,
                    WpDateRange = ExtensionMethod.GetDateRange(leaveData.WpFrom, leaveData.WpTo),
                    WpLvDays = ExtensionMethod.GetDaysBetweenDateRange(leaveData.WpFrom, leaveData.WpTo),
                    WopFrom = leaveData.WpFrom,
                    WopTo = leaveData.WpTo,
                    WopDateRange = ExtensionMethod.GetDateRange(leaveData.WopFrom, leaveData.WopTo),
                    WopLvDays = ExtensionMethod.GetDaysBetweenDateRange(leaveData.WopFrom, leaveData.WopTo),
                    ApprBy = leaveData.ApprBy,
                    ApprDays = leaveData.ApprDays,
                    ApprDt = DateTime.Now.Date
                };
            }
            return PartialView("_EmpDutyResumptionModal", model);
        }
        public IActionResult SaveDutyResumption(EmpDutyResumptionModel model, string processId)
        {
            model.ApprBy = _loggedInUser.UserAbbr;
            model.EntryBy = _loggedInUser.UserAbbr;
            model.ApprDays = model.LvDays + model.WopLvDays;
            var wpDateSp = model.WpDateRange.Split(" - ");
            model.WpFrom = Convert.ToDateTime(wpDateSp[0]);
            model.WpTo = Convert.ToDateTime(wpDateSp[1]);
            var wopDateSp = model.WopDateRange.Split(" - ");
            model.WopFrom = Convert.ToDateTime(wopDateSp[0]);
            model.WopTo = Convert.ToDateTime(wopDateSp[1]);
            _transactionService.SaveDutyResumption(model, _loggedInUser.CompanyCd);
            if (!string.IsNullOrEmpty(model.GraduityDateRange))
            {
                var dateSp = model.GraduityDateRange.Split(" - ");
                model.FromDt = Convert.ToDateTime(dateSp[0]);
                model.ToDt = Convert.ToDateTime(dateSp[1]);
                _transactionService.SaveLeaveProvision(model, "GT");
            }
            if (!string.IsNullOrEmpty(model.LvSalaryDateRange))
            {
                var dateSp = model.LvSalaryDateRange.Split(" - ");
                model.FromDt = Convert.ToDateTime(dateSp[0]);
                model.ToDt = Convert.ToDateTime(dateSp[1]);
                _transactionService.SaveLeaveProvision(model, "LS");
            }
            if (!string.IsNullOrEmpty(model.LvTicketDateRange))
            {
                var dateSp = model.LvTicketDateRange.Split(" - ");
                model.FromDt = Convert.ToDateTime(dateSp[0]);
                model.ToDt = Convert.ToDateTime(dateSp[1]);
                _transactionService.SaveLeaveProvision(model, "LT");
            }
            var ActivityAbbr = "UPD";
            var Message = $", Duty Resumption With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Duty Resumption successfully"
            };
            return Json(result);
        }
        #endregion

        #region Employee Transfer
        public IActionResult EmpTransfer()
        {
            return View();
        }
        public IActionResult FetchEmpTransferData()
        {
            var transferData = _transactionService.GetEmpTransferData(_loggedInUser.UserCd);
            CommonResponse result = new()
            {
                Data = transferData,
            };
            return Json(result);
        }
        public IActionResult GetEmpTransfer(string empCd, int srNo)
        {
            var empTransfer = _transactionService.GetEmpTransferData(_loggedInUser.UserCd).FirstOrDefault(m => m.SrNo == srNo && m.EmpCd.Trim() == empCd);
            var model = new EmpTransferModel();
            if (empTransfer != null)
                model = new EmpTransferModel
                {
                    Cd = empTransfer.EmpCd,
                    BrFrDes = empTransfer.BrFrDes,
                    BrFrom = empTransfer.BrFrom.Trim(),
                    BrTo = empTransfer.BrTo.Trim(),
                    BrToDes = empTransfer.BrToDes,
                    CompFrDes = empTransfer.CompFrDes,
                    CompTo = empTransfer.CompTo.Trim(),
                    CompToDes = empTransfer.CompToDes,
                    DeptFrDes = empTransfer.DeptFrDes,
                    DeptFrom = empTransfer.DeptFrom.Trim(),
                    DeptTo = empTransfer.DeptTo.Trim(),
                    DeptToDes = empTransfer.DeptToDes,
                    EmpCd = empTransfer.EmpCd.Trim(),
                    LocFrDes = empTransfer.LocFrDes,
                    LocFrom = empTransfer.LocFrom.Trim(),
                    LocTo = empTransfer.LocTo.Trim(),
                    LocToDes = empTransfer.LocToDes,
                    Narration = empTransfer.Narration,
                    SrNo = empTransfer.SrNo,
                    TransferDt = empTransfer.TransferDt,
                };
            else
            {
                model.SrNo = _transactionService.GetEmpTransferSrNo(empCd);
                model.TransferDt = DateTime.Now.Date;
            }
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new
            SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
            ViewBag.EmpDeployLocationItems = _commonService.GetCodesGroups(CodeGroup.EmpDeployLoc).Select(m => new SelectListItem
            {
                Text = $"{m.ShortDes}({m.Code.Trim()})",
                Value = m.Code.Trim()
            });
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            return PartialView("_EmpTransferModal", model);
        }
        public IActionResult GetEmpTransferDetail(string empCd)
        {
            var employee = _employeeService.FindEmployee(empCd, _loggedInUser.CompanyCd);
            return Json(employee);
        }

        [HttpPost]
        public IActionResult SaveEmpTransfer(EmpTransferModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _transactionService.SaveEmpTransfer(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteEmpTransfer(string empCd, int srNo)
        {
            _transactionService.DeleteEmpTransfer(empCd, srNo);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Employee Leave Salary/Ticket
        public IActionResult EmpLeaveSalaryApproval()
        {
            return View();
        }
        public IActionResult FetchEmpLeaveSalaryApprovalData()
        {
            var leaveData = _transactionService.GetEmpLeaveSalaryApprovalData(_loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = leaveData,
            };
            return Json(result);
        }
        public IActionResult GetEmpLeaveSalaryApproval(string transNo)
        {
            var model = new EmpLeaveSalaryApprovalModel();
            var leaveData = _transactionService.GetEmpLeaveSalaryApprovalData(_loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd).FirstOrDefault(m => m.TransNo.Trim() == transNo);
            if (leaveData != null)
            {
                model = new EmpLeaveSalaryApprovalModel()
                {
                    TransNo = transNo,
                    TransDt = leaveData.TransDt,
                    EmployeeCode = leaveData.EmpCd.Trim(),
                    Emp = leaveData.Emp.Trim(),
                    LvSalary = leaveData.LvSalary,
                    LvTicket = leaveData.LvTicket,
                    ApprLvl = leaveData.Current_Approval_Level,
                    ApprBy = leaveData.Current_Approval.Trim(),
                };
            }
            return PartialView("_EmpLeaveSalaryApprovalModal", model);
        }
        public IActionResult SaveLeaveSalaryApproval(EmpLeaveSalaryApprovalModel model, string processId)
        {
            model.ApprBy = _loggedInUser.UserOrEmployee == "E" ? _loggedInUser.UserAbbr : model.ApprBy;
            model.EntryBy = _loggedInUser.UserAbbr;
            _transactionService.SaveLeaveSalaryApproval(model);
            var ActivityAbbr = "UPD";
            var action = model.Status == "Y" ? "approved" : "rejected";
            var Message = $", Leave Salary is {action} With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Leave Salary/Ticket {action}"
            };
            return Json(result);
        }
        public IActionResult EmpLeaveSalaryDisburse()
        {
            return View();
        }
        public IActionResult FetchEmpLeaveSalaryConfirmData()
        {
            var leaveData = _transactionService.GetEmpLeaveSalaryDisburseData();
            CommonResponse result = new()
            {
                Data = leaveData,
            };
            return Json(result);
        }
        public IActionResult GetEmpLeaveSalaryDisburse(string transNo)
        {
            var model = new EmpLeaveSalaryDisburseModel();
            var leaveData = _transactionService.GetEmpLeaveSalaryDisburseData().FirstOrDefault(m => m.TransNo.Trim() == transNo);
            if (leaveData != null)
            {
                model = new EmpLeaveSalaryDisburseModel()
                {
                    TransNo = transNo,
                    AppDt = leaveData.AppDt,
                    ApprDt = leaveData.ApprDt,
                    Div = leaveData.Div,
                    EmpCd = leaveData.EmpCd,
                    Emp = leaveData.Emp.Trim(),
                    LvSalary = leaveData.LvSalary,
                    LvTicket = leaveData.LvTicket,
                    ApprBy = leaveData.ApprBy,
                };
            }
            return PartialView("_EmpLeaveSalaryDisburseModal", model);
        }
        public IActionResult SaveLeaveSalaryDisburse(EmpLeaveSalaryDisburseModel model, string processId)
        {
            model.ApprBy = _loggedInUser.UserAbbr;
            _transactionService.SaveLeaveSalaryDisburse(model, _loggedInUser.CompanyCd);
            var ActivityAbbr = "UPD";
            var action = model.Status == "Y" ? "disbursed" : "canceled";
            var Message = $", Leave Salary/Ticket is {action} With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Leave Salary/Ticket {action}"
            };
            return Json(result);
        }
        #endregion

        #region Employee Loan
        public IActionResult EmpLoanApproval()
        {
            return View();
        }
        public IActionResult FetchEmpLoanApprovalData()
        {
            var loanData = _transactionService.GetEmpLoanApprovalData(_loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = loanData,
            };
            return Json(result);
        }
        public IActionResult GetEmpLoanApproval(string transNo)
        {
            var loanDetails = _transactionService.GetEmpLoanDetail(transNo, _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd);
            var empDetail = _employeeService.GetEmployees(_loggedInUser.CompanyCd, loanDetails.EmployeeCode.Trim()).FirstOrDefault();
            loanDetails.Mobile = empDetail.MobNo?.Trim();
            loanDetails.Salary = Convert.ToInt32(empDetail.Total);
            loanDetails.ApprAmt = loanDetails.Amt;
            loanDetails.NoInst = loanDetails.NoInstReq;
            loanDetails.LoanApprDt = DateTime.Now.Date;
            loanDetails.ChgsPerc ??= 0;
            loanDetails.Balance = _transactionService.GetEmpLoan_Due(loanDetails.EmployeeCode.Trim(), loanDetails.LoanApprDt);
            ViewBag.RecModeItems = _commonService.GetSysCodes(SysCode.RecMode).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}"
            });
            ViewBag.RecPrdItems = _commonService.GetSysCodes(SysCode.RecPrd).Select(m =>
            new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}"
            });
            ViewBag.ChargeTypeItems = _commonService.GetChargesTypes();
            return PartialView("_EmpLoanApprovalModal", loanDetails);
        }
        public IActionResult SaveLoanApproval(EmpLoan_GetRow_Result model, string processId)
        {
            model.LoanApprBy = _loggedInUser.UserOrEmployee == "E" ? _loggedInUser.UserAbbr : model.Current_Approval;
            model.EntryBy = _loggedInUser.UserAbbr;
            if (model.LoanStatus == "A")
                model.Reco_Prd = model.Reco_Prd[4..];
            _transactionService.SaveLoanApproval(model);
            var ActivityAbbr = "UPD";
            var action = model.LoanStatus == "A" ? "approved" : "rejected";
            var Message = $", Loan is {action} With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Loan {action} successfully"
            };
            return Json(result);
        }
        public IActionResult EmpLoanDisbursement()
        {
            return View();
        }
        public IActionResult FetchEmpLoanDisburseData()
        {
            var loanData = _transactionService.GetEmpLoanDisburseData(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = loanData,
            };
            return Json(result);
        }
        public IActionResult GetEmpLoanDisburse(string transNo)
        {
            var loanDetails = _transactionService.GetEmpLoanDetail(transNo, _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd);
            var empDetail = _employeeService.FindEmployee(loanDetails.EmployeeCode.Trim(), _loggedInUser.CompanyCd);
            loanDetails.ChgsTyp = loanDetails.ChgsTyp.Trim() == "FR" ? "Fixed Rate" : "Reduce Balance";
            loanDetails.EmpBranchCd = empDetail.Div.Trim();
            ViewBag.PaymentModeItems = _commonService.GetSysCodes(SysCode.RecMode).Select(m => new
            SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}"
            });
            ViewBag.LoanStatusItems = _commonService.GetLoanStatus();
            return PartialView("_EmpLoanDisburseModal", loanDetails);
        }
        public IActionResult SaveLoanDisburse(EmpLoan_GetRow_Result model, string processId)
        {
            _transactionService.SaveEmpLoanDisbursement(model);
            var ActivityAbbr = "UPD";
            var action = model.LoanStatus == "D" ? "disbursed" : "canceled";
            var Message = $", Loan is {action} With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Loan {action} successfully"
            };
            return Json(result);
        }
        public IActionResult EmpLoanAdjustment()
        {
            return View();
        }
        public IActionResult FetchEmpLoanAdjustmentData()
        {
            var loanData = _transactionService.GetEmpLoanAdjustmentData(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = loanData,
            };
            return Json(result);
        }
        public IActionResult GetEmpLoanAdjustment(string transNo, string status)
        {
            var loanDetails = _transactionService.GetEmpLoanAdjustmentData(_loggedInUser.CompanyCd).FirstOrDefault(m => m.TransNo.Trim() == transNo);
            ViewBag.EmpLoanAdjDetail = _transactionService.GetEmpLoanAdjDetail(transNo, status, _loggedInUser.CompanyCd);
            //var empDetail = _employeeService.FindEmployee(loanDetails.EmployeeCode.Trim(), _loggedInUser.CompanyCd);
            //loanDetails.ChgsTyp = loanDetails.ChgsTyp.Trim() == "FR" ? "Fixed Rate" : "Reduce Balance";
            //loanDetails.EmpBranchCd = empDetail.Div.Trim();
            //ViewBag.PaymentModeItems = _commonService.GetSysCodes(SysCode.RecMode).Select(m => new
            //SelectListItem
            //{
            //    Value = m.Cd.Trim(),
            //    Text = $"{m.SDes}"
            //});
            //ViewBag.LoanStatusItems = _commonService.GetLoanStatus();
            return PartialView("_EmpLoanAdjustmentModal", loanDetails);
        }
        public IActionResult SaveEmpLoanAdj(IEnumerable<EmpLoanDetail_GetRow_Result> empLoanAdjDetail, string transNo, string type, string empCd, string processId)
        {
            foreach (var item in empLoanAdjDetail)
            {
                item.TransNo = transNo;
                item.EmpCd = empCd;
                item.Typ = type;
                item.EntryBy = _loggedInUser.UserAbbr;
                _transactionService.SaveEmpLoanAdj(item);
            }
            var ActivityAbbr = "UPD";
            var action = type == "D" ? "adjusted" : "closed";
            var Message = $", Loan is {action} With Trans no={transNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Loan {action} successfully"
            };
            return Json(result);
        }
        #endregion

        #region Employee Provision Adjustment
        public IActionResult EmpProvisionAdj()
        {
            return View();
        }
        public IActionResult FetchProvisionAdjData()
        {
            var transferData = _transactionService.GetEmpProvisionAdjData(_loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee);
            CommonResponse result = new()
            {
                Data = transferData,
            };
            return Json(result);
        }
        public IActionResult GetProvisionAdj(string transNo)
        {
            var empprovisionsadj = _transactionService.GetEmpProvisionAdjData(_loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee).FirstOrDefault(m => m.TransNo.Trim() == transNo);
            var model = new EmpprovisionsadjModel();
            if (empprovisionsadj != null)
                model = new EmpprovisionsadjModel
                {
                    Amt = empprovisionsadj.Amt,
                    ApprBy = empprovisionsadj.ApprBy,
                    ApprDt = empprovisionsadj.ApprDt,
                    Days = empprovisionsadj.Days,
                    EmpCd = empprovisionsadj.EmpCd,
                    Narr = empprovisionsadj.Narr,
                    ProvTyp = empprovisionsadj.ProvTyp,
                    Purpose = empprovisionsadj.Purpose,
                    RefDoc = empprovisionsadj.RefDoc,
                    RefDt = empprovisionsadj.RefDt,
                    Status = empprovisionsadj.Status,
                    TransDt = empprovisionsadj.TransDt,
                    TransNo = empprovisionsadj.TransNo,
                    CurrentApproval = empprovisionsadj.CurrentApproval,
                    CurrentApprovalLevel = empprovisionsadj.CurrentApprovalLevel,
                    Name = empprovisionsadj.Name,
                    Prov = empprovisionsadj.Prov
                };
            else
            {
                model.TransNo = _transactionService.GetEmpProvisionAdjSrNo();
                model.TransDt = DateTime.Now.Date;
            }
            ViewBag.ProvisionTypeItems = _organisationService.GetCompanyProvisions().Select(m => new
            SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
            return PartialView("_EmpProvisionAdjModal", model);
        }
        [HttpPost]
        public IActionResult SaveEmpProvisionAdj(EmpprovisionsadjModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _transactionService.SaveEmpProvisionAdj(model);
            return Json(result);
        }
        [HttpPost]
        public IActionResult ApproveEmpProvisionAdj(EmpprovisionsadjModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _transactionService.SetEmpprovisionsadjAppr(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteEmpProvisionAdj(string transNo)
        {
            _transactionService.DeleteEmpProvisionAdj(transNo);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Emp Monthly Attendance
        public IActionResult EmpMonthlyAttendance()
        {
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new
            SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            var currntMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currntYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currntMonth}/{currntYear}";
            ViewBag.WorkingHrDay = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "WORKHRS").Val;
            return View();
        }
        public IActionResult FetchEmpMonthlyAttendance(AttendanceFilterModel model)
        {
            var spYearMonth = model.MonthYear.Split("/");
            model.MonthYear = $"{spYearMonth[1]}{spYearMonth[0]}";
            var attendanceData = _transactionService.GetEmpAttendanceData(model, _loggedInUser.CompanyCd);
            var attendanceModel = new AttendanceModel
            {
                AttendanceData = attendanceData.ToList(),
                FilterModel = model
            };
            return PartialView("_EmpMonthlyAttendanceData", attendanceModel);
        }
        [HttpPost]
        public IActionResult SaveEmpMonthlyAttendance(AttendanceModel model)
        {
            model.FilterModel.EntryBy = _loggedInUser.UserAbbr;
            foreach (var item in model.AttendanceData)
                _transactionService.UpdateEmpMonthlyAttendance(item, model.FilterModel);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.UPDATED
            };
            return Json(result);
        }
        public IActionResult ImportAttendance(IFormFile file, AttendanceFilterModel filterModel)
        {
            try
            {
                filterModel.EntryBy = _loggedInUser.UserAbbr;
                var excelData = _transactionService.GetAttendanceFromExcel(file, _loggedInUser.CompanyCd);
                var validData = excelData.Where(m => m.IsValid);
                var invalidData = excelData.Where(m => !m.IsValid);
                string Message = !invalidData.Any() && !validData.Any() ? "No record found to import"
                    : invalidData.Any() ? $"{invalidData.Count()} record failed to import" : $"{validData.Count()} records imported succussfully";
                bool validHeader = _transactionService.ValidHeaderAttendanceExcel(file);
                if (validData.Any() && validHeader)
                {
                    excelData = null;
                    Message = "Headers are not matched. Download again & refill data";
                }
                if (validData.Any())
                    _transactionService.ImportAttendanceExcelData(validData, filterModel);
                return PartialView("_AttendanceExcelData", new { Data = excelData, Message });
            }
            catch (Exception ex)
            {
                return Json("File not supported. Download again & refill data");
            }
        }
        [HttpDelete]
        public IActionResult DeleteEmpMonthlyAttendance(AttendanceFilterModel model)
        {
            var spYearMonth = model.MonthYear.Split("/");
            model.MonthYear = $"{spYearMonth[1]}{spYearMonth[0]}";
            _transactionService.DeleteEmpAttendance(model.EmpCd, model.MonthYear, model.Branch);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Variable PayDed Components
        public IActionResult VariablePayDedComponents()
        {
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new
            SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            ViewBag.PayTypeItems = _commonService.GetSysCodes(SysCode.ComponentClass).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            var currntMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currntYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currntMonth}/{currntYear}";
            return View();
        }
        public IActionResult FetchEmpVariablePayDedComponents(VariablePayDedComponentFilterModel model)
        {
            if (!string.IsNullOrEmpty(model.MonthYear))
            {
                var spYearMonth = model.MonthYear.Split("/");
                int month = Convert.ToInt32(spYearMonth[0]);
                int year = Convert.ToInt32(spYearMonth[1]);
                int lastDayOfMonth = DateTime.DaysInMonth(year, month);
                model.FromDt = new DateTime(year, month, 1);
                model.ToDt = new DateTime(year, month, lastDayOfMonth);
            }
            var variablecomponentsData = _transactionService.GetVariablePayDedComponents(model);
            var variableComponentModel = new VariablePayDedComponentModel
            {
                VariableComponentsData = variablecomponentsData.ToList(),
                FilterModel = model
            };
            return PartialView("_EmpVariablePayDedComponents", variableComponentModel);
        }
        [HttpPost]
        public IActionResult SaveEmpVariablePayDedComponents(VariablePayDedComponentModel model)
        {
            _transactionService.DeleteEmpTrans(string.Empty, model.FilterModel.PayCode, model.FilterModel.PayType, model.FilterModel.Branch);
            model.FilterModel.EntryBy = _loggedInUser.UserAbbr;
            foreach (var item in model.VariableComponentsData)
            {
                var employeeDetail = _employeeService.FindEmployee(item.Cd, _loggedInUser.CompanyCd);
                item.Curr = employeeDetail.BasicCurr.Trim();
                _transactionService.EmpTrans_Update(item, model.FilterModel);
            }

            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.UPDATED
            };
            return Json(result);
        }
        public IActionResult ImportEmpVariablePayDedComponent(IFormFile file, VariablePayDedComponentFilterModel filterModel)
        {
            try
            {
                filterModel.EntryBy = _loggedInUser.UserAbbr;
                var excelData = _transactionService.GetVariablePayComponentFromExcel(file, _loggedInUser.CompanyCd);
                var validData = excelData.Where(m => m.IsValid);
                var invalidData = excelData.Where(m => !m.IsValid);
                string Message = !invalidData.Any() && !validData.Any() ? "No record found to import"
                    : invalidData.Any() ? $"{invalidData.Count()} record failed to import" : $"{validData.Count()} records imported succussfully";
                bool validHeader = _transactionService.ValidHeaderVariblePayComponentsExcel(file);
                if (!validHeader)
                {
                    excelData = null;
                    Message = "Headers are not matched. Download again & refill data";
                }
                if (validData.Any() && validHeader)
                    _transactionService.ImportVariablePayComponentExcelData(validData, filterModel, _loggedInUser.CompanyCd);
                return PartialView("_VariablePayDedComponentsExcelData", new { Data = excelData, Message });
            }
            catch (Exception ex)
            {
                return Json("File not supported. Download again & refill data");
            }
        }
        public IActionResult FetchPayCodeItems(string type)
        {
            var payCodeItems = _commonService.GetPayCodesByType(type).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            return Json(payCodeItems);
        }
        #endregion

        #region Emp Fund
        public IActionResult EmpFundApproval()
        {
            return View();
        }
        public IActionResult FetchEmpFundApprovalData()
        {
            var fundData = _transactionService.GetEmpFundApprovalData(_loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = fundData,
            };
            return Json(result);
        }
        public IActionResult GetEmpFundApproval(string transNo)
        {
            var fundDetails = _transactionService.GetEmpFundApprovalData(_loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd).FirstOrDefault(m => m.TransNo.Trim() == transNo);
            fundDetails.ApprDate = DateTime.Now.Date;
            return PartialView("_EmpFundApprovalModal", fundDetails);
        }
        public IActionResult SaveEmpFundApproval(EmpFund_Approval_GetRow_Result model, string processId)
        {
            model.ApprBy = _loggedInUser.UserOrEmployee == "E" ? _loggedInUser.UserAbbr : model.Current_Approval;
            model.EntryBy = _loggedInUser.UserAbbr;
            _transactionService.SaveEmpFundApproval(model);
            var ActivityAbbr = "UPD";
            var action = model.Status == "A" ? "approved" : "rejected";
            var Message = $", Fund is {action} With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Fund {action} successfully"
            };
            return Json(result);
        }
        public IActionResult EmpFundDisburse()
        {
            return View();
        }
        public IActionResult FetchEmpFundDisburseData()
        {
            var fundData = _transactionService.GetEmpFundDisburseData(string.Empty);
            CommonResponse result = new()
            {
                Data = fundData,
            };
            return Json(result);
        }
        public IActionResult GetEmpFundDisburse(string transNo)
        {
            var fundDetails = _transactionService.GetEmpFundDisburseData(transNo).FirstOrDefault();
            return PartialView("_EmpFundDisburseModal", fundDetails);
        }
        public IActionResult SaveEmpFundDisburse(EmpFund_View_Getrow_Result model, string processId)
        {
            _transactionService.SaveEmpFundConfirm(model, _loggedInUser.CompanyCd);
            var ActivityAbbr = "UPD";
            var action = model.Status == "0" ? "disbursed" : "canceled";
            var Message = $", Fund is {action} With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Fund {action} successfully"
            };
            return Json(result);
        }
        #endregion

        #region Document Renewal
        public IActionResult DocumentRenewal()
        {
            return View();
        }
        public IActionResult DocumentRenew()
        {
            return View();
        }
        public IActionResult GetRenewalDocument(string empCd, string docTypeCd, int srNo)
        {
            var document = _employeeService.GetDocuments(string.Empty, null).FirstOrDefault(m => m.EmpCd.Trim() == empCd && m.DocTypCd.Trim() == docTypeCd && m.SrNo == srNo);
            var model = new EmpDocumentModel();
            if (document != null)
                model = new EmpDocumentModel
                {
                    Cd = document.EmpCd,
                    EmpCd = document.EmpCd,
                    DocNo = document.DocNo,
                    DocTypSDes = document.DocTypSDes,
                    DocTypCd = document.DocTypCd.Trim(),
                    Expiry = document.Expiry,
                    ExpDt = document.ExpDt,
                    IssueDt = document.IssueDt,
                    SrNo = _transactionService.EmpDocIssueRcpt_NextSrNo(empCd, document.DocTypCd),
                    IssuePlace = document.IssuePlace,
                    TrnDt = DateTime.Now.Date,
                };
            ViewBag.DocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.CompanyDocType).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.DocStatusItems = _settingService.GetCodeGroupItems(CodeGroup.DocStatus).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            return PartialView("_RenewalDocumentModal", model);
        }
        public IActionResult SaveRenewalDocument(EmpDocumentModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            _transactionService.SaveEmpDocIssueReceipt(model);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Document renewal requested successfully"
            };
            return Json(result);
        }
        public IActionResult FetchEmpDocRenewalData()
        {
            var docs = _transactionService.GetEmpDocIssueRcpt(_loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee);
            CommonResponse result = new()
            {
                Data = docs,
            };
            return Json(result);
        }
        public IActionResult GetRenewalDocumentApproval(string empCd, string docTypeCd, int srNo)
        {
            var document = _transactionService.GetEmpDocIssueRcpt(_loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee).FirstOrDefault(m => m.EmployeeCode.Trim() == empCd && m.DocType.Trim() == docTypeCd && m.SrNo == srNo);
            document.DocType = document.DocType.Trim();
            document.DocStat = document.DocStat.Trim();
            ViewBag.DocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.CompanyDocType).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.DocStatusItems = _settingService.GetCodeGroupItems(CodeGroup.DocStatus).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            return PartialView("_RenewalDocumentApprovalModal", document);
        }
        public IActionResult SaveRenewalDocumentApproval(EmpDocIssueRcpt_GetRow_Result model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            model.ApprBy = _loggedInUser.UserOrEmployee == "E" ? _loggedInUser.UserAbbr : model.Current_Approval;
            _transactionService.SaveEmpDocIssueRcptAppr(model);
            var action = model.Status == "0" ? "approved" : "rejected";
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Document renewal {action} successfully"
            };
            return Json(result);
        }
        #endregion
    }
}
