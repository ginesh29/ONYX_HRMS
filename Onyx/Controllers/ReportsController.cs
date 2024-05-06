using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Models.ViewModels.Report;
using Onyx.Services;
using Rotativa.AspNetCore;
using Rotativa.AspNetCore.Options;

namespace Onyx.Controllers
{
    public class ReportsController : Controller
    {
        private readonly ReportService _reportService;
        private readonly CommonService _commonService;
        private readonly AuthService _authService;
        private readonly OrganisationService _organisationService;
        private readonly SettingService _settingService;
        private readonly EmployeeService _employeeService;
        private readonly LoggedInUserModel _loggedInUser;
        public ReportsController(ReportService reportService, AuthService authService, CommonService commonService, OrganisationService organisationService, SettingService settingService, EmployeeService employeeService)
        {
            _reportService = reportService;
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _commonService = commonService;
            _organisationService = organisationService;
            _settingService = settingService;
            _employeeService = employeeService;
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
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
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
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
            return View();
        }
        public IActionResult FetchEmpTransactions(EmpTransactionFilterModel filterModel)
        {
            var spStartPeriod = filterModel.StartPeriod.Split('/');
            filterModel.StartPeriod = $"{spStartPeriod[1]}{spStartPeriod[0]}";
            var spEndPeriod = filterModel.EndPeriod.Split('/');
            filterModel.EndPeriod = $"{spEndPeriod[1]}{spEndPeriod[0]}";
            var transactions = _reportService.GetEmpTransactions(filterModel, _loggedInUser.CompanyCd);
            return PartialView("_EmpTransactions", new { Data = transactions });
        }
        public IActionResult EmpTransactionsReport(EmpTransactionFilterModel filterModel)
        {
            var spStartPeriod = filterModel.StartPeriod.Split('/');
            filterModel.StartPeriod = $"{spStartPeriod[1]}{spStartPeriod[0]}";
            var spEndPeriod = filterModel.EndPeriod.Split('/');
            filterModel.EndPeriod = $"{spEndPeriod[1]}{spEndPeriod[0]}";
            var employee = _employeeService.GetEmployees(_loggedInUser.CompanyCd, _loggedInUser.UserAbbr, _loggedInUser.UserCd).Employees.FirstOrDefault();
            var ReportGeneratedBy = _loggedInUser.UserType == (int)UserTypeEnum.Employee ? employee.Name : _loggedInUser.UserAbbr;
            var transactions = _reportService.GetEmpTransactions(filterModel, _loggedInUser.CompanyCd);
            return new ViewAsPdf(new { Data = transactions, ReportGeneratedBy })
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
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
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
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
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

        #region Emp LeaveMaster
        public IActionResult LeaveMaster()
        {
            ViewBag.ReportType = "LeaveMaster";
            return View();
        }
        public IActionResult FetchLeaveMaster(string reportType)
        {
            var leaveMaster = _reportService.GetEmpLeaveMaster(_loggedInUser.CompanyCd);
            ViewBag.TableResponsiveClass = "table-responsive";
            return PartialView("_LeaveMaster", new { Data = leaveMaster, ReportType = reportType });
        }
        public IActionResult LeaveMasterReport(string reportType)
        {
            var leaveMaster = _reportService.GetEmpLeaveMaster(_loggedInUser.CompanyCd);
            return new ViewAsPdf(new { Data = leaveMaster, ReportType = reportType })
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        public IActionResult AnnualLeaveDue()
        {
            ViewBag.ReportType = "LeaveDue";
            return View("LeaveMaster");
        }
        #endregion

        #region Emp Transfer
        public IActionResult EmpTransfer()
        {
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
            ViewBag.LocationItems = _settingService.GetCodeGroupItems(CodeGroup.EmpDeployLoc).Select(m => new SelectListItem
            {
                Text = $"{m.ShortDes}({m.Code.Trim()})",
                Value = m.Code.Trim(),
            });
            return View();
        }
        public IActionResult FetchEmpTransfer(EmpTranferFilterModel filterModel)
        {
            var dateSp = filterModel.DateRange.Split(" - ");
            filterModel.StartDate = Convert.ToDateTime(dateSp[0]);
            filterModel.EndDate = Convert.ToDateTime(dateSp[1]);
            var empTransfer = _reportService.GetEmpTransfer(filterModel, _loggedInUser.CompanyCd);
            ViewBag.TableResponsiveClass = "table-responsive";
            return PartialView("_EmpTransfer", empTransfer);
        }
        public IActionResult EmpTransferReport(EmpTranferFilterModel filterModel)
        {
            var dateSp = filterModel.DateRange.Split(" - ");
            filterModel.StartDate = Convert.ToDateTime(dateSp[0]);
            filterModel.EndDate = Convert.ToDateTime(dateSp[1]);
            var empTransfer = _reportService.GetEmpTransfer(filterModel, _loggedInUser.CompanyCd);
            return new ViewAsPdf(empTransfer)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                PageOrientation = Orientation.Landscape
            };
        }
        #endregion

        #region Emp Loan
        public IActionResult EmpLoan()
        {
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
            return View();
        }
        public IActionResult FetchEmpLoan(EmpLoanFilterModel filterModel)
        {
            var loans = _reportService.GetEmpLoan(filterModel, _loggedInUser.CompanyCd);
            return PartialView("_EmpLoan", loans);
        }
        public IActionResult EmpLoanReport(EmpLoanFilterModel filterModel)
        {
            var loans = _reportService.GetEmpLoan(filterModel, _loggedInUser.CompanyCd);
            return new ViewAsPdf(loans)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region Loan Due List
        public IActionResult LoanDueList()
        {
            return View();
        }
        public IActionResult FetchLoanDueList()
        {
            var loans = _reportService.GetEmpLoanDueList(_loggedInUser.CompanyCd);
            return PartialView("_LoanDueList", loans);
        }
        public IActionResult LoanDueListReport()
        {
            var loans = _reportService.GetEmpLoanDueList(_loggedInUser.CompanyCd);
            return new ViewAsPdf(loans)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region Loan Analysis
        public IActionResult LoanAnalysis()
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
            ViewBag.LocationItems = _settingService.GetCodeGroupItems(CodeGroup.EmpDeployLoc).Select(m => new SelectListItem
            {
                Text = $"{m.ShortDes}({m.Code.Trim()})",
                Value = m.Code.Trim(),
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
            ViewBag.LoanTypeItems = _organisationService.GetLoanTypes().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.Des.Trim(),
            });
            ViewBag.NationalityItems = _settingService.GetCountries().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.Nationality
            });
            ViewBag.LoanStatusItems = _commonService.GetEmpLoanStatuses();
            return View();
        }
        public IActionResult FetchLoanAnalysis(EmpLoanAnalysisFilterModel filterModel)
        {
            var loans = _reportService.GetEmpLoanAnalysis(filterModel, _loggedInUser.CompanyCd);
            return PartialView("_LoanAnalysis", loans);
        }
        public IActionResult LoanAnalysisReport(EmpLoanAnalysisFilterModel filterModel)
        {
            var loans = _reportService.GetEmpLoanAnalysis(filterModel, _loggedInUser.CompanyCd);
            return new ViewAsPdf(loans)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                PageOrientation = Orientation.Landscape
            };
        }
        #endregion

