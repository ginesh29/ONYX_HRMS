using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class QueueController : Controller
    {
        private readonly AuthService _authService;
        private readonly QueueService _queueService;
        private readonly LoggedInUserModel _loggedInUser;
        public QueueController(AuthService authService, QueueService queueService)
        {
            _authService = authService;
            _queueService = queueService;
            _loggedInUser = _authService.GetLoggedInUser();
        }
        #region Counter
        public IActionResult Counters()
        {
            return View();
        }
        public IActionResult FetchCounters()
        {
            var counters = _queueService.GetCounters();
            CommonResponse result = new()
            {
                Data = counters,
            };
            return Json(result);
        }
        public IActionResult GetCounter(string cd)
        {
            var counter = _queueService.GetCounters(cd).FirstOrDefault();
            var model = new CounterModel();
            if (counter != null)
                model = new CounterModel
                {
                    Cd = counter.Cd,
                    Name = counter.Name,
                    Active = counter.Active,
                };
            else
                model.Cd = _queueService.GetCounter_SrNo();
            return PartialView("_CounterModal", model);
        }
        [HttpPost]
        public IActionResult SaveCounter(CounterModel model)
        {
            model.EntryBy = _loggedInUser.UserCd;
            var result = _queueService.SaveCounter(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteCounter(string cd)
        {
            _queueService.DeleteCounter(cd);
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
            var services = _queueService.GetServices();
            CommonResponse result = new()
            {
                Data = services,
            };
            return Json(result);
        }
        public IActionResult GetService(string cd)
        {
            var service = _queueService.GetServices(cd).FirstOrDefault();
            var model = new ServiceModel();
            if (service != null)
                model = new ServiceModel
                {
                    Cd = service.Cd,
                    Name = service.Name,
                    Active = service.Active,
                };
            else
                model.Cd = _queueService.GetService_SrNo();
            return PartialView("_ServiceModal", model);
        }
        [HttpPost]
        public IActionResult SaveService(ServiceModel model)
        {
            model.EntryBy = _loggedInUser.UserCd;
            var result = _queueService.SaveService(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteService(string cd)
        {
            _queueService.DeleteService(cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Token
        public IActionResult Tokens()
        {
            return View();
        }
        public IActionResult FetchTokens()
        {
            var tokens = _queueService.GetTokens();
            CommonResponse result = new()
            {
                Data = tokens,
            };
            return Json(result);
        }
        public IActionResult GetToken()
        {
            var services = _queueService.GetServices();
            ViewBag.Services = services.Select(m => new SelectListItem
            {
                Text = m.Name,
                Value = $"{m.Cd.Trim()}"
            });
            return PartialView("_TokenModal");
        }
        [HttpPost]
        public IActionResult SaveToken(TokenModel model)
        {
            var service = _queueService.GetServices(model.ServiceCd).FirstOrDefault();
            model.TokenNo = _queueService.GetToken_SrNo(service.Prefix, model.ServiceCd);
            model.EntryBy = _loggedInUser.UserCd;
            var result = _queueService.SaveToken(model);
            result.Data = model;
            return Json(result);
        }
        #endregion
    }
}
