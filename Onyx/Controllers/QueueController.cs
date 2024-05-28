using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Caching.Memory;
using Newtonsoft.Json;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Controllers
{
    [Authorize]
    public class QueueController : Controller
    {
        private readonly AuthService _authService;
        private readonly QueueService _queueService;
        private readonly SettingService _settingService;
        private readonly LoggedInUserModel _loggedInUser;
        public QueueController(AuthService authService, QueueService queueService, SettingService settingService)
        {
            _authService = authService;
            _queueService = queueService;
            _loggedInUser = _authService.GetLoggedInUser();
            _settingService = settingService;
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
                    Prefix = service.Prefix,
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
            var services = _queueService.GetServices();
            ViewBag.Services = services;
            return View();
        }
        public IActionResult TokenSetting()
        {
            ViewBag.ServiceItems = _queueService.GetServices().Select(m => new SelectListItem
            {
                Value = m.Name.Trim(),
                Text = m.Name.Trim()
            });
            ViewBag.CounterItems = _queueService.GetCounters().Select(m => new SelectListItem
            {
                Value = m.Name.Trim(),
                Text = m.Name.Trim()
            });
            var tokenCookie = Request.Cookies.TryGetValue("TokenSetting", out var tokenSettingJson);
            var tokenSetting = tokenSettingJson != null ? JsonConvert.DeserializeObject<TokenSettingModel>(tokenSettingJson) : new TokenSettingModel();
            return PartialView("_TokenSettingModal", tokenSetting);
        }
        [HttpPost]
        public IActionResult SaveTokenSetting(TokenSettingModel model)
        {
            var tokenSettingJson = JsonConvert.SerializeObject(model);
            Response.Cookies.Append("TokenSetting", tokenSettingJson, new CookieOptions { Expires = DateTime.Now.AddYears(1) });
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.UPDATED,
                Data = model
            };
            return Json(result);
        }
        [HttpPost]
        public IActionResult GenerateToken(TokenModel model)
        {
            var service = _queueService.GetServices(model.ServiceCd).FirstOrDefault();
            model.Status = "W";
            model.TokenNo = _queueService.GetToken_SrNo(service.Prefix, model.ServiceCd);
            model.EntryBy = _loggedInUser.UserCd;
            var result = _queueService.SaveToken(model);
            result.Data = new { model.TokenNo };
            result.Message = $"{service.Name} token generated successfully";
            return Json(result);
        }
        public IActionResult GetTokenPreview(string tokenNo)
        {
            var tokens = _queueService.GetTokens();
            var token = tokens.FirstOrDefault(m => m.TokenNo == tokenNo);
            var customerAhead = tokens.Count(m => m.Status == "W");
            ViewBag.CustomerAhead = customerAhead - 1;
            var company = _settingService.GetCompany(_loggedInUser.CompanyCd, _loggedInUser.CoAbbr);
            ViewBag.CompanyName = company.CoName;
            return PartialView("_TokenPreview", token);
        }
        public IActionResult TokenCall()
        {
            var tokens = _queueService.GetTokens();
            var waitingTokens = tokens.Where(m => m.Status == "W");
            ViewBag.WaitingTokens = waitingTokens;
            var calledTokens = tokens.Where(m => m.Status == "S" || m.Status == "N").OrderByDescending(m => m.EditDt);
            ViewBag.CalledTokens = calledTokens;
            var currentToken = tokens.FirstOrDefault(m => m.Status == "C")?.TokenNo;
            ViewBag.CurrentToken = currentToken;
            var nextToken = waitingTokens.FirstOrDefault()?.TokenNo;
            ViewBag.NextToken = nextToken;
            var tokenCookie = Request.Cookies.TryGetValue("TokenSetting", out var tokenSettingJson);
            var tokenSetting = tokenSettingJson != null ? JsonConvert.DeserializeObject<TokenSettingModel>(tokenSettingJson) : new TokenSettingModel();
            ViewBag.TokenCookie = tokenSetting;
            return View();
        }
        [HttpPost]
        public IActionResult CallNextToken(string tokenNo)
        {
            var model = new TokenModel
            {
                TokenNo = tokenNo,
                Status = "C",
                EntryBy = _loggedInUser.UserCd,
            };
            var result = _queueService.SaveToken(model);
            result.Message = !string.IsNullOrEmpty(tokenNo) ? $"{tokenNo} Called Scuccessfully" : "No Ticket Available";
            result.Success = !string.IsNullOrEmpty(tokenNo) && result.Success;
            return Json(result);
        }
        [HttpPost]
        public IActionResult ServeToken(string status)
        {
            var currentToken = _queueService.GetTokens().FirstOrDefault(m => m.Status == "C");
            var model = new TokenModel
            {
                TokenNo = currentToken?.TokenNo,
                Status = status,
                EntryBy = _loggedInUser?.UserCd,
            };
            var result = _queueService.SaveToken(model);
            var action = status == "S" ? "served" : "skipped";
            result.Message = $"{currentToken.TokenNo} {action} Scuccessfully";
            return Json(result);
        }
        [HttpPost]
        public IActionResult SaveTokenCall(TokenModel model)
        {
            model.EntryBy = _loggedInUser.UserCd;
            var result = _queueService.SaveToken(model);
            result.Data = new { model.TokenNo };
            return Json(result);
        }
        public IActionResult Display()
        {
            var tokens = _queueService.GetTokens();
            var waitingTokens = tokens.Where(m => m.Status == "W");
            ViewBag.WaitingTokens = waitingTokens;
            var calledTokens = tokens.Where(m => m.Status == "S" || m.Status == "N").OrderByDescending(m => m.EditDt);
            ViewBag.CalledTokens = calledTokens;
            var currentToken = tokens.FirstOrDefault(m => m.Status == "C")?.TokenNo;
            ViewBag.CurrentToken = currentToken;
            var tokenCookie = Request.Cookies.TryGetValue("TokenSetting", out var tokenSettingJson);
            var tokenSetting = tokenSettingJson != null ? JsonConvert.DeserializeObject<TokenSettingModel>(tokenSettingJson) : new TokenSettingModel();
            ViewBag.TokenCookie = tokenSetting;
            return View();
        }
        #endregion
    }
}
