using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
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
        public IActionResult Components()
        {
            ViewBag.ComponentsList = _organisationService.GetComponents();
            return View();
        }
        public IActionResult LoanTypes()
        {
            ViewBag.LoanTypesList = _organisationService.GetLoanTypes();
            return View();
        }
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
