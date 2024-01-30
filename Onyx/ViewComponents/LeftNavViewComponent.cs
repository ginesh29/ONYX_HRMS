//using Microsoft.AspNetCore.Mvc;

//namespace CustomerLoyalty.ViewComponents
//{
//    public class LeftNavViewComponent : ViewComponent
//    {
//        private readonly CommonService _commonService;
//        private readonly AuthService _authService;
//        private readonly LoggedInUserModel _loggedInUser;
//        public LeftNavViewComponent(AuthService authService, CommonService commonService)
//        {
//            _commonService = commonService;
//            _authService = authService;
//            _loggedInUser = _authService.GetLoggedInUser();
//        }
//        public IViewComponentResult Invoke()
//        {
//            var menuItems = _commonService.GetMenuItems(_loggedInUser.UserCd);
//            if (_loggedInUser.UserType != ((int)UserTypeEnum.AdminUser).ToString())
//                menuItems = menuItems.Where(m => m.Visible);
//            return View(menuItems);
//        }
//    }
//}
