using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Localization;
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
        private readonly TransactionService _transactionService;
        private readonly ReportService _reportService;
        private readonly LoggedInUserModel _loggedInUser;

        public HomeController(AuthService authService, ReportService reportService, CommonService commonService, EmployeeService employeeService, TransactionService transactionService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _reportService = reportService;
            _commonService = commonService;
            _employeeService = employeeService;
            _transactionService = transactionService;
        }
        [HttpPost]
        public IActionResult SetLanguage(string culture)
        {
            Response.Cookies.Append(
                CookieRequestCultureProvider.DefaultCookieName,
                CookieRequestCultureProvider.MakeCookieValue(new RequestCulture(culture)),
                new CookieOptions { Expires = DateTime.Now.AddYears(100) }
            );
            var refererUrl = Request.Headers["Referer"].ToString();

            if (!string.IsNullOrEmpty(refererUrl))
                return Redirect(refererUrl);
            else
                return RedirectToAction(nameof(Index));
        }
        #region Dashboard
        public IActionResult Index()
        {
            var EmplLoanAndLeaveApproval = _commonService.EmplLoanAndLeaveApproval(_loggedInUser.UserCd, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd, _loggedInUser.UserLinkedTo);
            ViewBag.EmplLoanAndLeaveApproval = EmplLoanAndLeaveApproval;
            string[] quickLinkProcessIds = ["HRPSS1", "HRPSS2", "HRPSS3", "HRPSS4"];
            var quickLinkItems = _commonService.GetMenuWithPermissions(_loggedInUser.UserLinkedTo).Where(m => quickLinkProcessIds.Contains(m.ProcessId));
            if (_loggedInUser.UserCd != "001")
                quickLinkItems = quickLinkItems.Where(m => m.Visible == "Y");
            ViewBag.QuickLinkItems = quickLinkItems;
            if (_loggedInUser.UserOrEmployee == "E")
            {
                ViewBag.EmployeeDetail = _employeeService.GetEmployees(_loggedInUser.CompanyCd, _loggedInUser.UserCd, _loggedInUser.UserLinkedTo).Employees.FirstOrDefault();
                var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
                var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
                ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
                var balanceInfo = _reportService.GetBalanceTransactions(new BalanceTransactionFilterModel
                {
                    EmpCd = _loggedInUser.UserCd,
                    ToDate = DateTime.Now
                }, _loggedInUser.CompanyCd).FirstOrDefault();
                ViewBag.BalanceDetail = balanceInfo;
            }
            return View();
        }
        public IActionResult FetchEmployees(string Type)
        {
            var employees = _employeeService.GetEmployeeItems(_loggedInUser.CompanyCd, string.Empty, _loggedInUser.UserLinkedTo, lvStatus: Type);
            return PartialView("_EmployeesListModal", employees);
        }
        public IActionResult FetchWidgetMaster()
        {
            var widgets = _commonService.GetWidgetMaster();
            CommonResponse result = new()
            {
                Data = widgets,
            };
            return Json(result);
        }
        public IActionResult FetchDashboardConfig()
        {
            var userCd = _loggedInUser.UserOrEmployee == "E" ? _loggedInUser.UserCd : _loggedInUser.UserLinkedTo;
            var widgets = _commonService.GetUserWidget(userCd);
            CommonResponse result = new()
            {
                Data = widgets,
            };
            return Json(result);
        }
        public IActionResult UpdateDashboardConfig(IEnumerable<WidgetModel> widgets)
        {
            var userCd = _loggedInUser.UserOrEmployee == "E" ? _loggedInUser.UserCd : _loggedInUser.UserLinkedTo;
            foreach (var item in widgets)
                _commonService.SaveUserWidget(item, userCd);
            return Json(null);
        }
        public IActionResult DeleteDashboardConfig(string widegetId)
        {
            var userCd = _loggedInUser.UserOrEmployee == "E" ? _loggedInUser.UserCd : _loggedInUser.UserLinkedTo;
            _commonService.DeleteUserWidget(userCd, widegetId);
            return Json(null);
        }
        public IActionResult EmpBasicDetail()
        {
            ViewBag.EmployeeDetail = _employeeService.GetEmployees(_loggedInUser.CompanyCd, _loggedInUser.UserCd, _loggedInUser.UserLinkedTo).Employees.FirstOrDefault();
            ViewBag.EmpContactDetail = _employeeService.GetAddresses(_loggedInUser.UserCd).FirstOrDefault(m => m.AddTyp.Trim() == "HADD0001");
            return PartialView("_EmpBasicDetail");
        }
        public IActionResult MyDocuments()
        {
            var EmpDocs = _employeeService.GetDocuments(_loggedInUser.UserCd, string.Empty, 0, "N", _loggedInUser.UserLinkedTo);
            return PartialView("_MyDocuments", EmpDocs);
        }
        public IActionResult MyLeaves()
        {
            var leaves = _transactionService.GetEmployee_LeaveLoanHistory(_loggedInUser.UserCd).EmpLeaves;
            return PartialView("_MyLeaves", leaves);
        }
        public IActionResult MyLoans()
        {
            var loans = _transactionService.GetEmployee_LeaveLoanHistory(_loggedInUser.UserCd).EmpLoans;
            return PartialView("_MyLoans", loans);
        }
        public IActionResult EmpSalaryChart(string container)
        {
            var EmplLoanAndLeaveApproval = _commonService.EmplLoanAndLeaveApproval(_loggedInUser.UserCd, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd, _loggedInUser.UserLinkedTo);
            foreach (var item in EmplLoanAndLeaveApproval.UserSalaryDetails)
            {
                item.Year = Convert.ToInt32(item.Prd[..4]);
                item.Month = Convert.ToInt32(item.Prd.Substring(4, 2));
                item.Prd = $"{new DateTimeFormatInfo().GetAbbreviatedMonthName(item.Month)} {item.Year}";
            }
            EmplLoanAndLeaveApproval.UserSalaryDetails = EmplLoanAndLeaveApproval.UserSalaryDetails.OrderBy(m => m.Year).ThenBy(m => m.Month);
            ViewBag.Container = container.Replace("_", "");
            return PartialView("_EmpSalaryChart", EmplLoanAndLeaveApproval.UserSalaryDetails);
        }
        public IActionResult UserSalaryChart(string container)
        {
            var EmplLoanAndLeaveApproval = _commonService.EmplLoanAndLeaveApproval(_loggedInUser.UserCd, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd, _loggedInUser.UserLinkedTo);
            foreach (var item in EmplLoanAndLeaveApproval.SalaryDetails)
            {
                item.Year = Convert.ToInt32(item.Prd[..4]);
                item.Month = Convert.ToInt32(item.Prd.Substring(4, 2));
                item.Prd = $"{new DateTimeFormatInfo().GetAbbreviatedMonthName(item.Month)} {item.Year}";
            }
            EmplLoanAndLeaveApproval.SalaryDetails = EmplLoanAndLeaveApproval.SalaryDetails.OrderBy(m => m.Year).ThenBy(m => m.Month);
            ViewBag.Container = container.Replace("_", "");
            return PartialView("_UserSalaryChart", EmplLoanAndLeaveApproval.SalaryDetails);
        }
        public IActionResult EmpStatisticsChart(string container)
        {
            var EmplLoanAndLeaveApproval = _commonService.EmplLoanAndLeaveApproval(_loggedInUser.UserCd, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd, _loggedInUser.UserLinkedTo);
            ViewBag.Container = container.Replace("_", "");
            return PartialView("_EmpStatisticsChart", EmplLoanAndLeaveApproval.HeadCounts);
        }
        public IActionResult DocExpired(ExpiredDocFilterModel filterModel, int days, string container)
        {
            filterModel.StartDate = DateTime.Now.AddDays(1).Date;
            filterModel.EndDate = DateTime.Now.AddDays(days).Date;
            var docs = _reportService.GetDocExpired(filterModel, _loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd);
            docs = docs.Select(m => { m.NoOfDays = (m.ExpDt - DateTime.Now.Date).Days; return m; }).ToList();
            ViewBag.Container = container.Replace("_", "");
            return PartialView("_DocExpired", docs);
        }
        public IActionResult EmpLeaves(string days, string type, string container)
        {
            var leaves = _commonService.GetRowEmpLeave(days, type, _loggedInUser.CompanyCd);
            leaves = leaves.Select(m => { m.NoOfDays = (m.ToDt - DateTime.Now.Date).Days; return m; }).ToList();
            ViewBag.Type = type;
            ViewBag.Container = container;
            return PartialView("_EmpLeaves", leaves);
        }
        public IActionResult EmpAnalysisChart(string container, string type, string typeText)
        {
            var data = _commonService.EmployeeWiseForChart(type);
            ViewBag.TypeText = typeText;
            ViewBag.Container = container.Replace("_", "");
            return PartialView("_EmpAnalysisChart", data);
        }
        public IActionResult EmpBirthdayEvents(string DateRange)
        {
            var start = DateTime.Now.Date;
            var end = DateTime.Now.AddDays(1).Date;
            if (!string.IsNullOrEmpty(DateRange))
            {
                var dateSp = DateRange.Split(" - ");
                start = Convert.ToDateTime(dateSp[0]);
                end = Convert.ToDateTime(dateSp[1]);
            }
            int year = start.Year;
            bool isLeapYear = year % 4 == 0;
            var events = _commonService.GetCalendarEvents(_loggedInUser.UserLinkedTo)
                .Select(m => new CalendarModel
                {
                    Id = m.SrNo.ToString(),
                    AllDay = true,
                    BackgroundColor = m.Type == "Birthday" ? "#f56954" : "#28a745",
                    BorderColor = m.Type == "Birthday" ? "#f56954" : "#28a745",
                    Start = !isLeapYear && m.Date.Day == 29 && m.Date.Month == 2 ? DateTime.MinValue.FormatDate() : new DateTime(year, m.Date.Month, m.Date.Day).ToString("dddd d MMM, yyyy"),
                    Title = $"{m.Name.Trim()}'S {m.Type.ToUpper()}",
                }).Where(m => Convert.ToDateTime(m.Start).BetweenDate(start, end)).OrderBy(m => Convert.ToDateTime(m.Start));
            return PartialView("_EmpBirthdayEvents", events);
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
