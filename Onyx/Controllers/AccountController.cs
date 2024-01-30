using Microsoft.AspNetCore.Mvc;
using Onyx.Models;
using Onyx.Services;

namespace Onyx.Controllers
{
    public class AccountController : Controller
    {
        private readonly AuthService _authService;
        public AccountController(AuthService authService)
        {
            _authService = authService;
        }
        public IActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> Login(LoginModel model, string returnUrl)
        {
            var company = _authService.GetCompanyDetail(model.CoAbbr);
            var user = _authService.ValidateLogin(model);
            if (user != null)
            {
                var u = new LoggedInUserModel
                {
                    CompanyAbbr = model.CoAbbr,
                    CompanyGroupAbbr = model.CoAbbr,
                    CompanyGroup = company.CoCd,
                    Username = user.UName,
                    UserCd = user.Cd,
                    User = model.UserId,
                    UserAbbr = user.Abbr
                };
                await _authService.SignInUserAsync(u, model.RememberMe);
                TempData["success"] = "Login Successfully";
                if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                    return Redirect(returnUrl);
                else
                    return RedirectToAction("Index", "Home");
            }
            TempData["error"] = "Invalid Username or Password.";
            return View();
        }
        public async Task<IActionResult> LogOut()
        {
            await _authService.SignOutAsync();
            return RedirectToAction("Login", "Account");
        }
    }
}