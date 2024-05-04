using Microsoft.Extensions.Caching.Memory;
using Onyx.Models.ViewModels;
using Onyx.Services;

namespace Onyx.Middleware
{
    public class CookieExpirationMiddleware(RequestDelegate next, LogService logService, AuthService authService, IMemoryCache memoryCache)
    {
        private readonly RequestDelegate _next = next;
        private readonly LogService _logService = logService;
        private readonly AuthService _authService = authService;
        private readonly IMemoryCache _memoryCache = memoryCache;
        public async Task Invoke(HttpContext context)
        {
            var userIdentity = context.User.Identity;
            if (!userIdentity.IsAuthenticated)
            {
                var CoCd = _memoryCache.Get<string>("CompanyCd");
                var CoAbbr = _memoryCache.Get<string>("CoAbbr");
                var ActivityId = _memoryCache.Get<string>("ActivityId");
                if (!string.IsNullOrEmpty(CoCd) && !string.IsNullOrEmpty(ActivityId))
                {
                    _logService.SetActivityLogHead(new ActivityLogModel
                    {
                        CoCd = CoCd,
                        CoAbbr = CoAbbr,
                        ActivityId = ActivityId,
                        ActivityType = "U",
                    });
                }
            }
            await _next(context);
        }
    }
}
