using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    public class AccountController : Controller
    {
        private readonly AuthService _authService;
        private readonly UserService _userService;
        private readonly EmployeeService _employeeService;
        private readonly SettingService _settingService;
        private readonly CommonService _commonService;
        private readonly LoggedInUserModel _loggedInUser;
        public AccountController(AuthService authService, UserService userService, EmployeeService employeeService, CommonService commonService, SettingService settingService)
        {
            _authService = authService;
            _commonService = commonService;
            _userService = userService;
            _loggedInUser = _authService.GetLoggedInUser();
            _settingService = settingService;
            _employeeService = employeeService;
        }
        public IActionResult Login()
        {
            ViewBag.CompanyItems = _commonService.GetCompanies().Select(m => new SelectListItem
            {
                Text = m.CoName,
                Value = m.Cd.Trim()
            });
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> Login(LoginModel model)
        {
            string UserCd = string.Empty;
            var result = new CommonResponse { Success = false };
            if (model.UserType == UserTypeEnum.User)
            {
                var validateUser = _userService.ValidateUser(model);
                if (validateUser != null)
                {
                    UserCd = validateUser.Cd;
                    var user = _userService.GetUsers(validateUser.Cd, model.CoCd).FirstOrDefault();
                    var u = new LoggedInUserModel
                    {
                        CompanyCd = model.CoCd,
                        UserCd = UserCd,
                        UserOrEmployee = "U",
                        Username = validateUser.UName,
                        UserAbbr = user.Abbr,
                        UserType = (int)model.UserType,
                        Browser = model.Browser
                    };
                    await _authService.SignInUserAsync(u, model.RememberMe);
                    result.Success = true;
                    result.Message = "Login Successfully";
                }
                else
                    result.Message = CommonMessage.INVALIDUSER;
            }
            else
            {
                var employee = _userService.ValidateEmployee(model);
                if (employee != null)
                {
                    UserCd = employee.UserCd.Trim();
                    var user = _userService.GetUsers(employee.UserCd.Trim(), model.CoCd).FirstOrDefault();
                    var u = new LoggedInUserModel
                    {
                        CompanyCd = model.CoCd,
                        UserCd = UserCd,
                        UserOrEmployee = "E",
                        Username = user.Username,
                        UserAbbr = model.LoginId,
                        UserType = (int)model.UserType,
                        Browser = model.Browser
                    };
                    await _authService.SignInUserAsync(u, model.RememberMe);
                    result.Success = true;
                    result.Message = "Login Successfully";
                }
                else
                    result.Message = CommonMessage.INVALIDUSER;
            }
            if (result.Success)
            {
                //HttpContext.Session.SetString("CoCd", model.CoCd);
                _commonService.SetActivityLogHead(new ActivityLogModel
                {
                    Browser = model.Browser,
                    CoCd = model.CoCd,
                    UserCd = UserCd
                });
            }
            return Json(result);
        }
        public async Task<IActionResult> LogOut()
        {
            await _authService.SignOutAsync();
            return RedirectToAction("Login", "Account");
        }
        public IActionResult ChangePassword()
        {
            return PartialView("_ChangePassword");
        }
        [HttpPost]
        public IActionResult ChangePassword(ChangePassword model)
        {
            var result = new CommonResponse { Success = false };
            if (_loggedInUser.UserType == (int)UserTypeEnum.User)
            {
                var user = _userService.ValidateUser(new LoginModel
                {
                    LoginId = _loggedInUser.UserAbbr,
                    Password = model.OldPassword
                });
                if (user != null)
                {
                    var userFromDb = _userService.GetUsers(_loggedInUser.UserCd, _loggedInUser.CompanyCd).FirstOrDefault();
                    userFromDb.UPwd = model.ConfirmPassword.Encrypt();
                    _settingService.SaveUser(new UserModel
                    {
                        Code = userFromDb.Code,
                        LoginId = userFromDb.LoginId,
                        Abbr = userFromDb.Abbr,
                        UPwd = userFromDb.UPwd,
                        Username = userFromDb.Username,
                        ExpiryDt = userFromDb.ExpiryDt,
                        EntryBy = userFromDb.EntryBy,
                    });
                    result.Success = true;
                    result.Message = "Password changed Successfully";
                }
                else
                    result.Message = "Old Password is not valid";
            }
            else
            {
                var employee = _userService.ValidateEmployee(new LoginModel
                {

                    LoginId = _loggedInUser.UserAbbr,
                    Password = model.OldPassword
                });
                if (employee != null)
                {
                    _employeeService.UpdateEmployeePassword(_loggedInUser.CompanyCd, _loggedInUser.UserAbbr, model.ConfirmPassword);
                    result.Success = true;
                    result.Message = "Password changed Successfully";
                }
                else
                    result.Message = "Old Password is not valid";
            }
            return Json(result);
        }
    }
}