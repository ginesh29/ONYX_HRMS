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
            var menuItems = _commonService.GetMenuWithPermissions(_loggedInUser.UserCd);
            if (_loggedInUser.Username != "Administrator")
            {
                var visibleMenuItems = menuItems.Where(m => m.Visible == "Y");
                var parentIds = visibleMenuItems.Select(m => m.Prnt).Distinct();
                var parentMenuItems = menuItems.Where(m => parentIds.Contains(m.MenuId));
                var parentIds2 = parentMenuItems.Select(m => m.Prnt).Distinct();
                var visibleMenuIds = visibleMenuItems.Select(m => m.MenuId).Distinct();
                menuItems = menuItems.Where(m => visibleMenuIds.Contains(m.MenuId) || parentIds.Contains(m.MenuId) || parentIds2.Contains(m.MenuId));
            }
            return View(menuItems);
        }
    }
}