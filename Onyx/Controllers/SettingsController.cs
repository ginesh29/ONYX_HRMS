using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.StoredProcedure;
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
        //public IActionResult UserGroups()
        //{
        //    ViewBag.UserGroupsList = _settingService.GetUserGroups();
        //    return View();
        //}
        //public IActionResult GetUserGroup(string cd)
        //{
        //    var userGroup = _settingService.GetUserGroups().FirstOrDefault(m => m.Cd.Trim() == cd);
        //    var model = new BranchModel();
        //    if (userGroup != null)
        //        model = new BranchModel
        //        {
        //            Cd = userGroup.Cd,
        //            Des = userGroup.Des,
        //            ViewAllEmp = userGroup.ViewAllEmp,
        //        };
        //    return PartialView("_UserGroupModal", model);
        //}
        //[HttpPost]
        //public IActionResult SaveUserGroup(BranchModel model)
        //{
        //    model.EntryBy = _loggedInUser.Username;
        //    model.ViewAllEmp = model.IsViewAllEmp ? "Y" : "N";
        //    _settingService.SaveUserGroup(model);
        //    var result = new CommonResponse
        //    {
        //        Success = true,
        //        Message = model.Mode == "U" ? CommonMessage.UPDATED : CommonMessage.INSERTED
        //    };
        //    return Json(result);
        //}
        //[HttpDelete]
        //public IActionResult DeleteUserGroup(string cd)
        //{
        //    _settingService.DeleteUserGroup(cd);
        //    var result = new CommonResponse
        //    {
        //        Success = true,
        //        Message = CommonMessage.DELETED
        //    };
        //    return Json(result);
        //}
        #endregion

        #region User
        public IActionResult Users()
        {
            ViewBag.UsersList = _settingService.GetUsers();
            return View();
        }
        public IEnumerable<GetMenuWithPermissions_Result> ConvertToTree(IEnumerable<GetMenuWithPermissions_Result> flatList)
        {
            var itemDictionary = flatList.ToDictionary(item => item.MenuId);
            var tree = new List<GetMenuWithPermissions_Result>();

            foreach (var item in flatList)
            {
                if (item.Prnt == 0)
                {
                    tree.Add(item);
                }
                else if (itemDictionary.ContainsKey(item.Prnt))
                {
                    var parent = itemDictionary[item.Prnt];
                    parent.Children ??= new List<GetMenuWithPermissions_Result>();
                    parent.Children.Add(item);
                }
            }

            return tree;
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
                    Username = user.Username,
                    ExpiryDt = user.ExpiryDt,
                };
            model.Menus = ConvertToTree(_commonService.GetMenuWithPermissions(cd));
            ViewBag.UserBranchItems = _commonService.GetUserBranches(user?.Code).Select(m => new SelectListItem { Value = m.Cd.Trim(), Text = m.Branch, Selected = m.UserDes != null });
            return PartialView("_UserModal", model);
        }
        [HttpPost]
        public IActionResult SaveUser(UserModel model)
        {
            model.EntryBy = _loggedInUser.Username;
            _settingService.SaveUser(model);
            _commonService.SaveUserBranch(model.Code, model.UserBranchCd);
            _commonService.SaveUserMenu(model.Code, model.MenuIds);
            _commonService.SaveUserPermission(model.Code, model.Permissions);
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
