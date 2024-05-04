using Onyx.Models.ViewModels;
using Onyx.Services;
using System.Security.Claims;
using static System.Net.Mime.MediaTypeNames;

namespace Onyx.Middleware
{
    public class CookieExpirationMiddleware(RequestDelegate next, LogService logService)
    {
        private readonly RequestDelegate _next = next;
        private readonly LogService _logService = logService;

        public async Task Invoke(HttpContext context)
        {
            var userIdentity = context.User.Identity;
            if (!userIdentity.IsAuthenticated)
            {
                var claimsIdentity = userIdentity as ClaimsIdentity;
                if (claimsIdentity.Claims.Any())
                {
                    var ActivityId = claimsIdentity?.FindFirst("ActivityId")?.Value;
                    var Browser = claimsIdentity?.FindFirst("Browser")?.Value;
                    var CoAbbr = claimsIdentity?.FindFirst("CoAbbr")?.Value;
                    var UserCd = claimsIdentity?.FindFirst("UserCd")?.Value;
                    var CoCd = claimsIdentity?.FindFirst("CompanyCd")?.Value;
                    _logService.SetActivityLogHead(new ActivityLogModel
                    {
                        Browser = Browser,
                        CoAbbr = CoAbbr,
                        UserCd = UserCd,
                        ActivityId = ActivityId,
                        CoCd = CoCd,
                        ActivityType = "U",
                    });
                }
            }
            await _next(context);
        }
    }
}
