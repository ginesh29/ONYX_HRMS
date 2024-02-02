using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class SettingsController : Controller
    {
        private readonly AuthService _authService;
        private readonly SettingService _settingService;
        private readonly LoggedInUserModel _loggedInUser;
        public SettingsController(AuthService authService, SettingService settingService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _settingService = settingService;
        }
        #region UserGroup
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
    }
}
