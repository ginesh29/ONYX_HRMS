using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using Onyx.Models.ViewModels.Report;
using Onyx.Services;
using Rotativa.AspNetCore;
using Rotativa.AspNetCore.Options;

namespace Onyx.Controllers
{
    [Authorize]
    public class TransactionsController : Controller
    {
        private readonly DbGatewayService _dbGatewayService;
        private readonly AuthService _authService;
        private readonly CommonService _commonService;
        private readonly SettingService _settingService;
        private readonly TransactionService _transactionService;
        private readonly EmployeeService _employeeService;
        private readonly OrganisationService _organisationService;
        private readonly LoggedInUserModel _loggedInUser;
        public TransactionsController(AuthService authService, CommonService commonService, TransactionService transactionService, SettingService settingService, EmployeeService employeeService, OrganisationService organisationService, DbGatewayService dbGatewayService)
        {
            _authService = authService;
            _commonService = commonService;
            _loggedInUser = _authService.GetLoggedInUser();
            _transactionService = transactionService;
            _settingService = settingService;
            _employeeService = employeeService;
            _organisationService = organisationService;
            _dbGatewayService = dbGatewayService;
        }

        #region Leave Transaction
        public IActionResult EmpLeaveApprovals()
        {
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
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
        public IActionResult GetEmpLeaveDetail(string empCd, DateTime? FromDt, DateTime? ToDt)
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
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
                var wpDateSp = !string.IsNullOrEmpty(model.WpDateRange) ? model.WpDateRange.Split(" - ") : null;
                model.WpFrom = !string.IsNullOrEmpty(model.WpDateRange) ? Convert.ToDateTime(wpDateSp[0]) : null;
                model.WpTo = !string.IsNullOrEmpty(model.WpDateRange) ? Convert.ToDateTime(wpDateSp[1]) : null;
                var wopDateSp = !string.IsNullOrEmpty(model.WopDateRange) ? model.WopDateRange.Split(" - ") : null;
                model.WopFrom = !string.IsNullOrEmpty(model.WopDateRange) ? Convert.ToDateTime(wopDateSp[0]) : null;
                model.WopTo = !string.IsNullOrEmpty(model.WopDateRange) ? Convert.ToDateTime(wopDateSp[1]) : null;
                _transactionService.SaveLeaveRevise(model, _loggedInUser.CompanyCd);
            }
            else
                _transactionService.SaveLeaveConfirm(model, _loggedInUser.CompanyCd);
            if (model.SinglePayroll)
            {
                var employee = _employeeService.FindEmployee(model.EmpCd, _loggedInUser.CompanyCd);
                var WorkingHrDay = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "WORKHRS").Val;
                var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
                var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
                foreach (var item in model.Salary_SinglePayrollAttendanceData)
                {
                    var attendance = new EmpAttendance_Getrow_Result
                    {
                        Cd = model.EmpCd,
                        Up_HDays = item.Up_HDays,
                        W_days = item.NoOfDays,
                        NHrs = Convert.ToInt32((item.NoOfDays - item.Up_HDays - item.P_HDays) * float.Parse(WorkingHrDay)),
                        Payable = item.Payable,
                    };
                    var attendanceFilter = new AttendanceFilterModel
                    {
                        Branch = item.DivCd,
                        Department = employee.Dept,
                        EmpCd = model.EmpCd,
                        MonthYear = $"{currentYear}{currentMonth}",
                        WorkingHrDay = WorkingHrDay,
                        EntryBy = _loggedInUser.UserAbbr
                    };
                    _transactionService.UpdateEmpMonthlyAttendance(attendance, attendanceFilter);
                }
                int srNo = 1;
                foreach (var item in model.Component_SinglePayrollAttendanceData)
                {
                    var payComponent = new EmpTrans_VarCompFixAmt_GetRow_Result
                    {
                        Amt = item.UpdatedAmt,
                        Branch = employee.Div,
                        Cd = model.EmpCd,
                        Curr = employee.CurrCd,
                        Dept = employee.Dept,
                        SrNo = srNo,
                        Narr = "SinglePayroll",
                        TransId = "*S"
                    };
                    var EdTyp = item.DesCd[..6];
                    var EdCd = item.DesCd.Substring(6, 3);
                    int lastDayOfMonth = DateTime.DaysInMonth(Convert.ToInt32(currentYear), Convert.ToInt32(currentMonth));
                    var payComponentFilter = new VariablePayDedComponentFilterModel
                    {
                        Branch = employee.Div,
                        Department = employee.Dept,
                        EmpCd = model.EmpCd,
                        EntryBy = _loggedInUser.UserAbbr,
                        MonthYear = $"{currentYear}{currentMonth}",
                        PayType = EdTyp,
                        PayCode = EdCd,
                        FromDt = new DateTime(Convert.ToInt32(currentYear), Convert.ToInt32(currentMonth), 1),
                        ToDt = new DateTime(Convert.ToInt32(currentYear), Convert.ToInt32(currentMonth), lastDayOfMonth),
                    };
                    _transactionService.EmpTrans_Update(payComponent, payComponentFilter);
                    srNo++;
                }
            }
            //if (model.PrintAfterSave)
            //{

