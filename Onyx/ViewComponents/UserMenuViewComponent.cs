using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;
using System.Globalization;

namespace Onyx.ViewComponents
{
    public class UserMenuViewComponent : ViewComponent
    {
        private readonly AuthService _authService;
        private readonly UserEmployeeService _userEmployeeService;
        private readonly CommonService _commonService;
        private readonly CompanyService _companyService;
        private readonly LoggedInUserModel _loggedInUser;
        public UserMenuViewComponent(AuthService authService, UserEmployeeService userEmployeeService, CommonService commonService, CompanyService companyService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _userEmployeeService = userEmployeeService;
            _commonService = commonService;
            _companyService = companyService;
        }
        public IViewComponentResult Invoke()
        {
            var user = _userEmployeeService.GetUser(_loggedInUser.CompanyAbbr, _loggedInUser.UserCd);
            var employee = _userEmployeeService.GetEmployee(_loggedInUser.CompanyAbbr, _loggedInUser.EmployeeCd);
            var month = Convert.ToInt32(_commonService.GetJobCardStartAndEndTime(_loggedInUser.CompanyAbbr, _loggedInUser.CompanyCd, "CUR_MONTH")?.Val);
            var year = _commonService.GetJobCardStartAndEndTime(_loggedInUser.CompanyAbbr, _loggedInUser.CompanyCd, "CUR_YEAR")?.Val;
            bool imageExist = employee != null && File.Exists(Path.Combine(Directory.GetCurrentDirectory(), $"wwwroot/uploads/emp_photo/{_loggedInUser.CompanyCd}", employee.Imagefile));
            var companies = _companyService.GetCompanies(_loggedInUser.CompanyAbbr, _loggedInUser.UserCd).Select(m => new SelectListItem { Value = m.CoCd, Text = m.CoName });
            if (companies.Count() == 1)
                companies = companies.Select(m => { m.Selected = true; return m; });
            else
                companies = companies.Select(m => { m.Selected = m.Value.Trim() == _loggedInUser.CompanyCd; return m; });
            ViewBag.CompanyItems = companies;
            var userMenu = new UserMenuModel
            {
                EmployeeName = employee != null ? $"{employee.Fname} {employee.Lname}" : null,
                Username = user.Username,
                UserCd = _loggedInUser.UserCd,
                CurrentPeriod = month > 0 && !string.IsNullOrEmpty(year) ? $"{DateTimeFormatInfo.CurrentInfo.GetMonthName(month)} {year}" : null,
                CurrentLogged = _commonService.GetCuurentLoggedInDetails(_loggedInUser.CompanyAbbr, _loggedInUser.CompanyCd),
                ProfilePic = employee != null && imageExist ? employee.Imagefile : null
            };
            return View(userMenu);
        }
    }
}