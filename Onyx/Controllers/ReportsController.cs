using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Models.ViewModels.Report;
using Onyx.Services;
using Rotativa.AspNetCore;
using Rotativa.AspNetCore.Options;
using System.Security.Cryptography.Xml;

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
        #region Emp Short List
        public IActionResult EmpShortList()
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
            ViewBag.EmpTypeItems = _commonService.GetCodesGroups(CodeGroup.EmpType).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.StatusItems = _commonService.GetSysCodes(SysCode.EmpStatus).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.NationalityItems = _settingService.GetCountries().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.Nationality
            });
            ViewBag.QualificationItems = _settingService.GetCodeGroupItems(CodeGroup.Qualification).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            var currntMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currntYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currntMonth}/{currntYear}";
            return View();
        }
        public IActionResult FetchEmpShortListData(EmpShortListFilterModel filterModel)
        {
            var spPeriod = filterModel.Period.Split('/');
            filterModel.Period = $"{spPeriod[1]}{spPeriod[0]}";
            var employees = _reportService.GetEmpShortList(filterModel, _loggedInUser.CompanyCd).ToList();
            ViewBag.TableResponsiveClass = "table-responsive";
            return PartialView("_EmpShortList", new EmpShortListReportModel { Employees = employees, VisibleColumns = filterModel.VisibleColumns });
        }
        public IActionResult EmpShortListReport(EmpShortListFilterModel filterModel)
        {
            var spPeriod = filterModel.Period.Split('/');
            filterModel.Period = $"{spPeriod[1]}{spPeriod[0]}";
            var employees = _reportService.GetEmpShortList(filterModel, _loggedInUser.CompanyCd).ToList();
            return new ViewAsPdf(new EmpShortListReportModel { Employees = employees, VisibleColumns = filterModel.VisibleColumns })
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                PageOrientation = Orientation.Landscape
            };
        }
        #endregion

        #region Emp Transactions
        public IActionResult EmpTransactions()
        {
            var currntMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currntYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currntMonth}/{currntYear}";
            return View();
        }
        public IActionResult FetchEmpTransactions(EmpTransactionFilterModel filterModel)
        {
            var spStartPeriod = filterModel.StartPeriod.Split('/');
            filterModel.StartPeriod = $"{spStartPeriod[1]}{spStartPeriod[0]}";
            var spEndPeriod = filterModel.EndPeriod.Split('/');
            filterModel.EndPeriod = $"{spEndPeriod[1]}{spEndPeriod[0]}";
            var transactions = _reportService.GetEmpTransactions(filterModel, _loggedInUser.CompanyCd);
            return PartialView("_EmpTransactions", transactions);
        }
        public IActionResult EmpTransactionsReport(EmpTransactionFilterModel filterModel)
        {
            var spStartPeriod = filterModel.StartPeriod.Split('/');
            filterModel.StartPeriod = $"{spStartPeriod[1]}{spStartPeriod[0]}";
            var spEndPeriod = filterModel.EndPeriod.Split('/');
            filterModel.EndPeriod = $"{spEndPeriod[1]}{spEndPeriod[0]}";
            var transactions = _reportService.GetEmpTransactions(filterModel, _loggedInUser.CompanyCd);
            return new ViewAsPdf(transactions)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                PageOrientation = Orientation.Landscape
            };
        }
        #endregion

        #region Balance Transactions
        public IActionResult Balance()
        {
            return View();
        }
        public IActionResult FetchBalanceTransactions(BalanceTransactionFilterModel filterModel)
        {
            var transactions = _reportService.GetBalanceTransactions(filterModel, _loggedInUser.CompanyCd);
            ViewBag.TableResponsiveClass = "table-responsive";
            return PartialView("_BalanceTransactions", transactions);
        }
        public IActionResult BalanceTransactionsReport(BalanceTransactionFilterModel filterModel)
        {
            var transactions = _reportService.GetBalanceTransactions(filterModel, _loggedInUser.CompanyCd);
            return new ViewAsPdf(transactions)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                PageOrientation = Orientation.Landscape
            };
        }
        #endregion

        #region Provisions
        public IActionResult Provisions()
        {
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            var currntMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currntYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currntMonth}/{currntYear}";
            return View();
        }
        public IActionResult FetchProvisions(ProvisionFilterModel filterModel)
        {
            var spStartPeriod = filterModel.Period.Split('/');
            filterModel.Period = spStartPeriod[0];
            filterModel.Year = spStartPeriod[1];
            var provisions = _reportService.GetProvisions(filterModel, _loggedInUser.CompanyCd);
            ViewBag.TableResponsiveClass = "table-responsive";
            return PartialView("_Provisions", provisions);
        }
        public IActionResult ProvisionsReport(ProvisionFilterModel filterModel)
        {
            var spStartPeriod = filterModel.Period.Split('/');
            filterModel.Period = spStartPeriod[0];
            filterModel.Year = spStartPeriod[1];
            var provisions = _reportService.GetProvisions(filterModel, _loggedInUser.CompanyCd);
            return new ViewAsPdf(provisions)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                PageOrientation = Orientation.Landscape
            };
        }
        #endregion

        #region Pay Slip
        public IActionResult PaySlip()
        {
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            var currntMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currntYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currntMonth}/{currntYear}";
            return View();
        }
        public IActionResult FetchPaySlips(PaySlipFilterModel filterModel)
        {
            var spStartPeriod = filterModel.Period.Split('/');
            filterModel.Period = spStartPeriod[0];
            filterModel.Year = spStartPeriod[1];
            var payslips = _reportService.GetPaySlips(filterModel, _loggedInUser.CompanyCd);
            return PartialView("_PaySlips", payslips);
        }
        public IActionResult PaySlipsReport(PaySlipFilterModel filterModel)
        {
            var spStartPeriod = filterModel.Period.Split('/');
            filterModel.Period = spStartPeriod[0];
            filterModel.Year = spStartPeriod[1];
            var payslips = _reportService.GetPaySlips(filterModel, _loggedInUser.CompanyCd);
            return new ViewAsPdf(payslips)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion
    }
}