            //}
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
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            var model = new EmpLeaveConfirmModel();
            var leaveData = _transactionService.GetEmpLeaveData(transNo).FirstOrDefault();
            if (leaveData != null)
            {
                var prd = $"{leaveData.FromDt.Year}{leaveData.FromDt.Month:00}";
                var empSinglePayroll = _transactionService.GetEmpAttendance_Salary_SinglePayroll(leaveData.EmpCd, prd, _loggedInUser.CompanyCd);
                foreach (var item in empSinglePayroll.Salary_SinglePayrollAttendanceData)
                    item.Payable = item.NoOfDays - item.P_HDays - item.Up_HDays;
                var totalWDays = empSinglePayroll.Salary_SinglePayrollAttendanceData.Sum(m => m.NoOfDays);
                var totalPayable = empSinglePayroll.Salary_SinglePayrollAttendanceData.Sum(m => m.Payable);
                foreach (var item in empSinglePayroll.Component_SinglePayrollAttendanceData)
                    item.UpdatedAmt = Convert.ToDecimal(item.Amt / totalWDays) * totalPayable;
                bool singlePayroll = leaveData.FromDt.Year == Convert.ToInt32(currentYear) && leaveData.FromDt.Month == Convert.ToInt32(currentMonth);
                ViewBag.SinglePayroll = singlePayroll;
                model = new EmpLeaveConfirmModel()
                {
                    TransNo = transNo,
                    EmpCd = leaveData.EmpCd,
                    Emp = leaveData.Emp,
                    Designation = leaveData.Designation,
                    Branch = leaveData.Div,
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
                    ApprDt = DateTime.Now.Date,
                    Salary_SinglePayrollAttendanceData = empSinglePayroll.Salary_SinglePayrollAttendanceData,
                    Component_SinglePayrollAttendanceData = empSinglePayroll.Component_SinglePayrollAttendanceData,
                };
                var allowance = _transactionService.GetEmpLeave_Allowances(model, _loggedInUser.CompanyCd);
                model.Ticket = allowance?.FareAmount;
                model.LvSalary = allowance?.LvSalary;
            }
            return PartialView("_EmpLeaveConfirmModal", model);
        }
        public IActionResult EmpDutyResumption()
        {
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
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
            var wpDateSp = !string.IsNullOrEmpty(model.WpDateRange) ? model.WpDateRange.Split(" - ") : null;
            model.WpFrom = !string.IsNullOrEmpty(model.WpDateRange) ? Convert.ToDateTime(wpDateSp[0]) : null;
            model.WpTo = !string.IsNullOrEmpty(model.WpDateRange) ? Convert.ToDateTime(wpDateSp[1]) : null;
            var wopDateSp = !string.IsNullOrEmpty(model.WopDateRange) ? model.WopDateRange.Split(" - ") : null;
            model.WopFrom = !string.IsNullOrEmpty(model.WopDateRange) ? Convert.ToDateTime(wopDateSp[0]) : null;
            model.WopTo = !string.IsNullOrEmpty(model.WopDateRange) ? Convert.ToDateTime(wopDateSp[1]) : null;
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
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
            if (model.Mode == "I")
                model.SrNo = _transactionService.GetEmpTransferSrNo(model.EmpCd);
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
            var loanDetails = _transactionService.GetEmpLoanDetail(transNo, "2", _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd).FirstOrDefault();
            var empDetail = _employeeService.GetEmployees(_loggedInUser.CompanyCd, loanDetails.EmployeeCode.Trim(), _loggedInUser.UserCd).Employees.FirstOrDefault();
            loanDetails.EmployeeCode = loanDetails.EmployeeCode.Trim();
            loanDetails.Mobile = empDetail.MobNo?.Trim();
            loanDetails.Salary = Convert.ToInt32(empDetail.Total);
            loanDetails.ApprAmt = loanDetails.Amt;
            loanDetails.NoInst = loanDetails.NoInstReq;
            loanDetails.LoanApprDt = DateTime.Now.Date;
            loanDetails.ChgsPerc ??= 0;
            loanDetails.Balance = _transactionService.GetEmpLoan_Due(loanDetails.EmployeeCode.Trim());
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
            var loanDetails = _transactionService.GetEmpLoanDetail(transNo, "2", _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd).FirstOrDefault();
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
            if (model.UpdateGeneralLedger)
                _transactionService.Update_Loan_GeneralLedger(model.EmployeeCode.Trim(), model.ApprAmt, _loggedInUser.CompanyCd);
            var ActivityAbbr = "UPD";
            var action = model.LoanStatus == "D" ? "disbursed" : "canceled";
            var Message = $", Loan is {action} With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Loan {action} successfully",
                RedirectUrl = model.LoanStatus == "D" && model.PrintAfterSave ? Url.Action("LoanAdvanceSlip", new { transNo = model.TransNo.Trim(), empCd = model.EmployeeCode.Trim() }) : string.Empty
            };
            return Json(result);
        }
        public IActionResult EmpLoanAdjustment()
        {
            return View();
        }
        public IActionResult LoanAdvanceSlip(string transNo, string empCd)
        {
            var employees = _transactionService.GetEmpLoanDetail(transNo, "5", empCd, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd).FirstOrDefault();
            return new ViewAsPdf(employees)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
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
        public IActionResult GetEmpLoanAdjustment(string transNo)
        {
            var loanDetails = _transactionService.GetEmpLoanAdjustmentData(_loggedInUser.CompanyCd).FirstOrDefault(m => m.TransNo.Trim() == transNo);
            ViewBag.RecModeItems = _commonService.GetSysCodes(SysCode.RecMode).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}"
            });
            return PartialView("_EmpLoanAdjustmentModal", loanDetails);
        }
        public IActionResult GetEmpLoanEmi(string transNo, string status, decimal? amount)
        {
            var empLoanAdjDetail = _transactionService.GetEmpLoanAdjDetail(transNo, status, _loggedInUser.CompanyCd).ToList();
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.CurrentMonth = currentMonth;
            ViewBag.CurrentYear = currentYear;
            var totalLoan = empLoanAdjDetail.Sum(m => m.AmtVal);
            ViewBag.TotalLoan = totalLoan;
            var paidLoan = empLoanAdjDetail.Where(m => m.EffDate.Month < Convert.ToInt32(currentMonth)).Sum(m => m.AmtVal);
            var totalEmi = empLoanAdjDetail.Count;
            var paidEmi = empLoanAdjDetail.Count(m => m.EffDate.Month < Convert.ToInt32(currentMonth));
            var emi1 = totalEmi != 1 ? 1 : 0;
            var remaIningNoOfInst = totalEmi - paidEmi - emi1;
            var remainingLoan = totalLoan - (paidLoan + Convert.ToDecimal(amount));
            decimal emi = remainingLoan / remaIningNoOfInst;
            emi = emi > 0 ? emi : 0;
            if (amount != null)
            {
                var currentEmi = empLoanAdjDetail.FirstOrDefault(m => m.EffDate.Month == Convert.ToInt32(currentMonth) && m.EffDate.Year == Convert.ToInt32(currentYear))?.AmtVal;
                ViewBag.CurrentEmi = amount;
                var lastEmpLoanAdjDetail = empLoanAdjDetail.LastOrDefault();
                empLoanAdjDetail = empLoanAdjDetail.Select(m => { m.AmtVal = m.EffDate.Month == Convert.ToInt32(currentMonth) && m.EffDate.Year == Convert.ToInt32(currentYear) ? Convert.ToDecimal(amount) : m.AmtVal; return m; }).ToList();
                if (amount < currentEmi)
                    empLoanAdjDetail.Add(new EmpLoanDetail_GetRow_Result
                    {
                        SrNo = lastEmpLoanAdjDetail.SrNo + 1,
                        AmtVal = currentEmi.Value - Convert.ToDecimal(amount),
                        EffDate = lastEmpLoanAdjDetail.EffDate.AddMonths(1),
                        ChgsAmt = lastEmpLoanAdjDetail.ChgsAmt,
                        EdCd = lastEmpLoanAdjDetail.EdCd,
                        EdTyp = lastEmpLoanAdjDetail.EdTyp,
                        EndDate = lastEmpLoanAdjDetail.EndDate,
                        RecoTyp = lastEmpLoanAdjDetail.RecoTyp,
                        EmpCd = lastEmpLoanAdjDetail.EmpCd,
                        TransNo = lastEmpLoanAdjDetail.TransNo,
                        Typ = lastEmpLoanAdjDetail.Typ
                    });
                else if (amount > currentEmi)
                    empLoanAdjDetail = empLoanAdjDetail.Select(m => { m.AmtVal = m.EffDate.Month > Convert.ToInt32(currentMonth) ? emi : m.AmtVal; return m; }).ToList();
            }
            return PartialView("_LoanEmiTable", empLoanAdjDetail);
        }
        public IActionResult SaveEmpLoanAdj(IEnumerable<EmpLoanDetail_GetRow_Result> empLoanAdjDetail, string transNo, string type, string empCd, string processId)
        {
            _transactionService.DeleteEmpLoanDetailsAdj(transNo, type);
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
        public IActionResult ReceiptVoucher()
        {
            ViewBag.LoanTypeItems = _organisationService.GetLoanTypes().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.Sdes.Trim(),
            });
            ViewBag.RecModeItems = _commonService.GetSysCodes(SysCode.RecMode).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}"
            });
            return View();
        }
        public IActionResult FetchEmpLoanTransactions(string empCd, string type)
        {
            var loanData = _transactionService.GetEmpLoanDetail(empCd, type, string.Empty, string.Empty, _loggedInUser.CompanyCd);
            return Json(type == "6" ? loanData : loanData.FirstOrDefault());
        }
        public IActionResult SaveLoanReceiptVoucher(LoanReceiptVoucher model)
        {
            var loanData = _transactionService.GetEmpLoanDetail(model.TransNo, "2", string.Empty, string.Empty, _loggedInUser.CompanyCd).FirstOrDefault();
            int lastDayOfMonth = DateTime.DaysInMonth(model.PaymentDt.Value.Year, model.PaymentDt.Value.Month);
            var endDate = new DateTime(model.PaymentDt.Value.Year, model.PaymentDt.Value.Month, lastDayOfMonth);
            var loanTypeDetail = _organisationService.GetLoanTypes().FirstOrDefault(m => m.Cd.Trim() == model.LoanTypeCd);
            _transactionService.SaveEmpLoanAdj(new EmpLoanDetail_GetRow_Result
            {
                TransNo = model.TransNo,
                SrNo = loanData.DetailSrno + 1,
                EmpCd = model.EmployeeCode,
                EdCd = loanTypeDetail.DedCd,
                EdTyp = loanTypeDetail.DedTypCd,
                EffDate = model.PaymentDt.Value,
                RecoTyp = model.RecoMode,
                Typ = "D",
                AmtVal = model.PayAmt,
                EndDate = endDate,
                ChgsAmt = 0,
                EntryBy = _loggedInUser.UserAbbr,
            });
            TempData["success"] = $"Loan adjusted successfully";
            return RedirectToAction("ReceiptVoucher");
        }
        #endregion

        #region Employee Provision Adjustment
        public IActionResult EmpProvisionAdj()
        {
            return View();
        }
        public IActionResult FetchProvisionAdjData()
        {
            var transferData = _transactionService.GetEmpProvisionAdjData(string.Empty, "6", _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee);
            CommonResponse result = new()
            {
                Data = transferData,
            };
            return Json(result);
        }
        public IActionResult GetProvisionAdj(string transNo)
        {
            var empprovisionsadj = _transactionService.GetEmpProvisionAdjData(transNo, "2", _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee).FirstOrDefault();
            var model = new EmpprovisionsadjModel();
            if (empprovisionsadj != null)
                model = new EmpprovisionsadjModel
                {
                    Amt = empprovisionsadj.Amt,
                    ApprBy = empprovisionsadj.Current_Approval?.Trim(),
                    ApprDt = DateTime.Now.Date,
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
                    CurrentApproval = empprovisionsadj.Current_Approval,
                    CurrentApprovalLevel = empprovisionsadj.Current_Approval_Level,
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
            model.ApprBy = _loggedInUser.UserOrEmployee == "E" ? _loggedInUser.UserAbbr : model.ApprBy;
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
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
                if (!validHeader)
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            ViewBag.PayTypeItems = _commonService.GetSysCodes(SysCode.ComponentClass).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
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
                item.Narr = $"Variable Pay Component {item.Curr}: {item.Amt}";
                item.TransId = "M";
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
            model.ApprBy = _loggedInUser.UserCd;
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
            ViewBag.CompanyItems = _dbGatewayService.GetCompanies().Select(m => new SelectListItem
            {
                Text = m.CoName,
                Value = m.Cd.Trim()
            });
            ViewBag.VehicleItems = _organisationService.GetVehicles().Select(m => new SelectListItem
            {
                Text = $"{m.Brand} {m.SDes.Trim()}({m.Cd.Trim()})",
                Value = m.Cd.Trim()
            });
            return View();
        }
        public IActionResult GetRenewalEmpDocument(string empCd, string docTypeCd, int srNo)
        {
            var empDocument = _employeeService.GetDocuments(empCd, docTypeCd, srNo, "A", _loggedInUser.UserCd).FirstOrDefault();
            var model = new EmpDocumentModel();
            if (empDocument != null)
                model = new EmpDocumentModel
                {
                    Cd = empDocument.EmpCd,
                    EmpCd = empDocument.EmpCd,
                    DocNo = empDocument.DocNo,
                    DocTypSDes = empDocument.DocTypSDes,
                    DocTypCd = empDocument.DocTypCd.Trim(),
                    Expiry = empDocument.Expiry,
                    ExpDt = empDocument.ExpDt,
                    IssueDt = empDocument.IssueDt,
                    SrNo = _transactionService.EmpDocIssueRcpt_NextSrNo(empCd, empDocument.DocTypCd),
                    IssuePlace = empDocument.IssuePlace,
                    TrnDt = DateTime.Now.Date,
                };

            ViewBag.DocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.EmpDocType).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.DocStatusItems = _settingService.GetCodeGroupItems(CodeGroup.DocStatus).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            return PartialView("_RenewalEmpDocumentModal", model);
        }
        public IActionResult GetRenewalComDocument(string docTypeCd, string divCd)
        {
            var document = _organisationService.GetDocuments(_loggedInUser.CompanyCd).FirstOrDefault(m => m.DivCd.Trim() == divCd && m.DocTypCd.Trim() == docTypeCd);
            var model = new CompanyDocumentModel();
            if (document != null)
                model = new CompanyDocumentModel
                {
                    DocTypCd = document.DocTypCd.Trim().Split(" _")[0],
                    Cd = document.DocTypCd.Trim().Split(" _")[0],
                    DivCd = divCd.Trim(),
                    DivSDes = document.DivSDes,
                    DocNo = document.DocNo,
                    DocTypSDes = document.DocTypSDes,
                    IssueDt = document.IssueDt,
                    IssuePlace = document.IssuePlace,
                    RefNo = document.RefNo,
                    RefDt = document.RefDt,
                    Narr = document.Narr,
                    ExpDt = document.ExpDt,
                    CompanyCd = document.CoCd,
                    TrnDt = DateTime.Now.Date,
                    SrNo = _transactionService.ComDocIssueRcpt_NextSrNo(_loggedInUser.CompanyCd, document.DocTypCd),
                    DocsPaths = _organisationService.GetDocumentFiles(document.DivCd, document.DocTypCd, _loggedInUser.CompanyCd)
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
            return PartialView("_RenewalComDocumentModal", model);
        }
        public IActionResult GetRenewalVehicleDocument(string vehCd, string docType)
        {
            var vehicleDocument = _organisationService.GetVehicleDocuments(vehCd).FirstOrDefault(m => m.DocTypCd.Trim() == docType);
            var model = new VehDocumentModel();
            if (vehicleDocument != null)
                model = new VehDocumentModel
                {
                    Cd = vehicleDocument.VehCd,
                    IssueDt = vehicleDocument.IssueDt,
                    IssuePlace = vehicleDocument.IssuePlace,
                    OthRefNo = vehicleDocument.OthRefNo,
                    DocNo = vehicleDocument.DocNo,
                    DocTypCd = vehicleDocument.DocTypCd.Trim(),
                    DocTypSDes = vehicleDocument.DocTypSDes,
                    VehName = vehicleDocument.VehName,
                    ExpDt = vehicleDocument.ExpDt,
                    TrnDt = DateTime.Now.Date,
                    SrNo = _transactionService.VehDocIssueRcpt_NextSrNo(vehCd, docType),
                    VehCd = vehCd,
                    VehicleDocsPaths = _organisationService.GetVehicleDocumentFiles(vehCd)
                };

            ViewBag.DocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.VehicleDocType).Select(m => new SelectListItem
            {
                Text = $"{m.ShortDes}({m.Code.Trim()})",
                Value = m.Code.Trim(),
            });
            ViewBag.DocStatusItems = _settingService.GetCodeGroupItems(CodeGroup.DocStatus).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            return PartialView("_RenewalVehDocumentModal", model);
        }
        public IActionResult SaveRenewalEmpDocument(EmpDocumentModel model)
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
        public IActionResult SaveRenewalComDocument(CompanyDocumentModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            _transactionService.SaveComDocIssueReceipt(model);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Document renewal requested successfully"
            };
            return Json(result);
        }
        public IActionResult SaveRenewalVehDocument(VehDocumentModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            _transactionService.SaveVehDocIssueReceipt(model);
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Document renewal requested successfully"
            };
            return Json(result);
        }
        public IActionResult FetchEmpDocRenewalData()
        {
            var docs = _transactionService.GetEmpDocIssueRcpt(string.Empty, string.Empty, 0, _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee, "1");
            CommonResponse result = new()
            {
                Data = docs,
            };
            return Json(result);
        }
        public IActionResult GetRenewalDocumentApproval(string empCd, string docTypeCd, int srNo)
        {
            var document = _transactionService.GetEmpDocIssueRcpt(empCd, docTypeCd, srNo, _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee, "2").FirstOrDefault();
            document.DocType = document.DocType.Trim();
            document.DocStat = document.DocStat.Trim();
            ViewBag.EmpDocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.EmpDocType).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.ComDocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.CompanyDocType).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.VehDocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.VehicleDocType).Select(m => new SelectListItem
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
            var action = model.Status == "A" ? "approved" : "rejected";
            var result = new CommonResponse
            {
                Success = true,
                Message = $"Document renewal {action} successfully"
            };
            return Json(result);
        }
        #endregion

        #region Pre Payroll Process
        public IActionResult PrePayRollProcess()
        {
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            return View();
        }
        public IActionResult SavePrePayRollProcess(string MonthYear, string Branch, bool confirmed = false)
        {
            var spMonthYear = MonthYear.Split('/');
            var Period = Convert.ToInt32(spMonthYear[0]).ToString("00");
            var Year = spMonthYear[1];
            bool isValidDeno = _transactionService.ValiatePrePayrollDeno("DENO", _loggedInUser.CompanyCd);
            bool isValidBank = _transactionService.ValiatePrePayrollDeno("BANK", _loggedInUser.CompanyCd);
            bool isValidVBank = _transactionService.ValiatePrePayrollDeno("VBANK", _loggedInUser.CompanyCd);
            bool isValidCBank = _transactionService.ValiatePrePayrollDeno("CBANK", _loggedInUser.CompanyCd);

            string msg = "<ul class='text-left'>";
            if (isValidDeno)
                msg += "<li>Please enter Cash Denomination</li>";
            if (isValidBank)
                msg += "<li>Please enter Bank Account</li>";
            if (isValidVBank)
                msg += "<li>Please enter Bank CAccount</li>";
            if (isValidCBank)
                msg += "<li>Please Net Pay Bank</li>";
            msg += "</ul>";
            if (confirmed)
            {
                _commonService.PrePayrollProcess(Period, Year, Branch, _loggedInUser.CompanyCd);
                var result = new CommonResponse
                {
                    Success = true,
                    Message = "Pre Payroll Process completed Succesfully"
                };
                return Json(result);
            }
            return Json(new CommonResponse
            {
                Success = false,
                Message = msg
            });
        }
        #endregion

        #region Employee Progression
        public IActionResult EmployeeProgression()
        {
            return View();
        }
        public IActionResult FetchEmployeeProgressionData()
        {
            var progressionData = _transactionService.GetEmpProgressionData(string.Empty, string.Empty, _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee);
            CommonResponse result = new()
            {
                Data = progressionData,
            };
            return Json(result);
        }
        public IActionResult GetEmployeeProgression(string transNo)
        {
            var empProgressionHead = _transactionService.GetEmpProgressionData(transNo, "1", _loggedInUser.UserAbbr, _loggedInUser.UserOrEmployee).FirstOrDefault();
            var model = new EmpProgressionHeadModel();
            if (empProgressionHead != null)
            {
                model = new EmpProgressionHeadModel
                {
                    TransNo = transNo,
                    TransDt = empProgressionHead.TransDt,
                    DesigFrom = empProgressionHead.DesigFrom,
                    DesigTo = empProgressionHead.DesigTo,
                    DesigFromCd = empProgressionHead.DesigFromCd.Trim(),
                    DesigToCd = empProgressionHead.DesigToCd.Trim(),
                    EmpCode = empProgressionHead.EmpCode,
                    Name = empProgressionHead.Name,
                    ApprBy = empProgressionHead.Current_Approval,
                    Current_Approval_Level = empProgressionHead.Current_Approval_Level,
                    EP_Typ = empProgressionHead.EP_Typ,
                    EP_TypeCd = empProgressionHead.EP_TypeCd.Trim(),
                    Remarks = empProgressionHead.Remarks,
                };
                var empProgressionDetail = _transactionService.GetEmpProgressionDetail(transNo);
                if (empProgressionDetail != null)
                {
                    model.PayTypCd = empProgressionDetail.PayTypCd.Trim();
                    model.PayCodeCd = empProgressionDetail.PayCodeCd.Trim();
                    model.PercAmt = empProgressionDetail.PercAmt;
                    model.CurrentAmt = empProgressionDetail.Current;
                    model.RevisedAmt = empProgressionDetail.Incremented;
                    model.Narr = empProgressionDetail.Narr;
                }
            }
            else
            {
                model.TransNo = _transactionService.GetNextToolTransNo(_loggedInUser.CompanyCd, "EPH");
                model.TransDt = DateTime.Now.Date;
            }
            ViewBag.ProgressionTypeItems = _commonService.GetSysCodes(SysCode.EmpProgression).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.DesignationItems = _organisationService.GetDesignations().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
            ViewBag.ComponentClassTypeItems = _commonService.GetSysCodes(SysCode.ComponentClass).Select(m => new
            SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
            ViewBag.ComponentClassItems = _employeeService.GetComponentClasses(model.PayTypCd?.Trim()).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PercentageAmtItems = _commonService.GetPercentageAmtTypes();
            return PartialView("_EmpProgressionModal", model);
        }
        public IActionResult GetCurrentAmt(string empCd, string edTypeDes, string edCdDes)
        {
            var result = _transactionService.GetCurrentAmt(empCd, edTypeDes, edCdDes);
            result.PercAmt = result.PercAmt == "A" ? "AMOUNT" : "PERCENTAGE";
            return Json(result);
        }
        [HttpPost]
        public IActionResult SaveEmployeeProgression(EmpProgressionHeadModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            _transactionService.UpdateEmpProgHead(model);
            if (model.EP_TypeCd == "HREP02" || model.EP_TypeCd == "HREP04" || model.EP_TypeCd == "HREP05")
                _transactionService.UpdateEmpProgDetail(model);
            var result = new CommonResponse
            {
                Success = true,
                Message = "Emp Progression requested successfully"
            };
            return Json(result);
        }
        [HttpPost]
        public IActionResult ApproveEmployeeProgression(EmpProgressionHeadModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            model.ApprBy = _loggedInUser.UserOrEmployee == "E" ? _loggedInUser.UserAbbr : model.ApprBy;
            _transactionService.UpdateEmpProgAppr(model);
            if (model.EP_TypeCd == "HREP02" || model.EP_TypeCd == "HREP04" || model.EP_TypeCd == "HREP05")
                _transactionService.UpdateEmpProgDetail(model);
            var result = new CommonResponse
            {
                Success = true,
                Message = "Emp Progression approved successfully"
            };
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteEmployeeProgression(string transNo)
        {
            _transactionService.DeleteEmpPrgression(transNo);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        public IActionResult ImportEmployeeProgression(IFormFile file, EmpProgressionHeadModel model)
        {
            ViewBag.DesignationItems = _organisationService.GetDesignations().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
            model.EntryBy = _loggedInUser.UserAbbr;
            var excelData = _transactionService.GetProgressionFromExcel(file, _loggedInUser.CompanyCd);
            foreach (var excel in excelData)
            {
                excel.TransDt = model.TransDt;
                var employee = _employeeService.FindEmployee(excel.EmpCode, _loggedInUser.CompanyCd);
                if (employee != null)
                {
                    excel.EmpName = employee.Name;
                    excel.DesigFromCd = employee.Desg.Trim();
                    excel.DesigToCd = employee.Desg.Trim();
                }
                if (model.EP_TypeCd == "HREP02" || model.EP_TypeCd == "HREP04" || model.EP_TypeCd == "HREP05")
                {
                    excel.EP_TypeCd = model.EP_TypeCd;
                    excel.EffDt = model.EffDt;
                    excel.PayTypCd = model.PayTypCd;
                    excel.PayCodeCd = model.PayCodeCd;
                    excel.PercAmt = model.PercAmt;
                    var CurrentAmt = _transactionService.GetCurrentAmt(excel.EmpCode, model.PayTypCd, model.PayCodeCd);
                    if (CurrentAmt != null)
                    {
                        excel.CurrentAmt = CurrentAmt.Amount;
                        excel.PercAmt = CurrentAmt.PercAmt;
                    }
                    excel.Narr = model.Narr;
                }
            }
            var validData = excelData.Where(m => m.IsValid);
            var invalidData = excelData.Where(m => !m.IsValid);
            string Message = string.Empty;
            bool validHeader = _transactionService.ValidHeaderVariblePayComponentsExcel(file);
            if (!validHeader)
            {
                return Json(new CommonResponse
                {
                    Success = false,
                    Message = "Headers are not matched. Download again & refill data"
                });
            }
            else
                return PartialView("_EmpProgressionData", excelData);
        }
        [HttpPost]
        public IActionResult SaveBulkEmployeeProgression(List<EmpProgressionHeadModel> model, EmpProgressionHeadModel filterModel)
        {
            var validData = model.Where(m => m.IsValid);
            foreach (var item in validData)
            {
                item.EntryBy = _loggedInUser.UserAbbr;
                item.TransNo = _transactionService.GetNextToolTransNo(_loggedInUser.CompanyCd, "EPH");
                item.TransDt = DateTime.Now.Date;
                item.PayCodeCd = filterModel.PayCodeCd;
                item.PayTypCd = filterModel.PayTypCd;
                item.EP_TypeCd = filterModel.EP_TypeCd;
                item.Narr = filterModel.Narr;
                _transactionService.UpdateEmpProgHead(item);
                if (item.EP_TypeCd == "HREP02" || item.EP_TypeCd == "HREP04" || item.EP_TypeCd == "HREP05")
                    _transactionService.UpdateEmpProgDetail(item);
            }
            var result = new CommonResponse
            {
                Success = true,
                Message = $"{validData} records Emp Progression requested successfully"
            };
            if (!validData.Any())
            {
                result.Success = false;
                result.Message = "No record found to import";
            }
            return Json(result);
        }
        #endregion

        public IActionResult SinglePayroll()
        {
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.CurrentMonth = currentMonth;
            ViewBag.CurrentYear = currentYear;
            return View();
        }
        public IActionResult SinglePayrollSalaryAttendance(string EmpCd, string DateRange)
        {
            var DateSp = DateRange.Split(" - ");
            var FromDt = Convert.ToDateTime(DateSp[0]);
            var prd = $"{FromDt.Year}{FromDt.Month:00}";
            var empSinglePayroll = _transactionService.GetEmpAttendance_Salary_SinglePayroll(EmpCd, prd, _loggedInUser.CompanyCd);
            foreach (var item in empSinglePayroll.Salary_SinglePayrollAttendanceData)
                item.Payable = item.NoOfDays - item.P_HDays - item.Up_HDays;
            var totalWDays = empSinglePayroll.Salary_SinglePayrollAttendanceData.Sum(m => m.NoOfDays);
            var totalPayable = empSinglePayroll.Salary_SinglePayrollAttendanceData.Sum(m => m.Payable);
            foreach (var item in empSinglePayroll.Component_SinglePayrollAttendanceData)
                item.UpdatedAmt = Convert.ToDecimal(item.Amt / totalWDays) * totalPayable;
            return PartialView("_SinglePayrollConfirm", new EmpLeaveConfirmModel
            {
                Salary_SinglePayrollAttendanceData = empSinglePayroll.Salary_SinglePayrollAttendanceData,
                Component_SinglePayrollAttendanceData = empSinglePayroll.Component_SinglePayrollAttendanceData
            });
        }
        public IActionResult SaveSinglePayroll(EmpLeaveConfirmModel model, string processId)
        {
            if (model.SinglePayroll)
            {
                var employee = _employeeService.FindEmployee(model.EmpCd, _loggedInUser.CompanyCd);
                var WorkingHrDay = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "WORKHRS").Val;
                var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
                var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
                foreach (var item in model.Salary_SinglePayrollAttendanceData)
                {
                    var attendance = new EmpAttendance_Getrow_Result
                    {
                        Cd = model.EmpCd,
                        Up_HDays = item.Up_HDays,
                        W_days = item.NoOfDays,
                        NHrs = Convert.ToInt32((item.NoOfDays - item.Up_HDays - item.P_HDays) * float.Parse(WorkingHrDay)),
                        Payable = item.Payable,
                    };
                    var attendanceFilter = new AttendanceFilterModel
                    {
                        Branch = item.DivCd,
                        Department = employee.Dept,
                        EmpCd = model.EmpCd,
                        MonthYear = $"{currentYear}{currentMonth}",
                        WorkingHrDay = WorkingHrDay,
                        EntryBy = _loggedInUser.UserAbbr
                    };
                    _transactionService.UpdateEmpMonthlyAttendance(attendance, attendanceFilter);
                }
                int srNo = 1;
                foreach (var item in model.Component_SinglePayrollAttendanceData)
                {
                    var payComponent = new EmpTrans_VarCompFixAmt_GetRow_Result
                    {
                        Amt = item.UpdatedAmt,
                        Branch = employee.Div,
                        Cd = model.EmpCd,
                        Curr = employee.CurrCd,
                        Dept = employee.Dept,
                        SrNo = srNo,
                        Narr = "SinglePayroll",
                        TransId = "*S"
                    };
                    var EdTyp = item.DesCd[..6];
                    var EdCd = item.DesCd.Substring(6, 3);
                    int lastDayOfMonth = DateTime.DaysInMonth(Convert.ToInt32(currentYear), Convert.ToInt32(currentMonth));
                    var payComponentFilter = new VariablePayDedComponentFilterModel
                    {
                        Branch = employee.Div,
                        Department = employee.Dept,
                        EmpCd = model.EmpCd,
                        EntryBy = _loggedInUser.UserAbbr,
                        MonthYear = $"{currentYear}{currentMonth}",
                        PayType = EdTyp,
                        PayCode = EdCd,
                        FromDt = new DateTime(Convert.ToInt32(currentYear), Convert.ToInt32(currentMonth), 1),
                        ToDt = new DateTime(Convert.ToInt32(currentYear), Convert.ToInt32(currentMonth), lastDayOfMonth),
                    };
                    _transactionService.EmpTrans_Update(payComponent, payComponentFilter);
                    srNo++;
                }
            }
            //if (model.PrintAfterSave)
            //{

            //}
            var ActivityAbbr = "UPD";
            var Message = $", Single Payroll submitted With Trans no={model.TransNo}";
            _commonService.SetActivityLogDetail("0", processId, ActivityAbbr, Message);
            var result = new CommonResponse
            {
                Success = true,
                Message = "Single Payroll submitted successfully"
            };
            return Json(result);
        }
        public IActionResult EmpSepration()
        {
            ViewBag.SeprationTypeItems = _commonService.GetSysCodes(SysCode.SeprationType).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            return View();
        }
        public IActionResult EmpSeprationLetter(EmpSeprationFilterModel filterModel, bool pdf)
        {
            var seprationData = _transactionService.GetEmpSeprationDetail(filterModel);
            if (pdf)
                return new ViewAsPdf("EmpSeprationReport", seprationData)
                {
                    PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                };
            return PartialView("_EmpSettlementLetter", seprationData);
        }
    }
}
