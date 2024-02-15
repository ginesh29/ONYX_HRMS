using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class OrganisationController : Controller
    {
        private readonly AuthService _authService;
        private readonly OrganisationService _organisationService;
        private readonly CommonService _commonService;
        private readonly SettingService _settingService;
        private readonly UserEmployeeService _userEmployeeService;
        private readonly EmailService _emailService;
        private readonly LoggedInUserModel _loggedInUser;
        public OrganisationController(AuthService authService, OrganisationService organisationService, CommonService commonService, SettingService settingService, UserEmployeeService userEmployeeService, EmailService emailService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _organisationService = organisationService;
            _commonService = commonService;
            _settingService = settingService;
            _userEmployeeService = userEmployeeService;
            _emailService = emailService;
        }
        #region Component
        public IActionResult Components()
        {
            return View();
        }
        public IActionResult FetchComponents()
        {
            var components = _organisationService.GetComponents();
            CommonResponse result = new()
            {
                Data = components,
            };
            return Json(result);
        }
        public IActionResult GetComponent(string cd)
        {
            var component = _organisationService.GetComponents().FirstOrDefault(m => m.Cd.Trim() == cd);
            var model = new EarnDedModel();
            if (component != null)
                model = new EarnDedModel
                {
                    Cd = component.Cd,
                    Code = component.Cd,
                    Abbriviation = component.Abbr,
                    Description = component.Des,
                    JobCosting = component.JobCosting == "Yes",
                    LoanTyp = component.LoanTyp == "Yes",
                    OT = component.OT == "Yes",
                    OtCd = component.OtCd == "Yes",
                    PercAmt_Cd = component.PercAmt_Cd,
                    Perc_Amt = component.Perc_Amt,
                    Perc_Val = component.Perc_Val,
                    TrnTyp = component.TrnTyp,
                    TrnTypCd = component.TrnTypCd,
                    SDes = component.SDes,
                    TypeCd = component.TypeCd,
                    TypeDesc = component.TypeDesc,
                };
            ViewBag.ComponentClassItems = _commonService.GetSysCodes(SysCode.ComponentClass).Select(m => new SelectListItem { Value = m.Cd, Text = m.SDes });
            ViewBag.ComponentTypeItems = _commonService.GetComponentTypes();
            ViewBag.PercentageAmtItems = _commonService.GetPercentageAmtTypes();
            return PartialView("_ComponentModal", model);
        }
        [HttpPost]
        public IActionResult SaveComponent(EarnDedModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveComponent(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteComponent(string cd, string type)
        {
            _organisationService.DeleteComponent(cd, type);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Loan Type
        public IActionResult LoanTypes()
        {
            return View();
        }
        public IActionResult GetLoanType(string cd)
        {
            var component = _organisationService.GetLoanTypes().FirstOrDefault(m => m.Cd.Trim() == cd);
            var model = new LoanTypeModel();
            if (component != null)
                model = new LoanTypeModel
                {
                    Code = component.Cd,
                    Abbriviation = component.Abbr,
                    ChgsTyp = component.ChgsTyp,
                    ChgsTypCd = component.ChgsTypCd.Trim(),
                    DedCd = component.DedCd,
                    DedComp = component.DedComp,
                    DedTyp = component.DedTyp,
                    DedTypCd = component.DedTypCd,
                    Description = component.Des,
                    IntPerc = component.IntPerc,
                    PayCd = component.PayCd,
                    PayComp = component.PayComp,
                    PayTyp = component.PayTyp,
                    PayTypCd = component.PayTypCd,
                    SDes = component.Sdes,
                };
            ViewBag.PayComponentItems = _commonService.GetEarnDedTypes("HEDT03").Select(m => new SelectListItem { Value = m.Cd, Text = m.SDes });
            ViewBag.DeductionComponentItems = _commonService.GetEarnDedTypes("HEDT02").Select(m => new SelectListItem { Value = m.Cd, Text = m.SDes });
            ViewBag.ChargesTypesItems = _commonService.GetChargesTypes();
            return PartialView("_LoanTypeModal", model);
        }
        public IActionResult FetchLoanTypes()
        {
            var loanTypes = _organisationService.GetLoanTypes();
            CommonResponse result = new()
            {
                Data = loanTypes,
            };
            return Json(result);
        }
        [HttpPost]
        public IActionResult SaveLoanType(LoanTypeModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveLoanType(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteLoanType(string cd)
        {
            _organisationService.DeleteLoanType(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Working Hour
        public IActionResult WorkingHours()
        {
            return View();
        }
        public IActionResult FetchWorkingHours()
        {
            var workingHours
                = _organisationService.GetWorkingHours(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = workingHours,
            };
            return Json(result);
        }
        public IActionResult GetWorkingHour(string cd)
        {
            var component = _organisationService.GetWorkingHours(_loggedInUser.CompanyCd).FirstOrDefault(m => m.Code.Trim() == cd);
            var model = new WorkingHourModel();
            if (component != null)
                model = new WorkingHourModel
                {
                    Code = component.Code,
                    Cd = component.Code,
                    DutyHrs = component.DutyHrs,
                    FromDt = component.FromDt,
                    ToDt = component.ToDt,
                    HolTypCd = component.HolTypCd.Trim(),
                    HolTypDesc = component.HolTypDesc,
                    Description = component.Narr,
                    RelgTypCd = component.RelgTypCd.Trim(),
                    Religion = component.Religion,
                };
            ViewBag.DayTypeItems = _commonService.GetSysCodes(SysCode.DayType).Select(m => new SelectListItem { Value = m.Cd.Trim(), Text = m.SDes });
            ViewBag.ReligionItems = _commonService.GetSysCodes(SysCode.Religion).Select(m => new SelectListItem { Value = m.Cd.Trim(), Text = m.SDes });
            return PartialView("_WorkingHourModal", model);
        }
        [HttpPost]
        public IActionResult SaveWorkingHour(WorkingHourModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveWorkingHour(model, _loggedInUser.CompanyCd);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteWorkingHour(string cd)
        {
            _organisationService.DeleteWorkingHour(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Overtime Rate
        public IActionResult OvertimeRates()
        {

            return View();
        }
        public IActionResult FetchOvertimeRates()
        {
            var overtimeRates = _organisationService.GetOvertimeRates(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = overtimeRates,
            };
            return Json(result);
        }
        public IActionResult GetOvertimeRate(int Cd, string type)
        {
            var overtimeRate = _organisationService.GetOvertimeRates(_loggedInUser.CompanyCd).FirstOrDefault(m => m.SrNo == Cd && m.TypCd.Trim() == type);
            var model = new OvertimeRateModel();
            if (overtimeRate != null)
                model = new OvertimeRateModel
                {
                    HolTyp = overtimeRate.HolTyp,
                    HolTypCd = overtimeRate.HolTypCd.Trim(),
                    HrsApply = overtimeRate.HrsApply,
                    Narr = overtimeRate.Narr,
                    PayCd = overtimeRate.PayCd.Trim(),
                    PayCode = overtimeRate.PayCode.Trim(),
                    Rate = overtimeRate.Rate,
                    Sdes = overtimeRate.Sdes,
                    TypCd = overtimeRate.TypCd.Trim(),
                    Type = overtimeRate.Type,
                    SrNo = overtimeRate.SrNo
                };
            else
                model.SrNo = _organisationService.GetOvertimeRate_SrNo(_loggedInUser.CompanyCd, type);
            ViewBag.OtTypeItems = _commonService.GetSysCodes(SysCode.OtTpe).Select(m => new SelectListItem { Value = m.Cd.Trim(), Text = m.SDes });
            ViewBag.DayTypeItems = _commonService.GetSysCodes(SysCode.DayType).Select(m => new SelectListItem { Value = m.Cd.Trim(), Text = m.SDes });
            ViewBag.PayElementItems = _commonService.GetPayElements().Select(m => new SelectListItem { Value = m.Cd.Trim(), Text = m.SDes });
            return PartialView("_OvertimeRateModal", model);
        }
        [HttpPost]
        public IActionResult SaveOvertimeRate(OvertimeRateModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveOvertimeRate(model, _loggedInUser.CompanyCd);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteOvertimeRate(string cd, string type)
        {
            _organisationService.DeleteOvertimeRate(cd, type, _loggedInUser.CompanyCd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Calendar
        public IActionResult Calendar()
        {
            return View();
        }
        public IActionResult FetchCalendarEvents()
        {
            var events = _organisationService.GetCalendarEvents(_loggedInUser.CompanyCd).Select(m => new CalendarModel
            {
                Id = m.Cd.Trim(),
                AllDay = true,
                BackgroundColor = "#f56954",
                BorderColor = "#f56954",
                Start = m.Date.ToString("yyyy-MM-ddTHH:mm:ss"),
                Title = m.Description
            });
            return Json(events);
        }
        public IActionResult GetCalendarEvent(string Cd)
        {
            var calendarEvent = _organisationService.GetCalendarEvents(_loggedInUser.CompanyCd).FirstOrDefault(m => m.Cd == Cd);
            var model = new CompanyCalendarModel();
            if (calendarEvent != null)
                model = new CompanyCalendarModel
                {
                    Cd = calendarEvent.Cd,
                    Code = calendarEvent.Cd,
                    CoCd = calendarEvent.CoCd,
                    Date = calendarEvent.Date,
                    Description = calendarEvent.Description,
                    Holiday = calendarEvent.Holiday,
                    MeetingLink = calendarEvent.MeetingLink
                };
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Text = m.Department,
                Value = m.Code
            });
            ViewBag.DesignationItems = _organisationService.GetDesignations().Select(m => new SelectListItem
            {
                Text = m.SDes,
                Value = m.Cd
            });
            ViewBag.BranchItems = _settingService.GetBranches(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Text = m.SDes,
                Value = m.Cd
            });
            ViewBag.EmpDeployLocationItems = _commonService.GetCodesGroups(SysCode.EmpDeployLoc).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code
            });
            ViewBag.EmployeeItems = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Text = $"{m.Fname} {m.Lname}",
                Value = m.Cd.Trim()
            });
            return PartialView("_CalendarEventModal", model);
        }
        [HttpPost]
        public async Task<IActionResult> SaveCalendarEvent(CompanyCalendarModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveCalendarEvent(model, _loggedInUser.CompanyCd);
            if (result.Success)
            {
                _organisationService.SaveCalendarEventAttendees(model.Cd, model.Attendees);
                var emps = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd).Where(m => model.Attendees.Contains(m.Cd.Trim()));
                await _emailService.SendEmailAsync("ginesh@yopmail.com", "TestEmail", "Email Body");
            }
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteCalendarEvent(string cd)
        {
            _organisationService.DeleteCalendarEvent(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Notification
        public IActionResult Notifications()
        {
            return View();
        }
        public IActionResult FetchNotifications()
        {
            var overtimeRates = _organisationService.GetNotifications(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = overtimeRates,
            };
            return Json(result);
        }
        public IActionResult GetNotification(int Cd, string docType)
        {
            var notification = _organisationService.GetNotifications(_loggedInUser.CompanyCd).FirstOrDefault(m => m.SrNo == Cd && m.DocTyp.Trim() == docType);
            var model = new NotificationModel();
            if (notification != null)
                model = new NotificationModel
                {
                    BeforeOrAfter = notification.BeforeOrAfter,
                    CoCd = notification.CoCd,
                    DocTyp = notification.DocTyp.Trim(),
                    DocTypDes = notification.DocTypDes,
                    EmailIds = notification.EmailIds,
                    MessageBody = notification.MessageBody,
                    NoOfDays = notification.NoOfDays,
                    Type = notification.NotificationType,
                    ProcessId = notification.ProcessId,
                    SrNo = notification.SrNo,
                };
            ViewBag.TypeItems = _organisationService.GetNotificationTypes(_loggedInUser.CompanyCd).Select(m => new SelectListItem { Value = m.ParameterCd.Trim(), Text = m.Val });
            ViewBag.DocumentTypeItems = _commonService.GetCodesGroups("HDTYP").Select(m => new SelectListItem { Value = m.Code.Trim(), Text = m.ShortDes });
            ViewBag.BeforeAfter = _commonService.GetBeforeAfter();
            return PartialView("_NotificationModal", model);
        }
        [HttpPost]
        public IActionResult SaveNotification(NotificationModel model)
        {
            model.SrNo = model.SrNo > 0 ? model.SrNo : _organisationService.GetNotification_SrNo(_loggedInUser.CompanyCd, model.ProcessId, model.DocTyp);
            var result = _organisationService.SaveNotificationMaster(model, _loggedInUser.CompanyCd);
            if (result.Success)
            {
                _organisationService.DeleteNotificationDetail(model.SrNo, model.ProcessId, _loggedInUser.CompanyCd);
                foreach (var email in model.EmailIds.Split(","))
                    _organisationService.SaveNotificationDetail(model, email, _loggedInUser.CompanyCd);
            }
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteNotification(int cd, string processId)
        {
            _organisationService.DeleteNotificationDetail(cd, processId, _loggedInUser.CompanyCd);
            _organisationService.DeleteNotificationMaster(cd, processId, _loggedInUser.CompanyCd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Bank
        public IActionResult Banks()
        {
            return View();
        }
        public IActionResult FetchBanks()
        {
            var banks = _organisationService.GetBanks();
            CommonResponse result = new()
            {
                Data = banks,
            };
            return Json(result);
        }
        public IActionResult GetBank(string bankCd, string branchCd)
        {
            var bank = _organisationService.GetBanks().FirstOrDefault(m => m.BankCd.Trim() == bankCd && m.BranchCd.Trim() == branchCd);
            var model = new BankModel();
            if (bank != null)
                model = new BankModel
                {
                    BankCd = bank.BankCd.Trim(),
                    Cd = bank.BankCd.Trim(),
                    Address1 = bank.Address1,
                    Address2 = bank.Address2,
                    Address3 = bank.Address3,
                    BranchCd = bank.BranchCd.Trim(),
                    Contact = bank.Contact,
                    Email = bank.Email,
                    Fax = bank.Fax,
                    Phone = bank.Phone,
                    Swift = bank.Swift,
                    URL = bank.URL,
                };
            ViewBag.BankItems = _settingService.GetCodeGroupItems(CodeGroup.Bank).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.BranchItems = _settingService.GetCodeGroupItems(CodeGroup.BankBranch).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            return PartialView("_BankModal", model);
        }
        [HttpPost]
        public IActionResult SaveBank(BankModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveBank(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteBank(string bankCd, string branchCd)
        {
            _organisationService.DeleteBank(bankCd, branchCd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Document
        public IActionResult Documents()
        {
            return View();
        }
        public IActionResult FetchDocuments()
        {
            var documents = _organisationService.GetDocuments(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = documents,
            };
            return Json(result);
        }
        public IActionResult GetDocument(string docTypeCd, string divCd)
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
                };
            ViewBag.DocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.DocType).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.BranchItems = _settingService.GetBranches(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Text = m.SDes,
                Value = m.Cd.Trim(),
            });
            return PartialView("_DocumentModal", model);
        }
        [HttpPost]
        public IActionResult SaveDocument(CompanyDocumentModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveDocument(model, _loggedInUser.CompanyCd);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteDocument(string docTypeCd, string divCd)
        {
            _organisationService.DeleteDocument(docTypeCd, divCd, _loggedInUser.CompanyCd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Vehicle
        public IActionResult Vehicles()
        {
            return View();
        }
        public IActionResult FetchVehicles()
        {
            var vehicles = _organisationService.GetVehicles();
            CommonResponse result = new()
            {
                Data = vehicles,
            };
            return Json(result);
        }
        #endregion

        #region Designation
        public IActionResult Designations()
        {
            return View();
        }
        public IActionResult FetchDesignations()
        {
            var designations = _organisationService.GetDesignations();
            CommonResponse result = new()
            {
                Data = designations,
            };
            return Json(result);
        }
        #endregion

        #region Leave Type
        public IActionResult LeaveTypes()
        {
            return View();
        }
        public IActionResult FetchLeaveTypes()
        {
            var leaveTypes = _organisationService.GetLeaveTypes(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = leaveTypes,
            };
            return Json(result);
        }
        #endregion

        #region Leave Pay Component
        public IActionResult LeavePayComponents()
        {
            return View();
        }
        public IActionResult FetchLeavePayComponents()
        {
            var leaveTypes = _organisationService.GetLeavePayComponents(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = leaveTypes,
            };
            return Json(result);
        }
        #endregion

        #region Travel Fare
        public IActionResult TravelFares()
        {
            return View();
        }
        public IActionResult FetchTravelFares()
        {
            var travelfares = _organisationService.GetTravelFares();
            CommonResponse result = new()
            {
                Data = travelfares,
            };
            return Json(result);
        }
        #endregion

        #region Approval Process
        public IActionResult ApprovalProcesses()
        {
            return View();
        }
        public IActionResult FetchApprovalProcesses()
        {
            var approvalProcesses = _organisationService.GetApprovalProcesses(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = approvalProcesses,
            };
            return Json(result);
        }
        //public IActionResult GetApprovalProcess(int Cd, string docType)
        //{
        //    var notification = _organisationService.GetApprovalProcesses(_loggedInUser.CompanyCd).FirstOrDefault(m => m.SrNo == Cd && m.DocTyp.Trim() == docType);
        //    var model = new NotificationModel();
        //    if (notification != null)
        //        model = new NotificationModel
        //        {
        //            BeforeOrAfter = notification.BeforeOrAfter,
        //            CoCd = notification.CoCd,
        //            DocTyp = notification.DocTyp.Trim(),
        //            DocTypDes = notification.DocTypDes,
        //            EmailIds = notification.EmailIds,
        //            MessageBody = notification.MessageBody,
        //            NoOfDays = notification.NoOfDays,
        //            Type = notification.NotificationType,
        //            ProcessId = notification.ProcessId,
        //            SrNo = notification.SrNo,
        //        };
        //    ViewBag.TypeItems = _organisationService.GetNotificationTypes(_loggedInUser.CompanyCd).Select(m => new SelectListItem { Value = m.ParameterCd.Trim(), Text = m.Val });
        //    ViewBag.DocumentTypeItems = _commonService.GetCodesGroups("HDTYP").Select(m => new SelectListItem { Value = m.Code.Trim(), Text = m.ShortDes });
        //    ViewBag.BeforeAfter = _commonService.GetBeforeAfter();
        //    return PartialView("_NotificationModal", model);
        //}
        //[HttpPost]
        //public IActionResult SaveApprovalProcess(NotificationModel model)
        //{
        //    model.SrNo = model.SrNo > 0 ? model.SrNo : _organisationService.GetNotification_SrNo(_loggedInUser.CompanyCd, model.ProcessId, model.DocTyp);
        //    var result = _organisationService.SaveNotificationMaster(model, _loggedInUser.CompanyCd);
        //    if (result.Success)
        //    {
        //        _organisationService.DeleteNotificationDetail(model.SrNo, model.ProcessId, _loggedInUser.CompanyCd);
        //        foreach (var email in model.EmailIds.Split(","))
        //            _organisationService.SaveNotificationDetail(model, email, _loggedInUser.CompanyCd);
        //    }
        //    return Json(result);
        //}
        //[HttpDelete]
        //public IActionResult DeleteApprovalProcess(int cd, string processId)
        //{
        //    _organisationService.DeleteNotificationDetail(cd, processId, _loggedInUser.CompanyCd);
        //    _organisationService.DeleteNotificationMaster(cd, processId, _loggedInUser.CompanyCd);
        //    var result = new CommonResponse
        //    {
        //        Success = true,
        //        Message = CommonMessage.DELETED
        //    };
        //    return Json(result);
        //}
        #endregion
    }
}
