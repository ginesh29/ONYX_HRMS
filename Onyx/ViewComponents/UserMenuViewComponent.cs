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
        private readonly EmployeeService _employeeService;
        private readonly CommonService _commonService;
        private readonly TransactionService _transactionService;
        private readonly LoggedInUserModel _loggedInUser;
        public UserMenuViewComponent(AuthService authService, EmployeeService employeeService, CommonService commonService, TransactionService transactionService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
            _employeeService = employeeService;
            _commonService = commonService;
            _transactionService = transactionService;
        }
        public IViewComponentResult Invoke()
        {
            var employee = _loggedInUser.UserType == (int)UserTypeEnum.Employee ? _employeeService.FindEmployee(_loggedInUser.UserCd, _loggedInUser.CompanyCd) : null;
            var month = Convert.ToInt32(_commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH")?.Val);
            var year = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR")?.Val;
            bool imageExist = employee != null && File.Exists(Path.Combine(Directory.GetCurrentDirectory(), $"wwwroot/uploads/emp-photo/{_loggedInUser.CompanyCd}", employee.Imagefile));
            var companies = _commonService.GetUserCompanies(_loggedInUser.UserLinkedTo).Select(m => new SelectListItem { Value = m.CoCd, Text = m.CoName });
            if (companies.Count() == 1)
                companies = companies.Select(m => { m.Selected = true; return m; });
            else
                companies = companies.Select(m => { m.Selected = m.Value.Trim() == _loggedInUser.CompanyCd; return m; });
            ViewBag.UserCompanyItems = companies;
            var leaveData = _transactionService.GetEmpLeaveApprovalData(_loggedInUser.CompanyCd, _loggedInUser.UserCd, _loggedInUser.UserOrEmployee);
            var loanData = _transactionService.GetEmpLoanApprovalData(_loggedInUser.UserCd, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd);
            var leaveSalaryData = _transactionService.GetEmpLeaveSalaryApprovalData(_loggedInUser.UserCd, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd);
            var fundData = _transactionService.GetEmpFundApprovalData(_loggedInUser.UserCd, _loggedInUser.UserOrEmployee, _loggedInUser.CompanyCd);
            var progressionData = _transactionService.GetEmpProgressionData(string.Empty, string.Empty, _loggedInUser.UserCd, _loggedInUser.UserOrEmployee);
            foreach (var item in progressionData)
            {
                item.EP_TypeCd = item.EP_TypeCd.Trim();
                item.Detail = _transactionService.GetEmpProgressionDetail(item.TransNo.Trim());
            }
            var docRenewalData = _transactionService.GetEmpDocIssueRcpt(string.Empty, string.Empty, 0, _loggedInUser.UserCd, _loggedInUser.UserOrEmployee, "1");
            var provisionAdjData = _transactionService.GetEmpProvisionAdjData(string.Empty, "6", _loggedInUser.UserCd, _loggedInUser.UserOrEmployee);
            ViewBag.LeaveApprovalData = leaveData;
            ViewBag.LoanApprovalData = loanData;
            ViewBag.LeaveSalaryApprovalData = leaveSalaryData;
            ViewBag.FundApprovalData = fundData;
            ViewBag.ProgressionData = progressionData;
            ViewBag.DocRenewalData = docRenewalData;
            ViewBag.ProvisionAdjData = provisionAdjData;            
            var userMenu = new UserMenuModel
            {
                EmployeeName = employee != null ? $"{employee.Fname} {employee.Lname}" : null,
                Username = _loggedInUser.Username,
                UserCd = _loggedInUser.UserCd,
                CurrentPeriod = month > 0 && !string.IsNullOrEmpty(year) ? $"{DateTimeFormatInfo.CurrentInfo.GetMonthName(month)} {year}" : null,
                CurrentLogged = _commonService.GetCuurentLoggedInDetails(_loggedInUser.CompanyCd),
                ProfilePic = employee != null && imageExist ? employee.Imagefile : null
            };
            return View(userMenu);
        }
    }
}