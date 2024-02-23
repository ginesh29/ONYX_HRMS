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
        public EmployeeController(AuthService authService, UserEmployeeService userEmployeeService, CommonService commonService, SettingService settingService, OrganisationService organisationService)
        {
            _userEmployeeService = userEmployeeService;
            _authService = authService;
            _commonService = commonService;
            _settingService = settingService;
            _loggedInUser = _authService.GetLoggedInUser();
            _organisationService = organisationService;
        }
        public IActionResult Details(int? page)
        {
            var employees = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd);
            int pageNumber = page ?? 1;
            int pageSize = 9;
            IPagedList<Employee_GetRow_Result> pagedEmployees = employees.ToPagedList(pageNumber, pageSize);
            return View(pagedEmployees);
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
            var employees = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd);
            int pageNumber = page ?? 1;
            int pageSize = 9;
            IPagedList<Employee_GetRow_Result> pagedEmployees = employees.ToPagedList(pageNumber, pageSize);
            return PartialView("_EmployeesList", pagedEmployees);
        }
        public IActionResult Profile(string Cd)
        {
            var employee = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd, Cd).FirstOrDefault(m => m.Cd.Trim() == Cd);
            ViewBag.SalutationItems = _commonService.GetCodesGroups(CodeGroup.Salutation).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.MaritalStatusItems = _commonService.GetCodesGroups(CodeGroup.MaritalStatus).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.ShortDes}({m.Code.Trim()})"
            });
            ViewBag.NationalityItems = _settingService.GetCountries().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Nationality}({m.Code.Trim()})"
            });
            ViewBag.ReligionItems = _commonService.GetCodesGroups(CodeGroup.Religion).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.ShortDes}({m.Code.Trim()})"
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
            return View(employee);
        }
        [HttpPost]
        public IActionResult SavePesonalDetail(Employee_GetRow_Result model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _userEmployeeService.SaveEmployee(model, _loggedInUser.CompanyCd);
            return Json(result);
        }
    }
}
