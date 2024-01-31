using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
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
            var companies = _authService.GetCompanies().Select(m => new SelectListItem { Value = m.Abbr, Text = m.CoName });
            if (companies.Count() == 1)
                companies = companies.Select(m => { m.Selected = true; return m; });
            ViewBag.CompanyItems = companies;
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> Login(LoginModel model, string returnUrl)
        {
            var company = _authService.GetCompanyDetail(model.CoAbbr);
            if (model.UserType == UserTypeEnum.User)
            {
                var user = _authService.ValidateUser(model);
                if (user != null)
                {
                    var u = new LoggedInUserModel
                    {
                        CompanyCd = company.CoCd,
                        CompanyAbbr = model.CoAbbr,
                        UserCd = user.Cd,
                        Username = user.UName
                    };
                    await _authService.SignInUserAsync(u, model.RememberMe);
                    TempData["success"] = "Login Successfully";
                    if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                        return Redirect(returnUrl);
                    else
                        return RedirectToAction("Index", "Home");
                }
                TempData["error"] = "Invalid Username or Password.";
                return RedirectToAction("Login", "Account");
            }
            else
            {
                var employee = _authService.ValidateEmployee(model);
                if (employee != null)
                {
                    var user = _authService.GetUser(employee.UserCd, model.CoAbbr);
                    var u = new LoggedInUserModel
                    {
                        CompanyCd = company.CoCd,
                        CompanyAbbr = model.CoAbbr,
                        UserCd = employee.UserCd,
                        Username = user.UserName,
                        EmployeeCd = employee.Cd,
                        EmployeeName = $"{employee.FName} {employee.MName} {employee.LName}"
                    };
                    await _authService.SignInUserAsync(u, model.RememberMe);
                    TempData["success"] = "Login Successfully";
                    if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                        return Redirect(returnUrl);
                    else
                        return RedirectToAction("Index", "Home");
                }
                TempData["error"] = "Invalid Username or Password.";
                return RedirectToAction("Login", "Account");
            }
        }
        public async Task<IActionResult> LogOut()
        {
            await _authService.SignOutAsync();
            return RedirectToAction("Login", "Account");
        }
    }
}