using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using Onyx.Services;
using X.PagedList;

namespace Onyx.Controllers
{
    public class EmployeeController : Controller
    {
        private readonly AuthService _authService;
        private readonly UserEmployeeService _userEmployeeService;
        private readonly CommonService _commonService;
        private readonly SettingService _settingService;
        private readonly OrganisationService _organisationService;
        private readonly LoggedInUserModel _loggedInUser;
        private readonly FileHelper _fileHelper;
        public EmployeeController(AuthService authService, UserEmployeeService userEmployeeService, CommonService commonService, SettingService settingService, OrganisationService organisationService)
        {
            _userEmployeeService = userEmployeeService;
            _authService = authService;
            _commonService = commonService;
            _settingService = settingService;
            _loggedInUser = _authService.GetLoggedInUser();
            _organisationService = organisationService;
            _fileHelper = new FileHelper();
        }
        public IActionResult Profiles()
        {
            return View();
        }
        public IActionResult FetchEmployeeItems(string departments, string designations, string branches, string locations, string term)
        {
            var employees = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd, departments, designations, branches, locations);
            if (!string.IsNullOrEmpty(term))
                employees = employees.Where(m => m.Name.Trim().Contains(term, StringComparison.OrdinalIgnoreCase) || m.Department.Trim().Contains(term, StringComparison.OrdinalIgnoreCase) || m.Desg.Trim().Contains(term, StringComparison.OrdinalIgnoreCase) || m.Branch.Trim().Contains(term, StringComparison.OrdinalIgnoreCase) || m.Location.Trim().Contains(term, StringComparison.OrdinalIgnoreCase));
            return Json(employees);
        }
        public IActionResult FetchEmployees(int? page)
        {
            int pageNumber = page ?? 1;
            int pageSize = 9;
            var employees = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd);
            var pagedEmployees = employees.ToPagedList(pageNumber, pageSize);
            return PartialView("_EmployeesList", pagedEmployees);
        }
        public IActionResult Profile(string Cd)
        {
            var employee = _userEmployeeService.FindEmployee(Cd, _loggedInUser.CompanyCd);
            if (employee != null)
            {
                employee.Cd = employee.Cd?.Trim();
                employee.Salute = employee.Salute?.Trim();
                employee.Marital = employee.Marital?.Trim();
                employee.Nat = employee.Nat?.Trim();
                employee.Relg = employee.Relg?.Trim();
                employee.Sponsor = employee.Sponsor?.Trim();
                employee.Desg = employee.Desg?.Trim();
                employee.Dept = employee.Dept?.Trim();
                employee.LocCd = employee.LocCd?.Trim();
                employee.RepTo = employee.RepTo?.Trim();
                employee.UserCd = employee.UserCd?.Trim();
                employee.Pwd = employee.Pwd?.Trim().Decrypt();
                employee.ConfirmPassword = employee.Pwd;
                employee.PayFreq = employee.PayFreq?.Trim();
                employee.PayMode = employee.PayMode?.Trim();
                employee.BankCd = employee.BankCd?.Trim();
                employee.CurrCd = employee.CurrCd?.Trim();
                employee.BasicCurr = employee.BasicCurr?.Trim();
                employee.TravSect = employee.TravSect?.Trim();
                employee.TravClass = employee.TravClass?.Trim();
                employee.FareEligibleValue = employee.FareEligible == "Y";
                employee.EmpTyp = employee.EmpTyp?.Trim();
                employee.Status = employee.Status?.Trim();
                employee.GTValue = employee.GT == "Y";
                employee.LSValue = employee.LS == "Y";
                employee.LTValue = employee.LT == "Y";
                employee.ActiveValue = employee.Active == "Y";
                var avatarFileExist = employee?.Imagefile.FileExist("emp-photo", _loggedInUser.CompanyCd);
                var avatarImage = avatarFileExist == true && !string.IsNullOrEmpty(employee?.Imagefile) ? $"/uploads/{_loggedInUser.CompanyCd}/emp-photo/{employee.Imagefile}" : "/images/avatar.png";
                var signatureFileExist = employee?.ImageSign.FileExist("emp-sign", _loggedInUser.CompanyCd);
                var signatureImage = signatureFileExist == true && !string.IsNullOrEmpty(employee?.ImageSign) ? $"/uploads/{_loggedInUser.CompanyCd}/emp-sign/{employee.ImageSign}" : $"/uploads/{_loggedInUser.CompanyCd}/emp-sign/{employee.ImageSign}";
                ViewBag.AvatarFileExist = avatarFileExist;
                ViewBag.SignatureFileExist = signatureFileExist;
                ViewBag.AvatarPath = avatarImage;
                ViewBag.SignaturePath = signatureImage;
            }

            ViewBag.SalutationItems = _commonService.GetCodesGroups(CodeGroup.Salutation).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.MaritalStatusItems = _commonService.GetCodesGroups(CodeGroup.MaritalStatus).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.NationalityItems = _settingService.GetCountries().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDesc
            });
            ViewBag.ReligionItems = _commonService.GetCodesGroups(CodeGroup.Religion).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.SponsorItems = _commonService.GetCodesGroups(CodeGroup.Sponsor).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.ShortDes}({m.Code.Trim()})"
            });
            ViewBag.DesignationItems = _organisationService.GetDesignations().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
            ViewBag.BranchItems = _settingService.GetBranches(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
            ViewBag.LocationItems = _commonService.GetCodesGroups(CodeGroup.EmpDeployLoc).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.ShortDes}({m.Code.Trim()})"
            });
            ViewBag.ReportingToItems = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.Name}({m.Cd.Trim()})"
            });
            ViewBag.UserItems = _settingService.GetUsers().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Username}({m.Code.Trim()})"
            });

            ViewBag.PayModeItems = _commonService.GetSysCodes("HPMOD").Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PayFrequencyItems = _commonService.GetSysCodes("HPFRQ").Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PayBankItems = _commonService.GetCodesGroups("BANK").Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.BasicCurrencyItems = _settingService.GetCurrencies(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.Des
            });
            ViewBag.CurrencyItems = _settingService.GetCurrencies(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.Des
            });
            ViewBag.TravelSectorItems = _commonService.GetCodesGroups(CodeGroup.Sector).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.TravelClassItems = _commonService.GetCodesGroups(CodeGroup.Class).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.StatusItems = _commonService.GetStatusTypes();
            ViewBag.EmpTypeItems = _commonService.GetCodesGroups("J_ET").Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.CalulationBasisTypeItems = _commonService.GetCalulationBasisTypes();
            return View("ProfileUpsert", employee ?? new Employee_Find_Result());
        }
        [HttpPost]
        public async Task<IActionResult> SavePersonalDetail(Employee_Find_Result model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            model.ConfirmPassword = model.ConfirmPassword.Encrypt();
            if (model.AvatarFile != null)
            {
                var filePath = await _fileHelper.UploadFile(model.AvatarFile, "emp-photo", _loggedInUser.CompanyCd);
                model.Imagefile = filePath;
            }
            if (model.SignatureFile != null)
            {
                var filePath = await _fileHelper.UploadFile(model.SignatureFile, "emp-sign", _loggedInUser.CompanyCd);
                model.ImageSign = filePath;
            }
            var result = _userEmployeeService.SaveEmployee(model, _loggedInUser.CompanyCd);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult RemoveAvatar(string Cd)
        {
            _userEmployeeService.RemoveAvatar(Cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = "Avatar removed successfully"
            };
            return Json(result);
        }
    }
}
