using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        private readonly AuthService _authService;
        private readonly CompanyService _companyService;
        private readonly LoggedInUserModel _loggedInUser;
        public HomeController(AuthService authService, CompanyService companyService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _companyService = companyService;
        }
        public IActionResult Index()
        {
            return View();
        }
        public async Task<IActionResult> UpdateCompany(string CoCd)
        {            
            await _authService.UpdateClaim("CompanyCd", CoCd.Trim());
            var result = new CommonResponse
            {
                Success = true,
                Message = "Company changed successfully"
            };
            return Json(result);
        }
        public IActionResult FetchCompanies()
        {
            var companies = _companyService.GetCompanies(_loggedInUser.UserCd).Select(m => new SelectListItem { Value = m.CoCd.Trim(), Text = m.CoName });
            var result = new CommonResponse
            {
                Success = true,
                Data = companies
            };
            return Json(result);
        }
    }
}
