using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class TokenController : Controller
    {
        private readonly AuthService _authService;
        private readonly TokenService _tokenService;
        private readonly LoggedInUserModel _loggedInUser;
        public TokenController(AuthService authService, TokenService tokenService)
        {
            _authService = authService;
            _tokenService = tokenService;
            _loggedInUser = _authService.GetLoggedInUser();
        }
        #region Counter
        public IActionResult Counters()
        {
            return View();
        }
        public IActionResult FetchCounters()
        {
            var counters = _tokenService.GetCounters();
            CommonResponse result = new()
            {
                Data = counters,
            };
            return Json(result);
        }
        public IActionResult GetCounter(string cd)
        {
            var counter = _tokenService.GetCounters(cd).FirstOrDefault();
            var model = new CounterModel();
            if (counter != null)
                model = new CounterModel
                {
                    Cd = counter.Cd,
                    Name = counter.Name,
                    Active = counter.Active,
                };
            else
                model.Cd = _tokenService.GetToken_SrNo();
            return PartialView("_CounterModal", model);
        }
        [HttpPost]
        public IActionResult SaveCounter(CounterModel model)
        {
            model.EntryBy = _loggedInUser.UserCd;
            var result = _tokenService.SaveCounter(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteCounter(string cd)
        {
            _tokenService.DeleteCounter(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Service
        public IActionResult Services()
        {
            return View();
        }
        public IActionResult FetchServices()
        {
            var services = _tokenService.GetServices();
            CommonResponse result = new()
            {
                Data = services,
            };
            return Json(result);
        }
        public IActionResult GetService(string cd)
        {
            var service = _tokenService.GetServices(cd).FirstOrDefault();
            var model = new ServiceModel();
            if (service != null)
                model = new ServiceModel
                {
                    Cd = service.Cd,
                    Name = service.Name,
                    Active = service.Active,
                };
            else
                model.Cd = _tokenService.GetService_SrNo();
            return PartialView("_ServiceModal", model);
        }
        [HttpPost]
        public IActionResult SaveService(ServiceModel model)
        {
            model.EntryBy = _loggedInUser.UserCd;
            var result = _tokenService.SaveService(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteService(string cd)
        {
            _tokenService.DeleteService(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion
    }
}
