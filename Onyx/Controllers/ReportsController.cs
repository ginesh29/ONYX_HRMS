﻿using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    public class ReportsController : Controller
    {
        private readonly ReportService _reportService;
        private readonly CommonService _commonService;
        private readonly AuthService _authService;
        private readonly OrganisationService _organisationService;
        private readonly SettingService _settingService;
        private readonly LoggedInUserModel _loggedInUser;
        public ReportsController(ReportService reportService, AuthService authService, CommonService commonService, OrganisationService organisationService, SettingService settingService)
        {
            _reportService = reportService;
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _commonService = commonService;
            _organisationService = organisationService;
            _settingService = settingService;
        }
        public IActionResult EmpShortListReport()
        {
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
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
