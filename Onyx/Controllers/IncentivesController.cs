using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using Onyx.Services;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Onyx.Controllers
{
    [Authorize]
    public class IncentivesController : Controller
    {
        private readonly AuthService _authService;
        private readonly OrganisationService _organisationService;
        private readonly TransactionService _transactionService;
        private readonly EmployeeService _employeeService;
        private readonly CommonService _commonService;
        private readonly LoggedInUserModel _loggedInUser;
        public IncentivesController(AuthService authService, OrganisationService organisationService, CommonService commonService, TransactionService transactionService, EmployeeService employeeService)
        {
            _authService = authService;
            _commonService = commonService;
            _loggedInUser = _authService.GetLoggedInUser();
            _organisationService = organisationService;
            _transactionService = transactionService;
            _employeeService = employeeService;
        }
        public IActionResult EmpIncentives()
        {
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
            ViewBag.EmpTypeItems = _commonService.GetCodesGroups(CodeGroup.EmpType).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
            return View();
        }

        public IActionResult FetchEmpIncentives(IncentiveFilterModel model)
        {
            var spYearMonth = model.MonthYear.Split("/");
            model.Prd = spYearMonth[0];
            model.Year = spYearMonth[1];
            int lastDayOfMonth = DateTime.DaysInMonth(Convert.ToInt32(model.Year), Convert.ToInt32(model.Prd));
            model.FromDt = new DateTime(Convert.ToInt32(model.Year), Convert.ToInt32(model.Prd), 1);
            model.ToDt = new DateTime(Convert.ToInt32(model.Year), Convert.ToInt32(model.Prd), lastDayOfMonth);
            var incentiveData = _transactionService.GetEmpIncentiveData(model);
            var attendanceModel = new IncentiveModel
            {
                IncentiveData = incentiveData.ToList(),
                FilterModel = model
            };
            return PartialView("_EmpIncentiveData", attendanceModel);
        }

        [HttpPost]
        public IActionResult SaveEmpIncentive(IncentiveModel model)
        {
            model.IncentiveData = model.IncentiveData.Where(m => m.Active).ToList();
            int lastDayOfMonth = DateTime.DaysInMonth(Convert.ToInt32(model.FilterModel.Year), Convert.ToInt32(model.FilterModel.Prd));
            model.FilterModel.FromDt = new DateTime(Convert.ToInt32(model.FilterModel.Year), Convert.ToInt32(model.FilterModel.Prd), 1);
            model.FilterModel.ToDt = new DateTime(Convert.ToInt32(model.FilterModel.Year), Convert.ToInt32(model.FilterModel.Prd), lastDayOfMonth);

            var filterModel = new VariablePayDedComponentFilterModel
            {
                Branch = model.FilterModel.Branch ?? "0",
                Department = model.FilterModel.Designation ?? "0",
                EmpCd = model.FilterModel.EmpCd ?? string.Empty,
                FromDt = model.FilterModel.FromDt,
                ToDt = model.FilterModel.ToDt,
                PayType = "HEDT01",
                EntryBy = _loggedInUser.UserAbbr
            };
            foreach (var item in model.IncentiveData)
            {
                var employeeDetail = _employeeService.FindEmployee(item.Cd, _loggedInUser.CompanyCd);
                var data = new EmpTrans_VarCompFixAmt_GetRow_Result()
                {
                    Cd = item.Cd,
                    Curr = employeeDetail.BasicCurr.Trim(),
                    SrNo = item.SrNo,
                };
                for (int i = 0; i < 2; i++)
                {
                    if (i == 1)
                    {
                        filterModel.PayCode = "207";
                        data.Amt = item.Amt;
                    }
                    else
                    {
                        filterModel.PayCode = "MGRIN";
                        data.Amt = item.Amt1;
                    }
                    _transactionService.EmpTrans_Update(data, filterModel);
                }
                data.Amt = item.SalesAmt;
                _transactionService.UpdateEmpSalesData(data, filterModel);
            }
            var result = new CommonResponse
            {
                Success = true,
                Message = $"{model.IncentiveData.Count} record(s) {CommonMessage.UPDATED}"
            };
            return Json(result);
        }
        public IActionResult ImportIncentive(IFormFile file, IncentiveFilterModel filterModel)
        {
            try
            {
                filterModel.EntryBy = _loggedInUser.UserAbbr;
                var excelData = _transactionService.GetIncentiveFromExcel(file, _loggedInUser.CompanyCd);
                var validData = excelData.Where(m => m.IsValid);
                var invalidData = excelData.Where(m => !m.IsValid);
                string Message = !invalidData.Any() && !validData.Any() ? "No record found to import"
                    : invalidData.Any() ? $"{invalidData.Count()} record failed to import" : $"{validData.Count()} records imported succussfully";
                bool validHeader = _transactionService.ValidHeaderIncentiveExcel(file);
                if (!validHeader)
                {
                    excelData = null;
                    Message = "Headers are not matched. Download again & refill data";
                }
                if (validData.Any())
                    _transactionService.ImportIncentiveExcelData(validData, filterModel);
                return PartialView("_IncentiveExcelData", new { Data = excelData, Message });
            }
            catch (Exception ex)
            {
                return Json("File not supported. Download again & refill data");
            }
        }
    }
}
