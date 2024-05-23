using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class HouseKeepingController : Controller
    {
        private readonly CommonService _commonService;
        private readonly AuthService _authService;
        private readonly LoggedInUserModel _loggedInUser;
        public HouseKeepingController(CommonService commonService, AuthService authService)
        {
            _commonService = commonService;
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
        }
        public IActionResult MonthEndProcess()
        {
            var currentMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currentYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currentMonth}/{currentYear}";
            return View();
        }
        public IActionResult SaveMonthEndProcess(string MonthYear)
        {
            var spMonthYear = MonthYear.Split('/');
            var Period = Convert.ToInt32(spMonthYear[0]);
            var Year = Convert.ToInt32(spMonthYear[1]);
            int lastDayOfMonth = DateTime.DaysInMonth(Year, Period);
            var date = new DateTime(Year, Period, lastDayOfMonth);
            if (date <= DateTime.Now)
            {
                _commonService.MonthEndProcess(_loggedInUser.CompanyCd);
                TempData["success"] = "Month End completed Succesfully";
            }
            else
                TempData["error"] = "You Can't Month End before month complete";
            return RedirectToAction("MonthEndProcess");
        }
    }
}
