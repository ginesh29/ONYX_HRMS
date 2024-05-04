using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;
using System.Security.Claims;

namespace Onyx.Controllers
{
    public class AccountController : Controller
    {
        private readonly DbGatewayService _dbGatewayService;
        private readonly AuthService _authService;
        private readonly UserService _userService;
        private readonly EmployeeService _employeeService;
        private readonly SettingService _settingService;
        private readonly CommonService _commonService;
        private readonly LogService _logService;
        private readonly LoggedInUserModel _loggedInUser;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public AccountController(DbGatewayService dbGatewayService, AuthService authService, UserService userService, EmployeeService employeeService, CommonService commonService, SettingService settingService, IHttpContextAccessor httpContextAccessor, LogService logService)
        {
            _authService = authService;
            _commonService = commonService;
            _userService = userService;
            _dbGatewayService = dbGatewayService;
            _employeeService = employeeService;
            _loggedInUser = _authService.GetLoggedInUser();
            _settingService = settingService;
            _httpContextAccessor = httpContextAccessor;
            _logService = logService;
        }
        public IActionResult Login()
        {
            _commonService.GenerateModifiedSp();
            ViewBag.CompanyItems = _dbGatewayService.GetCompanies().Select(m => new SelectListItem
            {
                Text = m.CoName,
                Value = $"{m.Cd.Trim()}_{m.Abbr.Trim()}"
            });
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> Login(LoginModel model)
        {
            var companySp = model.Company.Split("_");
            var CoCd = companySp[0];
            model.CoAbbr = companySp[1];
            string UserCd = string.Empty;
            var result = new CommonResponse { Success = false };
            if (model.UserType == UserTypeEnum.User)
            {
                var validateUser = _userService.ValidateUser(model);
                if (validateUser != null)
                {
                    UserCd = validateUser.Cd;
                    var user = _userService.GetUsers(validateUser.Cd, model.CoAbbr).FirstOrDefault();
                    var u = new LoggedInUserModel
                    {
                        CompanyCd = CoCd,
                        CoAbbr = model.CoAbbr,
                        UserCd = UserCd,
                        UserOrEmployee = "U",
                        Username = validateUser.UName,
                        UserAbbr = user.Abbr,
                        UserType = (int)model.UserType,
                        Browser = model.Browser,
                    };
                    await _authService.SignInUserAsync(u);
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
                    var user = _userService.GetUsers(employee.UserCd.Trim(), model.CoAbbr).FirstOrDefault();
                    var u = new LoggedInUserModel
                    {
                        CompanyCd = CoCd,
                        CoAbbr = model.CoAbbr,
                        UserCd = UserCd,
                        UserOrEmployee = "E",
                        Username = user.Username,
                        UserAbbr = model.LoginId,
                        UserType = (int)model.UserType,
                        Browser = model.Browser,
                    };
                    await _authService.SignInUserAsync(u);
                    result.Success = true;
                    result.Message = "Login Successfully";
                }
                else
                    result.Message = CommonMessage.INVALIDUSER;
            }
            if (result.Success)
            {
                var activityId = _logService.SetActivityLogHead(new ActivityLogModel
                {
                    Browser = model.Browser,
                    CoAbbr = model.CoAbbr,
                    CoCd = CoCd,
                    UserCd = UserCd,
                    ActivityType = "I"
                });
                result.Data = new { activityId };
            }
            return Json(result);
        }
        public async Task<IActionResult> LogOut()
        {
            _logService.SetActivityLogHead(new ActivityLogModel
            {
                Browser = _loggedInUser.Browser,
                CoAbbr = _loggedInUser.CoAbbr,
                UserCd = _loggedInUser.UserCd,
                ActivityId = _loggedInUser.ActivityId,
                CoCd = _loggedInUser.CompanyCd,
                ActivityType = "U",
            });
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