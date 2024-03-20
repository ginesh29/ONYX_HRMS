using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
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
                    LvDateRange = ExtensionMethod.GetDateRange(leaveData.LvFrom, leaveData.LvTo),
                    LvDays = (Convert.ToDateTime(leaveData.LvTo) - Convert.ToDateTime(leaveData.LvFrom)).Days,
                    Reason = leaveData.Reason,
                    Current_Approval_Level = leaveData.Current_Approval_Level,
                    ApprDt = DateTime.Now,
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
            var lvDateSp = model.LvDateRange.Split(" - ");
            model.LvFrom = Convert.ToDateTime(lvDateSp[0]);
            model.LvTo = Convert.ToDateTime(lvDateSp[1]);
            var wopDateSp = model.WopDateRange.Split(" - ");
            model.WopFrom = Convert.ToDateTime(wopDateSp[0]);
            model.WopTo = Convert.ToDateTime(wopDateSp[1]);

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
                _transactionService.SaveLeaveRevise(model, _loggedInUser.CompanyCd);
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
                    LvDays = (Convert.ToDateTime(leaveData.ToDt) - Convert.ToDateTime(leaveData.FromDt)).Days,
                    WpFrom = leaveData.WpFrom,
                    WpTo = leaveData.WpTo,
                    WpDateRange = ExtensionMethod.GetDateRange(leaveData.WpFrom, leaveData.WpTo),
                    WpLvDays = (Convert.ToDateTime(leaveData.WopTo) - Convert.ToDateTime(leaveData.WopFrom)).Days,
                    WopFrom = leaveData.WpFrom,
                    WopTo = leaveData.WpTo,
                    WopDateRange = ExtensionMethod.GetDateRange(leaveData.WopFrom, leaveData.WopTo),
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
                    LvDays = (Convert.ToDateTime(leaveData.ToDt) - Convert.ToDateTime(leaveData.FromDt)).Days,
                    WpFrom = leaveData.WpFrom,
                    WpTo = leaveData.WpTo,
                    WpDateRange = ExtensionMethod.GetDateRange(leaveData.WpFrom, leaveData.WpTo),
                    WpLvDays = (Convert.ToDateTime(leaveData.WopTo) - Convert.ToDateTime(leaveData.WopFrom)).Days,
                    WopFrom = leaveData.WpFrom,
                    WopTo = leaveData.WpTo,
                    WopDateRange = ExtensionMethod.GetDateRange(leaveData.WopFrom, leaveData.WopTo),
                    WopLvDays = (Convert.ToDateTime(leaveData.WopTo) - Convert.ToDateTime(leaveData.WopFrom)).Days,
                    ApprBy = leaveData.ApprBy,
                    ApprDays = leaveData.ApprDays,
                    ApprDt = DateTime.Now,
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
            var transferData = _transactionService.GetEmpTransferData();
            CommonResponse result = new()
            {
                Data = transferData,
            };
            return Json(result);
        }
        public IActionResult GetEmpTransfer(string empCd, int srNo)
        {
            var empTransfer = _transactionService.GetEmpTransferData().FirstOrDefault(m => m.SrNo == srNo && m.EmpCd.Trim() == empCd);
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
                model.TransferDt = DateTime.Now;
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
            ViewBag.BranchItems = _settingService.GetBranches(_loggedInUser.CompanyCd).Select(m => new
            SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})"
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
        public IActionResult EmpLoanClosing()
        {
            return View();
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
                model.TransDt = DateTime.Now;
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
            return View();
        }
        #endregion
    }
}
