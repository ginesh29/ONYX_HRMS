using Microsoft.AspNetCore.Mvc;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.ViewComponents
{
    public class LeftNavViewComponent : ViewComponent
    {
        private readonly AuthService _authService;
        private readonly CommonService _commonService;
        private readonly LoggedInUserModel _loggedInUser;
        public LeftNavViewComponent(AuthService authService, CommonService commonService)
        {
            _authService = authService;
            _commonService = commonService;
            _loggedInUser = _authService.GetLoggedInUser();
        }
        public IViewComponentResult Invoke()
        {
            var menuItems = _commonService.GetMenuItems(_loggedInUser.CompanyAbbr, _loggedInUser.UserCd);
            return View(menuItems);
        }
    }
}