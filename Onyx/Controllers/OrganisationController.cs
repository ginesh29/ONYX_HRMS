using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;
using System.Data;
using System.Text;

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
        private readonly FileHelper _fileHelper;
        public OrganisationController(AuthService authService, OrganisationService organisationService, CommonService commonService, SettingService settingService, UserEmployeeService userEmployeeService, EmailService emailService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _organisationService = organisationService;
            _commonService = commonService;
            _settingService = settingService;
            _userEmployeeService = userEmployeeService;
            _emailService = emailService;
            _fileHelper = new FileHelper();
        }
        #region Component
        public IActionResult Components()
        {
            return View();
        }
        public IActionResult FetchComponents()
        {
            var components = _organisationService.GetComponents("");
            CommonResponse result = new()
            {
                Data = components,
            };
            return Json(result);
        }
        public IActionResult GetComponent(string cd)
        {
            var component = _organisationService.GetComponents("").FirstOrDefault(m => m.Cd.Trim() == cd);
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
            ViewBag.ComponentClassItems = _commonService.GetSysCodes(SysCode.ComponentClass).Select(m => new
            SelectListItem
            {
                Value = m.Cd,
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
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
            var loanType = _organisationService.GetLoanTypes().FirstOrDefault(m => m.Cd.Trim() == cd);
            var model = new LoanTypeModel();
            if (loanType != null)
                model = new LoanTypeModel
                {
                    Code = loanType.Cd,
                    Abbriviation = loanType.Abbr,
                    ChgsTyp = loanType.ChgsTyp,
                    ChgsTypCd = loanType.ChgsTypCd.Trim(),
                    DedCd = loanType.DedCd,
                    DedComp = loanType.DedComp,
                    DedTyp = loanType.DedTyp,
                    DedTypCd = loanType.DedTypCd,
                    Description = loanType.Des,
                    IntPerc = loanType.IntPerc,
                    PayCd = loanType.PayCd,
                    PayComp = loanType.PayComp,
                    PayTyp = loanType.PayTyp,
                    PayTypCd = loanType.PayTypCd,
                    SDes = loanType.Sdes,
                    Active = loanType.Active,
                };
            ViewBag.PayComponentItems = _commonService.GetEarnDedTypes("HEDT03").Select(m => new SelectListItem
            {
                Value = m.Cd,
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
            ViewBag.DeductionComponentItems = _commonService.GetEarnDedTypes("HEDT02").Select(m => new SelectListItem
            {
                Value = m.Cd,
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
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
            var workingHour = _organisationService.GetWorkingHours(_loggedInUser.CompanyCd).FirstOrDefault(m => m.Code.Trim() == cd);
            var model = new WorkingHourModel();
            if (workingHour != null)
                model = new WorkingHourModel
                {
                    Code = workingHour.Code,
                    Cd = workingHour.Code,
                    DutyHrs = workingHour.DutyHrs,
                    FromDt = workingHour.FromDt,
                    ToDt = workingHour.ToDt,
                    DateRange = $"{Convert.ToDateTime(workingHour.FromDt).ToString(CommonSetting.DateFormat)} - {Convert.ToDateTime(workingHour.ToDt).ToString(CommonSetting.DateFormat)}",
                    HolTypCd = workingHour.HolTypCd.Trim(),
                    HolTypDesc = workingHour.HolTypDesc,
                    Description = workingHour.Narr,
                    RelgTypCd = workingHour.RelgTypCd.Trim(),
                    Religion = workingHour.Religion,
                };
            ViewBag.DayTypeItems = _commonService.GetSysCodes(SysCode.DayType).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.ReligionItems = _commonService.GetSysCodes(SysCode.Religion).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
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
            ViewBag.OtTypeItems = _commonService.GetSysCodes(SysCode.OtTpe).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.DayTypeItems = _commonService.GetSysCodes(SysCode.DayType).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PayElementItems = _commonService.GetPayElements().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
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
                Title = m.Title
            });
            return Json(events);
        }
        public IActionResult GetCalendarEvent(string Cd)
        {
            var calendarEvent = _organisationService.GetCalendarEvents(_loggedInUser.CompanyCd, Cd).FirstOrDefault();
            var model = new CompanyCalendarModel();
            if (calendarEvent != null)
                model = new CompanyCalendarModel
                {
                    Cd = calendarEvent.Cd,
                    Code = calendarEvent.Cd,
                    CoCd = calendarEvent.CoCd,
                    Date = calendarEvent.Date,
                    MessageBody = calendarEvent.MessageBody,
                    Title = calendarEvent.Title,
                    Holiday = calendarEvent.Holiday,
                    EmailSubject = calendarEvent.EmailSubject,
                    Attendees = calendarEvent.Attendees.Length != 0 ? [.. calendarEvent.Attendees.Split(',')] : null,
                };
            else
                model.Cd = _organisationService.GetCalendarEvent_SrNo();
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Text = $"{m.Department}({m.Code.Trim()})",
                Value = m.Code.Trim()
            });
            ViewBag.DesignationItems = _organisationService.GetDesignations().Select(m => new SelectListItem
            {
                Text = $"{m.SDes}({m.Cd.Trim()})",
                Value = m.Cd.Trim()
            });
            ViewBag.BranchItems = _settingService.GetBranches(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Text = $"{m.SDes}({m.Cd.Trim()})",
                Value = m.Cd.Trim()
            });
            ViewBag.EmpDeployLocationItems = _commonService.GetCodesGroups(CodeGroup.EmpDeployLoc).Select(m => new SelectListItem
            {
                Text = $"{m.ShortDes}({m.Code.Trim()})",
                Value = m.Code.Trim()
            });
            return PartialView("_CalendarEventModal", model);
        }
        [HttpPost]
        public IActionResult SaveCalendarEvent(CompanyCalendarModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveCalendarEvent(model, _loggedInUser.CompanyCd);
            if (result.Success)
            {
                _organisationService.SaveCalendarEventAttendees(model.Cd, model.Attendees);
                var emps = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd).Where(m => model.Attendees.Contains(m.Cd.Trim()));
                var recipients = emps.Where(m => !string.IsNullOrEmpty(m.Email)).Select(m => new EmailRecipientModel
                {
                    RecipientEmail = m.Email,
                    RecipientName = m.Name
                });
                if (recipients.Any())
                {
                    foreach (var recipient in recipients)
                    {
                        string templatePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/EmailTemplates/main-template.html");
                        StringBuilder mainEmailTemplateHtml = new(System.IO.File.ReadAllText(templatePath));
                        mainEmailTemplateHtml.Replace("@YEAR", DateTime.Now.Year.ToString());
                        mainEmailTemplateHtml.Replace("@NAME", recipient.RecipientName);
                        mainEmailTemplateHtml.Replace("@EMAILTEXT", model.MessageBody);
                        _emailService.SendEmail(recipient, model.EmailSubject, mainEmailTemplateHtml.ToString());
                    }
                }
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
            var notifications = _organisationService.GetNotifications(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = notifications,
            };
            return Json(result);
        }
        public IActionResult GetNotification(int Cd, string processId, string docType)
        {
            var notification = _organisationService.GetNotifications(_loggedInUser.CompanyCd).FirstOrDefault(m => m.SrNo == Cd && m.DocTyp.Trim() == docType && m.ProcessId.Trim() == processId);
            var model = new NotificationModel();
            if (notification != null)
                model = new NotificationModel
                {
                    Cd = notification.DocTyp,
                    BeforeOrAfter = notification.BeforeOrAfter,
                    CoCd = notification.CoCd,
                    DocTyp = notification.DocTyp.Trim(),
                    DocTypDes = notification.DocTypDes,
                    MessageBody = notification.MessageBody,
                    NoOfDays = notification.NoOfDays,
                    Type = notification.NotificationType,
                    ProcessId = notification.ProcessId,
                    SrNo = notification.SrNo,
                    EmailSubject = notification.EmailSubject,
                    Attendees = notification.Attendees != null ? [.. notification.Attendees.Split(',')] : null,
                };
            else
                model.SrNo = _organisationService.GetNotification_SrNo(_loggedInUser.CompanyCd, model.ProcessId, model.DocTyp);
            ViewBag.TypeItems = _organisationService.GetNotificationTypes(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.ParameterCd.Trim(),
                Text = m.Val
            });
            ViewBag.DocumentTypeItems = _commonService.GetCodesGroups("HDTYP").Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.BeforeAfter = _commonService.GetBeforeAfter();
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Text = $"{m.Department}({m.Code.Trim()})",
                Value = m.Code.Trim()
            });
            ViewBag.DesignationItems = _organisationService.GetDesignations().Select(m => new SelectListItem
            {
                Text = $"{m.SDes}({m.Cd.Trim()})",
                Value = m.Cd.Trim()
            });
            ViewBag.BranchItems = _settingService.GetBranches(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Text = $"{m.SDes}({m.Cd.Trim()})",
                Value = m.Cd.Trim()
            });
            ViewBag.EmpDeployLocationItems = _commonService.GetCodesGroups(CodeGroup.EmpDeployLoc).Select(m => new SelectListItem
            {
                Text = $"{m.ShortDes}({m.Code.Trim()})",
                Value = m.Code.Trim()
            });
            return PartialView("_NotificationModal", model);
        }
        [HttpPost]
        public IActionResult SaveNotification(NotificationModel model)
        {
            var result = _organisationService.SaveNotificationMaster(model, _loggedInUser.CompanyCd);
            if (result.Success)
            {
                _organisationService.DeleteNotificationDetail(model.SrNo, model.ProcessId, _loggedInUser.CompanyCd);
                var emps = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd).Where(m => model.Attendees.Contains(m.Cd.Trim()));
                var recipients = emps.Select(m => new EmailRecipientModel
                {
                    Cd = m.Cd.Trim(),
                    RecipientEmail = m.Email,
                    RecipientName = m.Name
                });
                if (recipients.Any())
                {
                    foreach (var recipient in recipients)
                    {
                        _organisationService.SaveNotificationDetail(model, recipient.Cd, _loggedInUser.CompanyCd);
                        string templatePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/EmailTemplates/main-template.html");
                        StringBuilder mainEmailTemplateHtml = new(System.IO.File.ReadAllText(templatePath));
                        mainEmailTemplateHtml.Replace("@YEAR", DateTime.Now.Year.ToString());
                        mainEmailTemplateHtml.Replace("@NAME", recipient.RecipientName);
                        mainEmailTemplateHtml.Replace("@EMAILTEXT", model.MessageBody);
                        if (!string.IsNullOrEmpty(recipient.RecipientEmail))
                            _emailService.SendEmail(recipient, model.EmailSubject, mainEmailTemplateHtml.ToString());
                    }
                }
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
                    DocsPaths = _organisationService.GetDocumentFiles(document.DivCd, document.DocTypCd, _loggedInUser.CompanyCd)
                };
            ViewBag.DocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.DocType).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.BranchItems = _settingService.GetBranches(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Text = $"{m.SDes}({m.Cd.Trim()})",
                Value = m.Cd.Trim(),
            });
            return PartialView("_DocumentModal", model);
        }
        [HttpPost]
        public async Task<IActionResult> SaveDocument(CompanyDocumentModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveDocument(model, _loggedInUser.CompanyCd);
            if (result.Success)
            {
                if (model.DocFiles?.Count() > 0)
                {
                    var totalFiles = _organisationService.GetDocumentFiles(model.DivCd, model.DocTypCd, _loggedInUser.CompanyCd).Count();
                    string uploadedFilePath = string.Empty;
                    foreach (var item in model.DocFiles.Select((value, i) => new { i, value }))
                    {
                        if (item != null)
                        {
                            var filePath = await _fileHelper.UploadFile(item.value, "comp-doc", _loggedInUser.CompanyCd);
                            uploadedFilePath = filePath;
                            _organisationService.SaveDocumentFile(new CompDocImageModel
                            {
                                EntryBy = _loggedInUser.UserAbbr,
                                CompanyCode = _loggedInUser.CompanyCd,
                                DocumentTypeCd = model.DocTypCd,
                                ImageFile = uploadedFilePath,
                                SlNo = item.i + 1 + totalFiles,
                                DivCd = model.DivCd
                            });
                        }
                    }
                }
            }
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
        public IActionResult FetchDocumentFiles(string docTypeCd, string divCd)
        {
            var files = _organisationService.GetDocumentFiles(divCd, docTypeCd, _loggedInUser.CompanyCd);
            return PartialView("_DocFilesList", files);
        }
        [HttpDelete]
        public IActionResult DeleteDocumentFile(string divCd, string docTypCd, int slNo)
        {
            var documentFile = _organisationService.GetDocumentFiles(divCd, docTypCd, _loggedInUser.CompanyCd).FirstOrDefault(m => m.SlNo == slNo);
            _fileHelper.RemoveFile(documentFile.ImageFile, "comp-doc");
            var result = _organisationService.DeleteDocumentFile(divCd, docTypCd, slNo, _loggedInUser.CompanyCd);
            return Json(result);
        }
        [HttpPost]
        public async Task<IActionResult> UpdateDocumentFile(string docTypCd, string divCd, int SrNo, IFormFile file)
        {
            var uploadedFilePath = await _fileHelper.UploadFile(file, "comp-doc", _loggedInUser.CompanyCd);
            _organisationService.SaveDocumentFile(new CompDocImageModel
            {
                EntryBy = _loggedInUser.UserAbbr,
                CompanyCode = _loggedInUser.CompanyCd,
                DocumentTypeCd = docTypCd,
                ImageFile = uploadedFilePath,
                SlNo = SrNo,
                DivCd = divCd
            });
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.UPDATED
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
        public IActionResult GetVehicle(string cd)
        {
            var vehicle = _organisationService.GetVehicles().FirstOrDefault(m => m.Cd.Trim() == cd);
            var model = new CompanyVehicleModel();
            if (vehicle != null)
                model = new CompanyVehicleModel
                {
                    Cd = vehicle.Cd.Trim(),
                    Code = vehicle.Cd,
                    Branch = vehicle.Branch,
                    BranchCd = vehicle.BranchCd.Trim(),
                    Brand = vehicle.Brand,
                    ChassisNo = vehicle.ChassisNo,
                    Description = vehicle.Des,
                    Driver = vehicle.Driver,
                    DriverCd = vehicle.DriverCd.Trim(),
                    EngineNo = vehicle.EngineNo,
                    InsAmt = vehicle.InsAmt,
                    InsCo = vehicle.InsCo,
                    InsExpDt = vehicle.InsExpDt,
                    InsFrmDt = vehicle.InsFrmDt,
                    InsPolicyNo = vehicle.InsPolicyNo,
                    InsPrem = vehicle.InsPrem,
                    Location = vehicle.Location,
                    LocationCd = vehicle.LocationCd.Trim(),
                    ModelCd = vehicle.ModelCd.Trim(),
                    Narr = vehicle.Narr,
                    OrgPrice = vehicle.OrgPrice,
                    Owner = vehicle.Owner,
                    OwnerCd = vehicle.OWNERCd.Trim(),
                    PetrolCard = vehicle.PetrolCard,
                    PetrolCardAmt = vehicle.PetrolCardAmt,
                    PlateColor = vehicle.PlateColor,
                    PlateColorCd = vehicle.PlateColorCd.Trim(),
                    PurDt = vehicle.PurDt,
                    RegnExpDt = vehicle.RegnExpDt,
                    RegnFrmDt = vehicle.RegnFrmDt,
                    RegnNo = vehicle.RegnNo,
                    SDes = vehicle.SDes,
                    State = vehicle.State,
                    StateCd = vehicle.StateCd.Trim(),
                };
            ViewBag.BranchItems = _settingService.GetBranches(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Text = $"{m.SDes}({m.Cd.Trim()})",
                Value = m.Cd.Trim(),
            });
            ViewBag.LocationItems = _settingService.GetCodeGroupItems(CodeGroup.EmpDeployLoc).Select(m => new SelectListItem
            {
                Text = $"{m.ShortDes}({m.Code.Trim()})",
                Value = m.Code.Trim(),
            });
            ViewBag.StateItems = _settingService.GetCodeGroupItems(CodeGroup.State).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.OwnerItems = _settingService.GetCodeGroupItems(CodeGroup.Owner).Select(m => new SelectListItem
            {
                Text = $"{m.ShortDes}({m.Code.Trim()})",
                Value = m.Code.Trim(),
            });
            ViewBag.YearModelItems = _settingService.GetCodeGroupItems(CodeGroup.Model).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.PlateColorItems = _settingService.GetCodeGroupItems(CodeGroup.Color).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.DriverItems = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Text = $"{m.Name}({m.Cd.Trim()})",
                Value = m.Cd.Trim(),
            });
            return View("VehicleForm", model);
        }
        [HttpPost]
        public IActionResult SaveVehicle(CompanyVehicleModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveVehicle(model);
            TempData["success"] = result.Message;
            return RedirectToAction("GetVehicle", new { cd = model.Cd });
        }
        [HttpDelete]
        public IActionResult DeleteVehicle(string cd)
        {
            var result = _organisationService.DeleteVehicle(cd);
            return Json(result);
        }
        public IActionResult FetchVehicleDocuments(string vehCd)
        {
            var vehicleDocuments = _organisationService.GetVehicleDocuments(vehCd);
            CommonResponse result = new()
            {
                Data = vehicleDocuments,
            };
            return Json(result);
        }
        public IActionResult GetVehicleDocument(string vehCd, string docType)
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
                    SrNo = vehicleDocument.SrNo,
                    DocNo = vehicleDocument.DocNo,
                    DocTypCd = vehicleDocument.DocTypCd.Trim(),
                    DocTypSDes = vehicleDocument.DocTypSDes,
                    VehName = vehicleDocument.VehName,
                    ExpDt = vehicleDocument.ExpDt,
                    VehicleDocsPaths = _organisationService.GetVehicleDocumentFiles(vehCd)
                };
            else
                model.SrNo = _organisationService.GetVehicleDocument_SrNo(vehCd, docType);
            model.VehCd = vehCd;
            ViewBag.DocumentTypeItems = _settingService.GetCodeGroupItems(CodeGroup.VehicleDoc).Select(m => new SelectListItem
            {
                Text = $"{m.ShortDes}({m.Code.Trim()})",
                Value = m.Code.Trim(),
            });

            return PartialView("_VehicleDocumentModal", model);
        }
        [HttpPost]
        public async Task<IActionResult> SaveVehicleDocument(VehDocumentModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveVehicleDocument(model);
            if (result.Success)
            {
                if (model.VehicleDocFiles?.Count() > 0)
                {
                    var totalFiles = _organisationService.GetVehicleDocumentFiles(model.VehCd).Count();
                    string uploadedFilePath = string.Empty;
                    foreach (var item in model.VehicleDocFiles.Select((value, i) => new { i, value }))
                    {
                        if (item != null)
                        {
                            var filePath = await _fileHelper.UploadFile(item.value, "comp-vehicle-doc", _loggedInUser.CompanyCd);
                            uploadedFilePath = filePath;
                            _organisationService.SaveVehicleDocumentFile(new CompDocImageModel
                            {
                                EntryBy = _loggedInUser.UserAbbr,
                                CompanyCode = _loggedInUser.CompanyCd,
                                DocumentTypeCd = model.DocTypCd,
                                ImageFile = uploadedFilePath,
                                SlNo = item.i + 1 + totalFiles,
                                VehCd = model.VehCd
                            });
                        }
                    }
                }
            }
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteVehicleDocument(string vehCd, string docType)
        {
            var result = _organisationService.DeleteVehicleDocument(vehCd, docType);
            return Json(result);
        }
        public IActionResult FetchVehicleDocumentFiles(string vehCd)
        {
            var files = _organisationService.GetVehicleDocumentFiles(vehCd);
            return PartialView("_VehicleDocFilesList", files);
        }
        [HttpDelete]
        public IActionResult DeleteVehicleDocumentFile(string vehCd, string docType, int slNo)
        {
            var vehicleDocumentFile = _organisationService.GetVehicleDocumentFiles(vehCd).FirstOrDefault(m => m.DocumentType.Trim() == docType && m.SlNo == slNo);
            _fileHelper.RemoveFile(vehicleDocumentFile.ImageFile, "comp-vehicle-doc");
            var result = _organisationService.DeleteVehicleDocumentFile(vehCd, docType, slNo);
            return Json(result);
        }
        [HttpPost]
        public async Task<IActionResult> UpdateVehicleDocumentFile(string docTypCd, string vehCd, int SrNo, IFormFile file)
        {
            var uploadedFilePath = await _fileHelper.UploadFile(file, "comp-vehicle-doc", _loggedInUser.CompanyCd);
            _organisationService.SaveVehicleDocumentFile(new CompDocImageModel
            {
                EntryBy = _loggedInUser.UserAbbr,
                CompanyCode = _loggedInUser.CompanyCd,
                DocumentTypeCd = docTypCd,
                ImageFile = uploadedFilePath,
                SlNo = SrNo,
                VehCd = vehCd
            });
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.UPDATED
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
        public IActionResult GetDesignation(string cd)
        {
            var designation = _organisationService.GetDesignations().FirstOrDefault(m => m.Cd.Trim() == cd);
            var model = new DesignationModel();
            if (designation != null)
                model = new DesignationModel
                {
                    Cd = designation.Cd,
                    Code = designation.Cd,
                    Description = designation.Des,
                    SDes = designation.SDes,
                };
            else
                model.Cd = _organisationService.GetDesignation_SrNo();
            return PartialView("_DesignationModal", model);
        }
        [HttpPost]
        public IActionResult SaveDesignation(DesignationModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveDesignation(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteDesignation(string cd)
        {
            _organisationService.DeleteDesignation(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
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
        public IActionResult GetLeaveType(string cd)
        {
            var leaveType = _organisationService.GetLeaveTypes(_loggedInUser.CompanyCd).FirstOrDefault(m => m.Cd.Trim() == cd);
            var model = new CompanyLeaveModel();
            if (leaveType != null)
                model = new CompanyLeaveModel
                {
                    Cd = leaveType.Cd,
                    Code = leaveType.Cd,
                    AccrLmt = leaveType.AccrLmt,
                    Accrued = leaveType.Accrued == "Y",
                    ApprLvl = leaveType.ApprLvl,
                    Description = leaveType.Des,
                    EnCash = leaveType.EnCash == "Y",
                    EnCashMinLmt = leaveType.EnCashMinLmt,
                    LvCd = leaveType.LvCd,
                    LvMax = leaveType.LvMax,
                    PayFact = leaveType.PayFact,
                    ServicePrd = leaveType.ServicePrd == "Y",
                    SDes = leaveType.SDes,
                };
            return PartialView("_LeaveTypeModal", model);
        }
        [HttpPost]
        public IActionResult SaveLeaveType(CompanyLeaveModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveLeaveType(model, _loggedInUser.CompanyCd);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteLeaveType(string cd)
        {
            _organisationService.DeleteLeaveType(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
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
        public IActionResult GetLeavePayComponent(string lvCd, string payTypCd, string payCd)
        {
            var leavePayComponent = _organisationService.GetLeavePayComponents(_loggedInUser.CompanyCd).FirstOrDefault(m => m.LvCd.Trim() == lvCd && m.PayTypCd.Trim() == payTypCd && m.PayCd.Trim() == payCd);
            var model = new CompanyLeavePayModel();
            if (leavePayComponent != null)
                model = new CompanyLeavePayModel
                {
                    Cd = leavePayComponent.PayCd.Trim(),
                    PayCd = leavePayComponent.PayCd.Trim(),
                    Leave = leavePayComponent.Leave,
                    LvCd = leavePayComponent.LvCd.Trim(),
                    Paycode = leavePayComponent?.Paycode,
                    PayTypCd = leavePayComponent?.PayTypCd.Trim(),
                    PayType = leavePayComponent?.PayType,
                };
            ViewBag.LeaveTypeItems = _organisationService.GetLeaveTypes(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PayTypeItems = _commonService.GetSysCodes(SysCode.ComponentClass).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PayCodeItems = _organisationService.GetComponents(model.PayTypCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            return PartialView("_LeavePayComponentModal", model);
        }
        public IActionResult FetchPayCodeItems(string payTypCd)
        {
            var payCodeItems = _organisationService.GetComponents(payTypCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            return Json(payCodeItems);
        }
        [HttpPost]
        public IActionResult SaveLeavePayComponent(CompanyLeavePayModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveLeavePayComponent(model, _loggedInUser.CompanyCd);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteLeavePayComponent(string lvCd, string payTypCd, string payCd)
        {
            _organisationService.DeleteLeavePayComponent(lvCd, payTypCd, payCd, _loggedInUser.CompanyCd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
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
        public IActionResult GetTravelFare(int cd, string sectCd, string classCd)
        {
            var travelFare = _organisationService.GetTravelFares().FirstOrDefault(m => m.SrNo == cd && m.SectCd.Trim() == sectCd && m.ClassCd.Trim() == classCd);
            var model = new AirFareModel();
            if (travelFare != null)
                model = new AirFareModel
                {
                    Cd = travelFare.ClassCd,
                    SrNo = travelFare.SrNo,
                    ClassCd = travelFare.ClassCd,
                    SDes = travelFare.SDes,
                    Fare = travelFare.Fare,
                    SectCd = travelFare.SectCd,
                    Description = travelFare.Des,
                    FromDate = travelFare.FromDate,
                    ToDate = travelFare.ToDate,
                    DateRange = $"{Convert.ToDateTime(travelFare.FromDate).ToString(CommonSetting.DateFormat)} - {Convert.ToDateTime(travelFare.ToDate).ToString(CommonSetting.DateFormat)}",
                    Sector = travelFare.Sector,
                    TravelClass = travelFare.TravelClass
                };
            else
                model.SrNo = _organisationService.GetTravelFare_SrNo(sectCd, classCd);
            ViewBag.SectorItems = _settingService.GetCodeGroupItems(CodeGroup.Sector).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.ClassItems = _settingService.GetCodeGroupItems(CodeGroup.Class).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            return PartialView("_TravelFareModal", model);
        }
        [HttpPost]
        public IActionResult SaveTravelFare(AirFareModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _organisationService.SaveTravelFare(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteTravelFare(int cd, string sectCd, string classCd)
        {
            _organisationService.DeleteTravelFare(cd, sectCd, classCd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
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
        public IActionResult GetApprovalProcess(string processIdCd, string applTypCd, string branchCd, string deptCd)
        {
            var approvalProcess = _organisationService.GetApprovalProcess(processIdCd, applTypCd, branchCd, deptCd, _loggedInUser.CompanyCd);
            var model = new CompanyProcessApprovalModel();
            if (approvalProcess != null)
                model = new CompanyProcessApprovalModel
                {
                    Branch = approvalProcess.Branch,
                    ApplTypCd = approvalProcess.ApplTypCd.Trim(),
                    ApplTyp = approvalProcess?.ApplTyp,
                    BranchCd = approvalProcess?.BranchCd.Trim(),
                    DeptCd = approvalProcess?.DeptCd.Trim(),
                    Dept = approvalProcess?.Dept,
                    ProcessIdCd = approvalProcess?.ProcessIdCd.Trim(),
                    ProcessId = approvalProcess?.ProcessId,
                };
            ViewBag.TypeItems = _organisationService.GetProcessApprovalTypes(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.ParameterCd.Trim(),
                Text = m.Val
            });
            ViewBag.DocumentTypeItems = _commonService.GetCodesGroups("HDTYP").Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})",
            });
            ViewBag.BranchItems = _settingService.GetBranches(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})",
            });
            return PartialView("_ApprovalProcessModal", model);
        }
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
