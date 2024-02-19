using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
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
        private readonly LoggedInUserModel _loggedInUser;
        public EmployeeController(AuthService authService, UserEmployeeService userEmployeeService)
        {
            _userEmployeeService = userEmployeeService;
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
        }
        public IActionResult Details(int? page)
        {
            var employees = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd);
            int pageNumber = page ?? 1;
            int pageSize = 9;
            IPagedList<Employee_GetRow_Result> pagedEmployees = employees.ToPagedList(pageNumber, pageSize);
            return View(pagedEmployees);
        }
        public IActionResult FetchEmployees(int? page)
        {
            var employees = _userEmployeeService.GetEmployees(_loggedInUser.CompanyCd);
            int pageNumber = page ?? 1;
            int pageSize = 9;
            IPagedList<Employee_GetRow_Result> pagedEmployees = employees.ToPagedList(pageNumber, pageSize);
            return PartialView("_EmployeesList", pagedEmployees);
        }
    }
}
