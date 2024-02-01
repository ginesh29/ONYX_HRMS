using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        private readonly AuthService _authService;
        private readonly LoggedInUserModel _loggedInUser;
        public HomeController(AuthService authService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
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
    }
}
