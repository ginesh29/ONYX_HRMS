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
            ViewBag.ComponentsList = _organisationService.GetComponents();
            return View();
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
            ViewBag.ComponentClassItems = _commonService.GetSysCodes("HEDT").Select(m => new SelectListItem { Value = m.Cd, Text = m.SDes });
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
            ViewBag.LoanTypesList = _organisationService.GetLoanTypes();
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
        [HttpPost]
        public IActionResult SaveLoanType(LoanTypeModel model)
        {
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

        public IActionResult WorkingHours()
        {
            ViewBag.WorkingHoursList = _organisationService.GetWorkingHours(_loggedInUser.CompanyCd);
            return View();
        }
        public IActionResult OvertimeRates()
        {
            ViewBag.OvertimeRatesList = _organisationService.GetOvertimeRates(_loggedInUser.CompanyCd);
            return View();
        }
    }
}
