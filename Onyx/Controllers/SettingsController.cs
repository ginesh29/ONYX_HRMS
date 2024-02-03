using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class SettingsController : Controller
    {
        private readonly AuthService _authService;
        private readonly SettingService _settingService;
        private readonly CommonService _commonService;
        private readonly LoggedInUserModel _loggedInUser;
        public SettingsController(AuthService authService, SettingService settingService, CommonService commonService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _settingService = settingService;
            _commonService = commonService;
        }
        #region User Group
        public IActionResult UserGroups()
        {
            ViewBag.UserGroupsList = _settingService.GetUserGroups();
            return View();
        }
        public IActionResult GetUserGroup(string cd)
        {
            var userGroup = _settingService.GetUserGroups().FirstOrDefault(m => m.Cd.Trim() == cd);
            var model = new UserGroupModel();
            if (userGroup != null)
                model = new UserGroupModel
                {
                    Cd = userGroup.Cd,
                    Des = userGroup.Des,
                    ViewAllEmp = userGroup.ViewAllEmp,
                };
            return PartialView("_UserGroupModal", model);
        }
        [HttpPost]
        public IActionResult SaveUserGroup(UserGroupModel model)
        {
            model.EntryBy = _loggedInUser.Username;
            model.ViewAllEmp = model.IsViewAllEmp ? "Y" : "N";
            _settingService.SaveUserGroup(model);
            var result = new CommonResponse
            {
                Success = true,
                Message = model.Mode == "U" ? CommonMessage.UPDATED : CommonMessage.INSERTED
            };
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteUserGroup(string cd)
        {
            _settingService.DeleteUserGroup(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region User
        public IActionResult Users()
        {
            ViewBag.UsersList = _settingService.GetUsers();
            return View();
        }
        public IActionResult GetUser(string cd)
        {
            var user = _settingService.GetUsers().FirstOrDefault(m => m.Code.Trim() == cd);
            var model = new UserModel();
            if (user != null)
                model = new UserModel
                {
                    Code = user.Code,
                    LoginId = user.LoginId,
                    UPwd = user.UPwd.Decrypt(),
                    Abbr = user.Abbr,
                    UserGroupCd = user.UserGroupCd.Trim(),
                    Username = user.Username,
                    ExpiryDt = user.ExpiryDt,
                };
            model.Menus = _commonService.GetMenuWithPermissions(cd);
            ViewBag.UserGroupItems = _settingService.GetUserGroups().Select(m => new SelectListItem { Value = m.Cd.Trim(), Text = m.Des });
            ViewBag.UserBranchItems = _commonService.GetUserBranches(user?.Code).Select(m => new SelectListItem { Value = m.Cd.Trim(), Text = m.Branch, Selected = m.UserDes != null });
            return PartialView("_UserModal", model);
        }
        [HttpPost]
        public IActionResult SaveUser(UserModel model)
        {
            model.EntryBy = _loggedInUser.Username;
            _settingService.SaveUser(model);
            _commonService.SaveUserBranch(model.Code, model.UserBranchCd);
            _commonService.SaveUserMenuPermission(model.Code, model.MenuIds);
            var result = new CommonResponse
            {
                Success = true,
                Message = model.Mode == "U" ? CommonMessage.UPDATED : CommonMessage.INSERTED
            };
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteUser(string cd)
        {
            _settingService.DeleteUser(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion
    }
}
