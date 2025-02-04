﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Models.ViewModels.Report;
using Onyx.Services;
using Rotativa.AspNetCore;
using Rotativa.AspNetCore.Options;

namespace Onyx.Controllers
{
    [Authorize]
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
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
            var employees = _reportService.GetEmpShortList(filterModel, _loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).ToList();
            ViewBag.TableResponsiveClass = "table-responsive";
            return PartialView("_EmpShortList", new EmpShortListReportModel { Employees = employees, VisibleColumns = filterModel.VisibleColumns });
        }
        public IActionResult EmpShortListReport(EmpShortListFilterModel filterModel)
        {
            var spPeriod = filterModel.Period.Split('/');
            filterModel.Period = $"{spPeriod[1]}{spPeriod[0]}";
            var employees = _reportService.GetEmpShortList(filterModel, _loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).ToList();
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
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

        #region Payslip
        public IActionResult PaySlip()
        {
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
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
            if (!string.IsNullOrEmpty(filterModel.DateRange))
            {
                var dateSp = filterModel.DateRange.Split(" - ");
                filterModel.StartDate = Convert.ToDateTime(dateSp[0]);
                filterModel.EndDate = Convert.ToDateTime(dateSp[1]);
            }
            var loans = _reportService.GetEmpLeaveAnalysis(filterModel, _loggedInUser.CompanyCd, _loggedInUser.UserLinkedTo);
            ViewBag.TableResponsiveClass = "table-responsive";
            return PartialView("_LeaveAnalysis", loans);
        }
        public IActionResult LeaveAnalysisReport(EmpLeaveAnalysisFilterModel filterModel)
        {
            if (!string.IsNullOrEmpty(filterModel.DateRange))
            {
                var dateSp = filterModel.DateRange.Split(" - ");
                filterModel.StartDate = Convert.ToDateTime(dateSp[0]);
                filterModel.EndDate = Convert.ToDateTime(dateSp[1]);
            }
            var loans = _reportService.GetEmpLeaveAnalysis(filterModel, _loggedInUser.CompanyCd, _loggedInUser.UserLinkedTo);
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
            if (!string.IsNullOrEmpty(filterModel.DateRange))
            {
                var dateSp = filterModel.DateRange.Split(" - ");
                filterModel.StartDate = Convert.ToDateTime(dateSp[0]);
                filterModel.EndDate = Convert.ToDateTime(dateSp[1]);
            }
            var loans = _reportService.GetDocExpired(filterModel, _loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd);
            return PartialView("_DocExpired", loans);
        }
        public IActionResult DocExpiredReport(ExpiredDocFilterModel filterModel)
        {
            if (!string.IsNullOrEmpty(filterModel.DateRange))
            {
                var dateSp = filterModel.DateRange.Split(" - ");
                filterModel.StartDate = Convert.ToDateTime(dateSp[0]);
                filterModel.EndDate = Convert.ToDateTime(dateSp[1]);
            }
            var loans = _reportService.GetDocExpired(filterModel, _loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd);
            return new ViewAsPdf(loans)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region Employee Fixed Payroll
        public IActionResult EmployeeFixedPayroll()
        {
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            return View();
        }
        public IActionResult FetchEmpFixedPayroll(EmplFixedPayrollFilterModel filterModel)
        {
            var data = _reportService.GetEmpFixedPayroll(filterModel, _loggedInUser.CompanyCd);
            return PartialView("_EmployeeFixedPayroll", data);
        }
        public IActionResult EmpFixedPayrollReport(EmplFixedPayrollFilterModel filterModel)
        {
            var data = _reportService.GetEmpFixedPayroll(filterModel, _loggedInUser.CompanyCd);
            return new ViewAsPdf(data)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                PageOrientation = Orientation.Landscape,
            };
        }
        #endregion

        #region Pay Register
        public IActionResult PayRegister()
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
            ViewBag.NationalityItems = _settingService.GetCountries().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.Nationality
            });
            ViewBag.LocationItems = _settingService.GetCodeGroupItems(CodeGroup.EmpDeployLoc).Select(m => new SelectListItem
            {
                Text = $"{m.ShortDes}({m.Code.Trim()})",
                Value = m.Code.Trim(),
            });
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
            return View();
        }
        public IActionResult FetchPayRegister(EmpPayRegisterFilterModel filterModel)
        {
            var spPeriod = filterModel.Period.Split('/');
            filterModel.Month = spPeriod[0];
            filterModel.Year = spPeriod[1];
            ViewBag.TableResponsiveClass = "table-responsive";
            if (filterModel.Type == "Detail")
            {
                var data = _reportService.GetRepo_EmpPayDetail(filterModel, _loggedInUser.CompanyCd);
                return PartialView("_PayRegisterDetail", data);
            }
            else if (filterModel.Type == "Summary")
            {
                var data = _reportService.GetRepo_EmpPayDetail_Summary(filterModel, _loggedInUser.CompanyCd);
                return PartialView("_PayRegisterSummary", data);
            }
            else
            {
                var data = _reportService.GetRepo_EmpPayDetail_Format(filterModel, _loggedInUser.CompanyCd);
                return PartialView("_PayRegisterFormat1", data);
            }
        }
        public IActionResult PayRegisterReport(EmpPayRegisterFilterModel filterModel)
        {
            var spPeriod = filterModel.Period.Split('/');
            filterModel.Month = spPeriod[0];
            filterModel.Year = spPeriod[1];
            if (filterModel.Type == "Detail")
            {
                var data = _reportService.GetRepo_EmpPayDetail(filterModel, _loggedInUser.CompanyCd);
                return new ViewAsPdf(data)
                {
                    PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                    PageOrientation = Orientation.Landscape,
                };
            }
            else if (filterModel.Type == "Summary")
            {
                var data = _reportService.GetRepo_EmpPayDetail_Summary(filterModel, _loggedInUser.CompanyCd);
                return new ViewAsPdf(data)
                {
                    PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                };
            }
            else
            {
                var data = _reportService.GetRepo_EmpPayDetail_Format(filterModel, _loggedInUser.CompanyCd);
                return new ViewAsPdf(data) { PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 }, PageOrientation = Orientation.Landscape };
            }
        }
        #endregion

        #region Leave Analysis
        public IActionResult PayAnalysis()
        {
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            return View();
        }
        public IActionResult FetchPayAnalysis(PayAnalysisFilterModel filterModel)
        {
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            filterModel.Year = currentYear;
            filterModel.Period = currentMonth;
            var data = _reportService.GetPayAnalysis(filterModel, _loggedInUser.CompanyCd).Where(m => m.Amt != 0);
            return PartialView("_PayAnalysis", data);
        }
        public IActionResult PayAnalysisReport(PayAnalysisFilterModel filterModel)
        {
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            filterModel.Year = currentYear;
            filterModel.Period = currentMonth;
            var data = _reportService.GetPayAnalysis(filterModel, _loggedInUser.CompanyCd).Where(m => m.Amt != 0);
            return new ViewAsPdf(data)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region Branches
        public IActionResult BranchList()
        {
            return View();
        }
        public IActionResult FetchBranches()
        {
            var branches = _reportService.GetRepo_Branches(_loggedInUser.CompanyCd);
            return PartialView("_Branches", branches);
        }
        public IActionResult BranchListReport()
        {
            var branches = _reportService.GetRepo_Branches(_loggedInUser.CompanyCd);
            return new ViewAsPdf(branches)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region Users
        public IActionResult UserList()
        {
            return View();
        }
        public IActionResult FetchUsers()
        {
            var users = _reportService.GetRepo_Users();
            return PartialView("_Users", users);
        }
        public IActionResult UserListReport()
        {
            var users = _reportService.GetRepo_Users();
            return new ViewAsPdf(users)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region Vehicles
        public IActionResult VehicleList()
        {
            return View();
        }
        public IActionResult FetchVehicles()
        {
            var vehicles = _reportService.GetRepo_Vehicles(_loggedInUser.CompanyCd);
            return PartialView("_Vehicles", vehicles);
        }
        public IActionResult VehicleListReport()
        {
            var vehicles = _reportService.GetRepo_Vehicles(_loggedInUser.CompanyCd);
            return new ViewAsPdf(vehicles)
            {
                PageOrientation = Orientation.Landscape,
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region Codes
        public IActionResult CodeList()
        {
            return View();
        }
        public IActionResult FetchCodes()
        {
            var codes = _reportService.GetRepo_Codes(_loggedInUser.CompanyCd);
            return PartialView("_Codes", codes);
        }
        public IActionResult CodeListReport()
        {
            var codes = _reportService.GetRepo_Codes(_loggedInUser.CompanyCd);
            return new ViewAsPdf(codes)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region Countries
        public IActionResult CountryList()
        {
            return View();
        }
        public IActionResult FetchCountries()
        {
            var countries = _reportService.GetRepo_Country(_loggedInUser.CompanyCd);
            return PartialView("_Countries", countries);
        }
        public IActionResult CountryListReport()
        {
            var countries = _reportService.GetRepo_Country(_loggedInUser.CompanyCd);
            return new ViewAsPdf(countries)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region Currency
        public IActionResult CurrencyList()
        {
            return View();
        }
        public IActionResult FetchCurrencies()
        {
            var currencies = _reportService.GetRepo_Currency(_loggedInUser.CompanyCd);
            return PartialView("_Currencies", currencies);
        }
        public IActionResult CurrencyListReport()
        {
            var currencies = _reportService.GetRepo_Currency(_loggedInUser.CompanyCd);
            return new ViewAsPdf(currencies)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region Department
        public IActionResult DepartmentList()
        {
            return View();
        }
        public IActionResult FetchDepartments()
        {
            var departments = _reportService.GetRepo_Department(_loggedInUser.CompanyCd);
            return PartialView("_Departments", departments);
        }
        public IActionResult DepartmentListReport()
        {
            var departments = _reportService.GetRepo_Department(_loggedInUser.CompanyCd);
            return new ViewAsPdf(departments)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion

        #region LoanType
        public IActionResult LoanTypeList()
        {
            return View();
        }
        public IActionResult FetchLoanTypes()
        {
            var loantypes = _reportService.GetRepo_LoanType(_loggedInUser.CompanyCd);
            return PartialView("_LoanTypes", loantypes);
        }
        public IActionResult LoanTypeListReport()
        {
            var loantypes = _reportService.GetRepo_LoanType(_loggedInUser.CompanyCd);
            return new ViewAsPdf(loantypes)
            {
                PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
            };
        }
        #endregion
    }
}