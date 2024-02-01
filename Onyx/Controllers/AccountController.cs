using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    public class AccountController : Controller
    {
        private readonly AuthService _authService;
        private readonly CompanyService _companyService;
        private readonly UserEmployeeService _userEmployeeService;
        private readonly CommonService _commonService;
        private readonly LoggedInUserModel _loggedInUser;
        public AccountController(AuthService authService, CompanyService companyService, UserEmployeeService userEmployeeService, CommonService commonService)
        {
            _authService = authService;
            _companyService = companyService;
            _userEmployeeService = userEmployeeService;
            _commonService = commonService;
            _loggedInUser = _authService.GetLoggedInUser();
        }
        public IActionResult Login()
        {
            //var companies = _companyService.GetCompanies(_loggedInUser.CompanyAbbr, _loggedInUser.UserCd).Select(m => new SelectListItem { Value = m.Abbr, Text = m.CoName });
            //if (companies.Count() == 1)
            //    companies = companies.Select(m => { m.Selected = true; return m; });
            //ViewBag.CompanyItems = companies;
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> Login(LoginModel model, string returnUrl)
        {
            model.CoAbbr = "telal";
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
                        LoginId = model.LoginId,
                        UserType = (int)model.UserType,
                        Browser = model.Browser
                    };
                    await _authService.SignInUserAsync(u, model.RememberMe);
                    _commonService.SetActivityLogHead(new ActivityLogModel
                    {
                        UserCd = user.Cd,
                        Browser = model.Browser,
                        CoCd = company.CoCd,
                        CoAbbr = model.CoAbbr,
                    });
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
                    var emp = _userEmployeeService.GetEmployee(model.CoAbbr, employee.UserCd);
                    var u = new LoggedInUserModel
                    {
                        CompanyCd = company.CoCd,
                        CompanyAbbr = model.CoAbbr,
                        UserCd = employee.UserCd,
                        Username = "",
                        UserType = (int)model.UserType,
                        LoginId = model.LoginId,
                        EmployeeCd = model.LoginId,
                        Browser = model.Browser
                    };
                    await _authService.SignInUserAsync(u, model.RememberMe);
                    _commonService.SetActivityLogHead(new ActivityLogModel
                    {
                        UserCd = employee.UserCd,
                        Browser = model.Browser,
                        CoCd = company.CoCd,
                        CoAbbr = model.CoAbbr,
                    });
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
        public IActionResult ChangePassword()
        {
            return View();
        }
        [HttpPost]
        public IActionResult ChangePassword(ChangePassword model)
        {
            if (_loggedInUser.UserType == (int)UserTypeEnum.User)
            {
                var user = _userEmployeeService.ValidateUser(new LoginModel
                {
                    CoAbbr = _loggedInUser.CompanyAbbr,
                    LoginId = _loggedInUser.LoginId,
                    Password = model.OldPassword
                });
                if (user != null)
                {
                    var userFromDb = _userEmployeeService.GetUser(_loggedInUser.CompanyAbbr, _loggedInUser.UserCd);
                    userFromDb.UPwd = model.ConfirmPassword.Encrypt();
                    _userEmployeeService.SaveUsers(_loggedInUser.CompanyAbbr, userFromDb);
                    TempData["success"] = "Password changed Successfully";
                }
                else
                    TempData["error"] = "Old Password is not valid";
            }
            else
            {
                var employee = _userEmployeeService.ValidateEmployee(new LoginModel
                {
                    CoAbbr = _loggedInUser.CompanyAbbr,
                    LoginId = _loggedInUser.LoginId,
                    Password = model.OldPassword
                });
                if (employee != null)
                {
                    var a = _userEmployeeService.UpdateEmployeePassword(_loggedInUser.CompanyAbbr, _loggedInUser.CompanyCd, _loggedInUser.LoginId, model.ConfirmPassword);
                    TempData["success"] = "Password changed Successfully";
                }
                else
                    TempData["error"] = "Old Password is not valid";
            }
            return View();
        }
    }
}