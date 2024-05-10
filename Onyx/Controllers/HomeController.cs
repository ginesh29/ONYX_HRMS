using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Onyx.Models.ViewModels;
using Onyx.Models.ViewModels.Report;
using Onyx.Services;
using System.Globalization;

namespace Onyx.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        private readonly AuthService _authService;
        private readonly CommonService _commonService;
        private readonly EmployeeService _employeeService;
        private readonly ReportService _reportService;
        private readonly LoggedInUserModel _loggedInUser;

        public HomeController(AuthService authService, ReportService reportService, CommonService commonService, EmployeeService employeeService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _reportService = reportService;
            _commonService = commonService;
            _employeeService = employeeService;
        }

        #region Dashboard
        public IActionResult Index()
        {
            var EmplLoanAndLeaveApproval = _commonService.EmplLoanAndLeaveApproval(_loggedInUser.UserCd, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd);
            EmplLoanAndLeaveApproval.HeadCounts = EmplLoanAndLeaveApproval.HeadCounts.Where(m => m.HeadCount > 0);
            foreach (var item in EmplLoanAndLeaveApproval.SalaryDetails)
            {
                item.Year = Convert.ToInt32(item.Prd[..4]);
                item.Month = Convert.ToInt32(item.Prd.Substring(4, 2));
                item.Prd = $"{new DateTimeFormatInfo().GetAbbreviatedMonthName(item.Month)} {item.Year}";
            }
            EmplLoanAndLeaveApproval.SalaryDetails = EmplLoanAndLeaveApproval.SalaryDetails.OrderBy(m => m.Year).ThenBy(m => m.Month);
            ViewBag.EmplLoanAndLeaveApproval = EmplLoanAndLeaveApproval;
            var start = DateTime.Now.Date;
            var end = start.AddDays(1).Date;
            int year = start.Year;
            bool isLeapYear = year % 4 == 0;
            var events = _commonService.GetCalendarEvents(_loggedInUser.UserCd)
                .Select(m => new CalendarModel
                {
                    Id = m.SrNo.ToString(),
                    AllDay = true,
                    BackgroundColor = m.Type == "Birthday" ? "#f56954" : "#28a745",
                    BorderColor = m.Type == "Birthday" ? "#f56954" : "#28a745",
                    Start = !isLeapYear && m.Date.Day == 29 && m.Date.Month == 2 ? DateTime.MinValue.FormatDate() : new DateTime(year, m.Date.Month, m.Date.Day).ToString("dddd d MMM, yyyy"),
                    Title = $"{m.Name.Trim()}'S {m.Type.ToUpper()}",
                }).Where(m => Convert.ToDateTime(m.Start).BetweenDate(start, end));
            ViewBag.BirthDayEvents = events;
            if (_loggedInUser.UserOrEmployee == "E")
            {
                ViewBag.EmployeeDetail = _employeeService.GetEmployees(_loggedInUser.CompanyCd, _loggedInUser.UserCd, _loggedInUser.UserAbbr).Employees.FirstOrDefault();
                ViewBag.EmpContactDetail = _employeeService.GetAddresses(_loggedInUser.UserCd).FirstOrDefault(m => m.AddTyp.Trim() == "HADD0001");
                ViewBag.EmpDocs = _employeeService.GetDocuments(_loggedInUser.UserCd, string.Empty, 0, "N", _loggedInUser.UserAbbr);                
            }
            var quickLinkItems = _commonService.GetMenuWithPermissions(_loggedInUser.UserAbbr).Where(m => m.ProcessId == "HRPSS1" || m.ProcessId == "HRPSS2");
            if (_loggedInUser.UserCd != "001")
                quickLinkItems = quickLinkItems.Where(m => m.Visible == "Y");
            ViewBag.QuickLinkItems = quickLinkItems;
            if(_loggedInUser.UserOrEmployee == "E")
            {
                var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
                var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
                ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
            }           
            return View();
        }
        public IActionResult FetchDocExpired(ExpiredDocFilterModel filterModel, int days)
        {
            filterModel.StartDate = DateTime.Now.AddDays(1).Date;
            filterModel.EndDate = DateTime.Now.AddDays(days).Date;
            var docs = _reportService.GetDocExpired(filterModel, _loggedInUser.UserCd, _loggedInUser.CompanyCd);
            docs = docs.Select(m => { m.NoOfDays = (m.ExpDt - DateTime.Now.Date).Days; return m; }).ToList();
            CommonResponse result = new()
            {
                Data = docs,
            };
            return Json(result);
        }
        public IActionResult FetchEmpLeaves(string days, string type)
        {
            var leaves = _commonService.GetRowEmpLeave(days, type, _loggedInUser.CompanyCd);
            leaves = leaves.Select(m => { m.NoOfDays = (m.ToDt - DateTime.Now.Date).Days; return m; }).ToList();
            CommonResponse result = new()
            {
                Data = leaves,
            };
            return Json(result);
        }
        public IActionResult EmployeeWiseForChart(string type)
        {
            var data = _commonService.EmployeeWiseForChart(type);
            var result = new ChartModel
            {
                xAxis = data.Select(m => m.Des).ToArray(),
                yAxis = data.Select(m => m.Count).ToArray(),
            };
            return Json(result);
        }
        #endregion

        public async Task<IActionResult> UpdateClaim(string claimType, string claimValue)
        {
            await _authService.UpdateClaim(claimType, claimValue);
            var result = new CommonResponse
            {
                Success = true,
                Message = "Company changed successfully"
            };
            return Json(result);
        }
        public IActionResult FilePreview()
        {
            return PartialView("_FilePreview");
        }
        public IActionResult DownloadFile(string folderName, string filename)
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), $"wwwroot/uploads/{_loggedInUser.CompanyCd}/{folderName}", filename);
            if (System.IO.File.Exists(filePath))
                return PhysicalFile(filePath, "application/octet-stream", filename);
            else
                return NotFound();
        }

    }
}
