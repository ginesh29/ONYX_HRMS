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
        #region Branch
        public IActionResult Branches()
        {
            ViewBag.BranchesList = _settingService.GetBranches(_loggedInUser.CompanyCd);
            return View();
        }
        public IActionResult GetBranch(string cd)
        {
            var userGroup = _settingService.GetBranches(_loggedInUser.CompanyCd).FirstOrDefault(m => m.Cd.Trim() == cd);
            var model = new BranchModel();
            if (userGroup != null)
                model = new BranchModel
                {
                    Code = userGroup.Cd,
                    Name = userGroup.Des,
                    Description = userGroup.SDes,
                };
            return PartialView("_BranchModal", model);
        }
        [HttpPost]
        public IActionResult SaveBranch(BranchModel model)
        {
            model.EntryBy = _loggedInUser.Username;
            model.CoCd = _loggedInUser.CompanyCd;
            _settingService.SaveBranch(model);
            var result = new CommonResponse
            {
                Success = true,
                Message = model.Mode == "U" ? CommonMessage.UPDATED : CommonMessage.INSERTED
            };
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteBranch(string cd)
        {
            _settingService.DeleteBranch(cd, _loggedInUser.CompanyCd);
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

        #region Department
        public IActionResult Departments()
        {
            ViewBag.DepartmentsList = _settingService.GetDepartments();
            return View();
        }
        public IActionResult GetDepartment(string cd)
        {
            var department = _settingService.GetDepartments().FirstOrDefault(m => m.Code.Trim() == cd);
            var model = new DepartmentModel();
            if (department != null)
                model = new DepartmentModel
                {
                    Code = department.Code,
                    Name = department.Department,
                    Description = department.Description,
                };
            return PartialView("_DepartmentModal", model);
        }
        [HttpPost]
        public IActionResult SaveDepartment(DepartmentModel model)
        {
            model.EntryBy = _loggedInUser.Username;
            _settingService.SaveDepartment(model);
            var result = new CommonResponse
            {
                Success = true,
                Message = model.Mode == "U" ? CommonMessage.UPDATED : CommonMessage.INSERTED
            };
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteDepartment(string cd)
        {
            _settingService.DeleteDepartment(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Code
        #endregion

        #region Country
        public IActionResult Countries()
        {
            ViewBag.CountriesList = _settingService.GetCountries();
            return View();
        }
        public IActionResult GetCountry(string cd)
        {
            var country = _settingService.GetCountries().FirstOrDefault(m => m.Code.Trim() == cd);
            var model = new CountryModel();
            if (country != null)
                model = new CountryModel
                {
                    Code = country.Code,
                    Nationality=country.Nationality,
                    Provisions = country.Provisions,
                    ShortDesc = country.ShortDesc,
                    Region = country.Region,
                    Description = country.Description,
                };
            return PartialView("_CountryModal", model);
        }
        [HttpPost]
        public IActionResult SaveCountry(CountryModel model)
        {
            model.EntryBy = _loggedInUser.Username;
            _settingService.SaveCountry(model);
            var result = new CommonResponse
            {
                Success = true,
                Message = model.Mode == "U" ? CommonMessage.UPDATED : CommonMessage.INSERTED
            };
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteCountry(string cd)
        {
            _settingService.DeleteCountry(cd);
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
