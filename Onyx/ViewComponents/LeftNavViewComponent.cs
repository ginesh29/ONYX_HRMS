using Microsoft.AspNetCore.Mvc;
using Onyx.Models;
using Onyx.Services;

namespace CustomerLoyalty.ViewComponents
{
    public class LeftNavViewComponent : ViewComponent
    {
        private readonly AuthService _authService;
        private readonly LoggedInUserModel _loggedInUser;
        public LeftNavViewComponent(AuthService authService)
        {
            _authService = authService;
            _loggedInUser = _authService.GetLoggedInUser();
        }
        public IViewComponentResult Invoke()
        {
            var menuItems = _authService.GetMenuItems(_loggedInUser.CompanyAbbr, _loggedInUser.UserCd);
            return View(menuItems);
        }
    }
}
