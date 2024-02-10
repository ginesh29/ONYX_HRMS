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
        private readonly LoggedInUserModel _loggedInUser;
        public OrganisationController(AuthService authService, OrganisationService organisationService, CommonService commonService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _organisationService = organisationService;
            _commonService = commonService;
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
            model.EntryBy = _loggedInUser.Username;
            _organisationService.SaveComponent(model);
            var result = new CommonResponse
            {
                Success = true,
                Message = model.Mode == "U" ? CommonMessage.UPDATED : CommonMessage.INSERTED
            };
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
            model.EntryBy = _loggedInUser.Username;
            _organisationService.SaveLoanType(model);
            var result = new CommonResponse
            {
                Success = true,
                Message = model.Mode == "U" ? CommonMessage.UPDATED : CommonMessage.INSERTED
            };
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
            model.EntryBy = _loggedInUser.Username;
            _organisationService.SaveWorkingHour(model, _loggedInUser.CompanyCd);
            var result = new CommonResponse
            {
                Success = true,
                Message = model.Mode == "U" ? CommonMessage.UPDATED : CommonMessage.INSERTED
            };
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
            var overtimeRate = _organisationService.GetOvertimeRates(_loggedInUser.CompanyCd).FirstOrDefault(m => m.SrNo == Cd && m.TypCd.Trim() == type && m.CoCd.Trim() == _loggedInUser.CompanyCd);
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
            model.EntryBy = _loggedInUser.Username;
            _organisationService.SaveOvertimeRate(model, _loggedInUser.CompanyCd);
            var result = new CommonResponse
            {
                Success = true,
                Message = model.Mode == "U" ? CommonMessage.UPDATED : CommonMessage.INSERTED
            };
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
            var events = new List<CalendarModel>
            {
                new() {
                    Id = 1,
                    Title = "Event 1",
                    Start = DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss"),
                    End = DateTime.Now.AddHours(2).ToString("yyyy-MM-ddTHH:mm:ss"),
                    BackgroundColor= "#f56954",
                    BorderColor= "#f56954",
                    AllDay= true,
                },
                new() {
                    Id = 2,
                    Title = "Event 2",
                    Start = DateTime.Now.AddDays(1).ToString("yyyy-MM-ddTHH:mm:ss"),
                    End = DateTime.Now.AddDays(1).AddHours(2).ToString("yyyy-MM-ddTHH:mm:ss"),
                    BackgroundColor= "#000",
                    BorderColor= "#f56954",
                    Holyday= true,
                }
            };
            return Json(events);
        }
        #endregion
    }
}
