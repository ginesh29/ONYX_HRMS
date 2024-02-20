using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting.Server;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.StaticFiles;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        private readonly AuthService _authService;
        private readonly CompanyService _companyService;
        private readonly LoggedInUserModel _loggedInUser;
        public HomeController(AuthService authService, CompanyService companyService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _companyService = companyService;
        }
        public IActionResult Index()
        {
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
        public IActionResult FetchCompanies()
        {
            var companies = _companyService.GetUserCompanies(_loggedInUser.UserCd).Select(m => new SelectListItem { Value = m.CoCd.Trim(), Text = m.CoName });
            var result = new CommonResponse
            {
                Success = true,
                Data = companies
            };
            return Json(result);
        }
        public IActionResult FilePreview()
        {
            return PartialView("_FilePreview");
        }
        public IActionResult DownloadFile(string folderName, string filename)
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), $"wwwroot/uploads/{folderName}", filename);
            if (System.IO.File.Exists(filePath))
                return PhysicalFile(filePath, "application/octet-stream", filename);
            else
                return NotFound();
        }
    }
}
