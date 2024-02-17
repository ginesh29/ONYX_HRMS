using Microsoft.AspNetCore.Mvc;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    public class AccountController : Controller
    {
        private readonly AuthService _authService;
        private readonly UserEmployeeService _userEmployeeService;
        private readonly SettingService _settingService;
        private readonly CommonService _commonService;
        private readonly LoggedInUserModel _loggedInUser;
        public AccountController(AuthService authService, UserEmployeeService userEmployeeService, CommonService commonService, SettingService settingService)
        {
            _authService = authService;
            _userEmployeeService = userEmployeeService;
            _commonService = commonService;
            _loggedInUser = _authService.GetLoggedInUser();
            _settingService = settingService;
        }
        public IActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> Login(LoginModel model, string returnUrl)
        {
            if (!string.IsNullOrEmpty(model.CoCd) && model.CoCd != "0")
            {
                await _authService.UpdateClaim("CompanyCd", model.CoCd);
                _commonService.SetActivityLogHead(new ActivityLogModel
                {
                    Browser = _loggedInUser.Browser,
                    CoCd = model.CoCd,
                    UserCd = _loggedInUser.UserCd
                });
                var result = new CommonResponse
                {
                    Success = true,
                    Message = "Login Successfully",
                    RedirectUrl = returnUrl ?? "/"
                };
                return Json(result);
            }
            else
            {
                var result = new CommonResponse { Success = false };
                if (model.UserType == UserTypeEnum.User)
                {
                    var validateUser = _userEmployeeService.ValidateUser(model);
                    if (validateUser != null)
                    {
                        var user = _userEmployeeService.GetUser(validateUser.Cd);
                        var u = new LoggedInUserModel
                        {
                            CompanyCd = model.CoCd,
                            UserCd = validateUser.Cd,
                            Username = validateUser.UName,
                            UserAbbr = user.Abbr,
                            LoginId = model.LoginId,
                            UserType = (int)model.UserType,
                            Browser = model.Browser
                        };
                        await _authService.SignInUserAsync(u, model.RememberMe);
                        result.Success = true;
                    }
                    else
                        result.Message = CommonMessage.INVALIDUSER;
                }
                else
                {
                    var employee = _userEmployeeService.ValidateEmployee(model);
                    if (employee != null)
                    {
                        var user = _userEmployeeService.GetUser(employee.UserCd);
                        var u = new LoggedInUserModel
                        {
                            CompanyCd = model.CoCd,
                            UserCd = employee.UserCd,
                            Username = user.Username,
                            UserAbbr = user.Abbr,
                            UserType = (int)model.UserType,
                            LoginId = model.LoginId,
                            Browser = model.Browser
                        };
                        await _authService.SignInUserAsync(u, model.RememberMe);
                        result.Success = true;
                    }
                    else
                        result.Message = CommonMessage.INVALIDUSER;
                }
                return Json(result);
            }
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
                var user = _userEmployeeService.ValidateUser(new LoginModel
                {
                    LoginId = _loggedInUser.LoginId,
                    Password = model.OldPassword
                });
                if (user != null)
                {
                    var userFromDb = _userEmployeeService.GetUser(_loggedInUser.UserCd);
                    userFromDb.UPwd = model.ConfirmPassword.Encrypt();
                    _settingService.SaveUser(userFromDb);
                    result.Success = true;
                    result.Message = "Password changed Successfully";
                }
                else
                    result.Message = "Old Password is not valid";
            }
            else
            {
                var employee = _userEmployeeService.ValidateEmployee(new LoginModel
                {
                    LoginId = _loggedInUser.LoginId,
                    Password = model.OldPassword
                });
                if (employee != null)
                {
                    _userEmployeeService.UpdateEmployeePassword(_loggedInUser.CompanyCd, _loggedInUser.LoginId, model.ConfirmPassword);
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