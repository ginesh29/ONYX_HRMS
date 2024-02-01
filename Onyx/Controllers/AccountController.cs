using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    public class AccountController(AuthService authService, CompanyService companyService, UserEmployeeService userEmployeeService) : Controller
    {
        private readonly AuthService _authService = authService;
        private readonly CompanyService _companyService = companyService;
        private readonly UserEmployeeService _userEmployeeService = userEmployeeService;
        public IActionResult Login()
        {
            var companies = _companyService.GetCompanies().Select(m => new SelectListItem { Value = m.Abbr, Text = m.CoName });
            if (companies.Count() == 1)
                companies = companies.Select(m => { m.Selected = true; return m; });
            ViewBag.CompanyItems = companies;
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> Login(LoginModel model, string returnUrl)
        {
            var company = _companyService.GetCompanyDetail(model.CoAbbr);
            if (model.UserType == UserTypeEnum.User)
            {
                var user = _userEmployeeService.ValidateUser(model);
                if (user != null)
                {
                    var u = new LoggedInUserModel
                    {
                        CompanyCd = company.CoCd,
                        CompanyAbbr = model.CoAbbr,
                        UserCd = user.Cd,
                        Username = user.UName,
                        UserType = (int)model.UserType
                    };
                    await _authService.SignInUserAsync(u, model.RememberMe);
                    TempData["success"] = "Login Successfully";
                    if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                        return Redirect(returnUrl);
                    else
                        return RedirectToAction("Index", "Home");
                }
                TempData["error"] = CommonMessage.INVALIDUSER;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                var employee = _userEmployeeService.ValidateEmployee(model);
                if (employee != null)
                {
                    var user = _userEmployeeService.GetUser(model.CoAbbr, employee.UserCd);
                    var u = new LoggedInUserModel
                    {
                        CompanyCd = company.CoCd,
                        CompanyAbbr = model.CoAbbr,
                        UserCd = employee.UserCd,
                        Username = user.Username,
                        UserType = (int)model.UserType,
                        EmployeeCd = model.Username
                    };
                    await _authService.SignInUserAsync(u, model.RememberMe);
                    TempData["success"] = "Login Successfully";
                    if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                        return Redirect(returnUrl);
                    else
                        return RedirectToAction("Index", "Home");
                }
                TempData["error"] = CommonMessage.INVALIDUSER;
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