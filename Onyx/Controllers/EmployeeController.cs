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
        public IActionResult FetchEmployeeItems(string departments, string designations, string branches, string locations)
        {
            var deptList = departments?.Split(",").ToList();
            var designationList = designations?.Split(",").ToList();
            var branchList = branches?.Split(",").ToList();
            var locationsList = locations?.Split(",").ToList();
            var employees = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd).Where(m => (deptList != null && deptList.Contains(m.DepartmentCd.Trim())) || (designationList != null && designationList.Contains(m.Designation.Trim())) || (branchList != null && branchList.Contains(m.BranchCd.Trim())) || (locationsList != null && locationsList.Contains(m.LocationCd.Trim())));
            employees = employees.Select(m =>
            {
                m.Department = m.Department.Trim();
                m.Designation = m.Designation?.Trim();
                m.Branch = m.Branch.Trim();
                m.Location = m.Location.Trim();
                return m;
            }).ToList();
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
            var employee = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd).FirstOrDefault(m => m.Cd.Trim() == Cd);
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
                Text = m.Nationality.Trim()
            });
            ViewBag.ReligionItems = _commonService.GetCodesGroups(CodeGroup.Religion).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.SponsorItems = _commonService.GetCodesGroups(CodeGroup.Sponsor).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.DesignationItems = _organisationService.GetDesignations().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.BranchItems = _settingService.GetBranches(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.Department
            });
            ViewBag.LocationItems = _commonService.GetCodesGroups(CodeGroup.EmpDeployLoc).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.ReportingToItems = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.Name
            });
            ViewBag.UserItems = _settingService.GetUsers().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.Username
            });
            return View(employee);
        }
    }
}
