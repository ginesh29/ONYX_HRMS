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
        #region Branch
        public IActionResult Branches()
        {
            return View();
        }
        public IActionResult FetchBranches()
        {
            var branches = _settingService.GetBranches(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = branches,
            };
            return Json(result);
        }
        public IActionResult GetBranch(string cd)
        {
            var branch = _settingService.GetBranches(_loggedInUser.CompanyCd).FirstOrDefault(m => m.Cd.Trim() == cd);
            var model = new BranchModel();
            if (branch != null)
                model = new BranchModel
                {
                    Code = branch.Cd,
                    Cd = branch.Cd,
                    Name = branch.SDes,
                    Description = branch.Des,
                    Image = branch.Image,
                };
            return PartialView("_BranchModal", model);
        }
        [HttpPost]
        public async Task<IActionResult> SaveBranch(BranchModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            model.CoCd = _loggedInUser.CompanyCd;
            if (model.ImageFile != null)
            {
                var ext = Path.GetExtension(model.ImageFile.FileName);
                var filename = $"branch-{model.CoCd}{ext}";
                var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads/branch", filename);
                if (System.IO.File.Exists(filePath))
                    System.IO.File.Delete(filePath);
                using (var stream = new FileStream(filePath, FileMode.Create))
                    await model.ImageFile.CopyToAsync(stream);
                model.Image = filename;
            }
            var result = _settingService.SaveBranch(model);
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
            return View();
        }
        public IActionResult FetchUsers()
        {
            var users = _settingService.GetUsers();
            CommonResponse result = new()
            {
                Data = users,
            };
            return Json(result);
        }
        public IActionResult GetUser(string cd)
        {
            var user = _settingService.GetUsers().FirstOrDefault(m => m.Code.Trim() == cd);
            var model = new UserModel();
            if (user != null)
                model = new UserModel
                {
                    Code = user.Code,
                    Cd = user.Code,
                    LoginId = user.LoginId,
                    UPwd = user.UPwd.Decrypt(),
                    Abbr = user.Abbr,
                    Username = user.Username,
                    ExpiryDt = user.ExpiryDt,
                };
            model.Menus = _settingService.ConvertPermissionToTree(_commonService.GetMenuWithPermissions(cd));
            ViewBag.UserBranchItems = _commonService.GetUserBranches(user?.Code);
            return PartialView("_UserModal", model);
        }
        [HttpPost]
        public IActionResult SaveUser(UserModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            model.UPwd = model.UPwd.Encrypt();
            var result = _settingService.SaveUser(model);
            if (result.Success)
            {
                _commonService.SaveUserBranch(model.Code, model.UserBranchCd);
                _commonService.SaveUserMenu(model.Code, model.MenuIds);
                _commonService.SaveUserPermission(model.Code, model.Permissions);
            }
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
            return View();
        }
        public IActionResult FetchDepartments()
        {
            var departments = _settingService.GetDepartments();
            CommonResponse result = new()
            {
                Data = departments,
            };
            return Json(result);
        }
        public IActionResult GetDepartment(string cd)
        {
            var department = _settingService.GetDepartments().FirstOrDefault(m => m.Code.Trim() == cd);
            var model = new DepartmentModel();
            if (department != null)
                model = new DepartmentModel
                {
                    Code = department.Code,
                    Cd = department.Code,
                    Name = department.Department,
                    Description = department.Description,
                };
            return PartialView("_DepartmentModal", model);
        }
        [HttpPost]
        public IActionResult SaveDepartment(DepartmentModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _settingService.SaveDepartment(model);
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
        public IActionResult Codes()
        {
            ViewBag.CodeGroupsItems = _settingService.GetCodeGroups(_loggedInUser.CompanyCd).Select(m => new SelectListItem { Value = m.Cd, Text = m.ShortDes });
            return View();
        }
        public IActionResult FetchCodesByType(string type)
        {
            var codes = _settingService.GetCodes();
            if (!string.IsNullOrEmpty(type))
                codes = codes.Where(m => m.Typ.Trim() == type.Trim());
            CommonResponse result = new()
            {
                Data = codes,
            };
            return Json(result);
        }
        public IActionResult GetCode(string cd, string type)
        {
            var code = _settingService.GetCodes().FirstOrDefault(m => m.Cd.Trim() == cd);
            var model = new CodeModel();
            if (code != null)
                model = new CodeModel
                {
                    Code = code.Cd,
                    Cd = code.Cd,
                    Abbriviation = code.Abbr,
                    Description = code.Des,
                    ShortDes = code.SDes,
                    Type = code.Typ,
                    Active = code.Active,
                };
            else
            {
                var nextCode = _settingService.GetNextCode(type);
                model.Code = $"{type}{nextCode}";
            }
            ViewBag.CodeGroupsItems = _settingService.GetCodeGroups(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Cd,
                Text = $"{m.ShortDes}({m.Cd.Trim()})",
            });
            return PartialView("_CodeModal", model);
        }
        [HttpPost]
        public IActionResult SaveCode(CodeModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _settingService.SaveCode(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteCode(string cd)
        {
            _settingService.DeleteCode(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Country
        public IActionResult Countries()
        {
            return View();
        }
        public IActionResult FetchCountries()
        {
            var countries = _settingService.GetCountries();
            CommonResponse result = new()
            {
                Data = countries,
            };
            return Json(result);
        }
        public IActionResult GetCountry(string cd)
        {
            var country = _settingService.GetCountries().FirstOrDefault(m => m.Code.Trim() == cd);
            var model = new CountryModel();
            if (country != null)
                model = new CountryModel
                {
                    Code = country.Code,
                    Cd = country.Code,
                    Nationality = country.Nationality,
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
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _settingService.SaveCountry(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteCountry(string cd)
        {
            var result = _settingService.DeleteCountry(cd);
            return Json(result);
        }
        #endregion

        #region Currency
        public IActionResult Currencies()
        {
            return View();
        }
        public IActionResult FetchCurrencies()
        {
            var currencies = _settingService.GetCurrencies(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = currencies,
            };
            return Json(result);
        }
        public IActionResult GetCurrency(string cd)
        {
            var currency = _settingService.GetCurrencies(_loggedInUser.CompanyCd).FirstOrDefault(m => m.Code.Trim() == cd);
            var model = new CurrencyModel();
            if (currency != null)
                model = new CurrencyModel
                {
                    Code = currency.Code,
                    Cd = currency.Code,
                    Abbriviation = currency.Abbr,
                    NoDecs = currency.NoDecs,
                    MainCurr = currency.MainCurr,
                    Rate = currency.Rate,
                    SubCurr = currency.SubCurr,
                    Symbol = currency.Symbol,
                    Description = currency.Des,
                };
            return PartialView("_CurrencyModal", model);
        }
        [HttpPost]
        public IActionResult SaveCurrency(CurrencyModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _settingService.SaveCurrency(model, _loggedInUser.CompanyCd);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteCurrency(string cd)
        {
            _settingService.DeleteCurrency(cd);
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