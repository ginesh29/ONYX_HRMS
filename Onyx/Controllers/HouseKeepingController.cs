using Microsoft.AspNetCore.Mvc;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
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
            var currntMonth = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_MONTH").Val;
            var currntYear = _commonService.GetParameterByType(_loggedInUser.CompanyCd, "CUR_YEAR").Val;
            ViewBag.currentMonthYear = $"{currntMonth}/{currntYear}";
            return View();
        }
        public IActionResult SaveMonthEndProcess()
        {
            _commonService.MonthEndProcess(_loggedInUser.CompanyCd);
            var result = new CommonResponse
            {
                Success = true,
                Message = "Month End Done Succesfully"
            };
            return Json(result);
        }
    }
}
