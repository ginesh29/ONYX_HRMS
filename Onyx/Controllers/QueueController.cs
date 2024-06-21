using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Newtonsoft.Json;
using Onyx.Models.ViewModels;
using Onyx.Services;
using Rotativa.AspNetCore;
using Rotativa.AspNetCore.Options;
using System.Diagnostics;

namespace Onyx.Controllers
{
    [Authorize]
    public class QueueController : Controller
    {
        private readonly AuthService _authService;
        private readonly QueueService _queueService;
        private readonly SettingService _settingService;
        private readonly LoggedInUserModel _loggedInUser;
        private readonly TokenSettingModel _tokenSetting;
        private readonly FileHelper _fileHelper;
        public QueueController(AuthService authService, QueueService queueService, SettingService settingService)
        {
            _authService = authService;
            _queueService = queueService;
            _loggedInUser = _authService.GetLoggedInUser();
            _tokenSetting = _authService.GetTokenSetting();
            _settingService = settingService;
            _fileHelper = new FileHelper();
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

        #region Ad
        public IActionResult Ad()
        {
            var files = _queueService.GetAdFiles(_loggedInUser.UserCd);
            return View(files);
        }
        [RequestSizeLimit(100 * 1024 * 1024)]
        public async Task<IActionResult> SaveAdFiles(List<IFormFile> DocFiles)
        {
            if (DocFiles?.Count > 0)
            {
                var totalFiles = _queueService.GetAdFiles(_loggedInUser.UserCd).Count();
                string uploadedFilePath = string.Empty;
                foreach (var item in DocFiles.Select((value, i) => new { i, value }))
                {
                    if (item != null)
                    {
                        var cd = _queueService.GetAdImage_SrNo();
                        var filePath = await _fileHelper.UploadFile(item.value, "carousel", _loggedInUser.CompanyCd);
                        uploadedFilePath = filePath;
                        _queueService.SaveAdFile(new AdModel
                        {
                            UserCd = _loggedInUser.UserLinkedTo,
                            EntryBy = _loggedInUser.UserCd,
                            ImageFile = uploadedFilePath,
                            Cd = cd,
                        });
                    }
                }
            }
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.UPDATED
            };
            return Json(result);
        }
        public IActionResult DeleteAdFile(string cd)
        {
            _queueService.DeleteAdFile(_loggedInUser.UserLinkedTo, cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        [HttpPost]
        public async Task<IActionResult> UpdateAdFile(int Cd, IFormFile file)
        {
            var uploadedFilePath = await _fileHelper.UploadFile(file, "carousel", _loggedInUser.CompanyCd);
            _queueService.SaveAdFile(new AdModel
            {
                EntryBy = _loggedInUser.UserCd,
                UserCd = _loggedInUser.UserLinkedTo,
                Cd = Cd,
                ImageFile = uploadedFilePath,
            });
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.UPDATED
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
                Value = m.Cd.Trim(),
                Text = m.Name.Trim()
            });
            ViewBag.CounterItems = _queueService.GetCounters().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.Name.Trim()
            });
            return PartialView("_TokenSettingModal", _tokenSetting);
        }
        [HttpPost]
        public IActionResult SaveTokenSetting(TokenSettingModel model)
        {
            var tokenSettingJson = JsonConvert.SerializeObject(model);
            Response.Cookies.Append("TokenSetting", tokenSettingJson, new CookieOptions { Expires = DateTime.Now.AddYears(100) });
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
        public async Task<IActionResult> GetTokenPreview(string tokenNo)
        {
            try
            {
                var tokens = _queueService.GetTokens();
                var token = tokens.FirstOrDefault(m => m.TokenNo == tokenNo);
                var customerAhead = tokens.Count(m => m.Status == "W");
                var company = _settingService.GetCompany(_loggedInUser.CompanyCd, _loggedInUser.CoAbbr);
                var model = new TokenPrintModel
                {
                    BasicDetail = token,
                    CompanyName = company.CoName,
                    CustomerAhead = customerAhead - 1,
                };
                var pdfViewAction = new ViewAsPdf("TokenPrint", model)
                {
                    PageMargins = { Left = 10, Bottom = 10, Right = 10, Top = 10 },
                    ContentDisposition = ContentDisposition.Inline,
                    FileName = $"{tokenNo}.pdf"
                };
                byte[] pdfBytes = await pdfViewAction.BuildFile(ControllerContext);
                var filePath = Path.Combine(Directory.GetCurrentDirectory(), $"wwwroot/uploads/", pdfViewAction.FileName);
                System.IO.File.WriteAllBytes(filePath, pdfBytes);
                var pdfToPrinterPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "tools", "PDFtoPrinter.exe");
                var printProcess = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = pdfToPrinterPath,
                        Arguments = filePath,
                        RedirectStandardOutput = true,
                        UseShellExecute = false,
                        CreateNoWindow = true,
                    }
                };
                printProcess.Start();
                printProcess.WaitForExit();
                System.IO.File.Delete(filePath);
                return PartialView("_TokenPreview", model);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error occurred while printing: {ex.Message}");
            }
        }

        public IActionResult TokenCall()
        {
            return View();
        }
        public IActionResult TokenCallPartial()
        {
            var tokens = _queueService.GetTokens().Where(m => m.ServiceName == _tokenSetting.ServiceName);
            var waitingTokens = tokens.Where(m => m.Status == "W");
            ViewBag.WaitingTokens = waitingTokens;
            var calledTokens = tokens.Where(m => m.Status == "S" || m.Status == "N").OrderByDescending(m => m.EditDt);
            ViewBag.CalledTokens = calledTokens;
            var currentToken = tokens.FirstOrDefault(m => m.Status == "C")?.TokenNo;
            ViewBag.CurrentToken = currentToken;
            var nextToken = waitingTokens.FirstOrDefault()?.TokenNo;
            ViewBag.NextToken = nextToken;
            ViewBag.TokenCookie = _tokenSetting;
            return PartialView("_TokenCallPartial");
        }
        [HttpPost]
        public IActionResult CallNextToken(string tokenNo)
        {
            var model = new TokenModel
            {
                TokenNo = tokenNo,
                Status = "C",
                CalledDt = DateTime.Now,
                CounterCd = _tokenSetting.CounterCd,
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
                CounterCd = _tokenSetting.CounterCd,
                CalledDt = currentToken.CalledDt,
                ServedDt = status == "S" ? DateTime.Now : null,
                ServedBy = status == "S" ? _loggedInUser?.UserCd : null,
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
            var waitingTokens = tokens.Where(m => m.Status == "W").Take(5);
            ViewBag.WaitingTokens = waitingTokens;
            var servingTokens = tokens.Where(m => m.Status == "C");
            ViewBag.ServingTokens = servingTokens;
            ViewBag.AdFiles = _queueService.GetAdFiles(_loggedInUser.UserLinkedTo);
            return View();
        }
        public IActionResult DisplayPartial()
        {
            var tokens = _queueService.GetTokens();
            var servingTokens = tokens.Where(m => m.Status == "C");
            ViewBag.ServingTokens = servingTokens;
            var calledTokens = tokens.Where(m => m.Status == "S" || m.Status == "N").OrderByDescending(m => m.EditDt);
            ViewBag.CalledTokens = calledTokens;
            ViewBag.TokenCookie = _tokenSetting;
            return PartialView("_DisplayPartial");
        }
        #endregion
    }
}