        #region Leave Analysis
        public IActionResult LeaveAnalysis()
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
            ViewBag.LocationItems = _settingService.GetCodeGroupItems(CodeGroup.EmpDeployLoc).Select(m => new SelectListItem
            {
                Text = $"{m.ShortDes}({m.Code.Trim()})",
                Value = m.Code.Trim(),
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
            ViewBag.LeaveTypeItems = _organisationService.GetLeaveTypes(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.LeaveStatusItems = _commonService.GetEmpLeaveStatuses();
            return View();
        }
        public IActionResult FetchLeaveAnalysis(EmpLeaveAnalysisFilterModel filterModel)
        {
            var loans = _reportService.GetEmpLeaveAnalysis(filterModel, _loggedInUser.CompanyCd);
            return PartialView("_LeaveAnalysis", loans);
        }
        public IActionResult LeaveAnalysisReport(EmpLeaveAnalysisFilterModel filterModel)
        {
            var loans = _reportService.GetEmpLeaveAnalysis(filterModel, _loggedInUser.CompanyCd);
            return new ViewAsPdf(loans)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                PageOrientation = Orientation.Landscape
            };
        }
        #endregion

        #region Expired Doc
        public IActionResult DocExpired()
        {
            ViewBag.EmpDocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.EmpDocType).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.ComDocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.CompanyDocType).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.VehDocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.VehicleDocType).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            return View();
        }
        public IActionResult FetchDocExpired(ExpiredDocFilterModel filterModel)
        {
            var loans = _reportService.GetDocExpired(filterModel, _loggedInUser.UserCd, _loggedInUser.CompanyCd);
            return PartialView("_DocExpired", loans);
        }
        public IActionResult DocExpiredReport(ExpiredDocFilterModel filterModel)
        {
            var loans = _reportService.GetDocExpired(filterModel, _loggedInUser.UserCd, _loggedInUser.CompanyCd);
            return new ViewAsPdf(loans)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region Employee Fixed Payroll
        public IActionResult EmployeeFixedPayroll()
        {
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserCd, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            return View();
        }
        public IActionResult FetchEmpFixedPayroll(EmplFixedPayrollFilterModel filterModel)
        {
            var loans = _reportService.GetEmpFixedPayroll(filterModel, _loggedInUser.CompanyCd);
            return PartialView("_DocExpired", loans);
        }
        public IActionResult EmpFixedPayrollReport(EmplFixedPayrollFilterModel filterModel)
        {
            var loans = _reportService.GetEmpFixedPayroll(filterModel, _loggedInUser.CompanyCd);
            return new ViewAsPdf(loans)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion
    }
}