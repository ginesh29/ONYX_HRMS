using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Onyx.Models.ViewModels;
using Onyx.Models.ViewModels.Report;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        private readonly AuthService _authService;
        private readonly EmployeeService _employeeService;
        private readonly ReportService _reportService;
        private readonly LoggedInUserModel _loggedInUser;

        public HomeController(AuthService authService, ReportService reportService, EmployeeService employeeService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _reportService = reportService;
            _employeeService = employeeService;
        }
        public IActionResult Index()
        {
            var EmplLoanAndLeaveApproval = _employeeService.EmplLoanAndLeaveApproval(_loggedInUser.UserCd, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd);
            EmplLoanAndLeaveApproval.HeadCounts = EmplLoanAndLeaveApproval.HeadCounts.Where(m => m.HeadCount > 0);
            ViewBag.EmplLoanAndLeaveApproval = EmplLoanAndLeaveApproval;
            return View();
        }
        public async Task<IActionResult> UpdateCompany(string CoCd)
        {
            await _authService.UpdateClaim("CompanyCd", CoCd.Trim());
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
        #region Dashboard
        public IActionResult FetchDocExpired(ExpiredDocFilterModel filterModel, int days)
        {
            filterModel.StartDate = DateTime.Now.Date;
            filterModel.EndDate = DateTime.Now.AddDays(days);
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
            var leaves = _employeeService.GetRowEmpLeave(days, type, _loggedInUser.CompanyCd);
            leaves = leaves.Select(m => { m.NoOfDays = (m.ToDt - DateTime.Now.Date).Days; return m; }).ToList();
            CommonResponse result = new()
            {
                Data = leaves,
            };
            return Json(result);
        }
        public IActionResult EmployeeWiseForChart(string type)
        {
            var data = _employeeService.EmployeeWiseForChart(type);
            var result = new ChartModel
            {
                xAxis = data.Select(m => m.Des).ToArray(),
                yAxis = data.Select(m => m.Count).ToArray(),
            };
            return Json(result);
        }
        #endregion
    }
}
