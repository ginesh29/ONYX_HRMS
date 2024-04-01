using Microsoft.AspNetCore.Mvc;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    public class ReportsController : Controller
    {
        private readonly ReportService _reportService;
        private readonly AuthService _authService;
        private readonly LoggedInUserModel _loggedInUser;
        public ReportsController(ReportService reportService, AuthService authService)
        {
            _reportService = reportService;
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
        }
        public IActionResult EmpShortListReport()
        {
            return View();
        }
        public IActionResult FetchEmpShotListReportData()
        {
            var empShortList = _reportService.GetEmpShortList(_loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = empShortList,
            };
            return Json(result);
        }
    }
}
