using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.Extensions.Caching.Memory;
using Onyx.Models.ViewModels;
using System.Security.Claims;

namespace Onyx.Services
{
    public class AuthService(IHttpContextAccessor httpContextAccessor, IMemoryCache memoryCache)
    {
        private readonly IHttpContextAccessor _httpContextAccessor = httpContextAccessor;
        private readonly IMemoryCache _memoryCache = memoryCache;
        public async Task SignInUserAsync(LoggedInUserModel model)
        {
            var claims = new List<Claim>()
            {
                new("Username", model.Username),
                new("UserAbbr", model.UserAbbr),
                new("UserType",model.UserType.ToString()),
                new("Browser", model.Browser),
                new("UserCd", model.UserCd),
                new("UserOrEmployee", model.UserOrEmployee),
                new("CompanyCd", model.CompanyCd),
                new("CoAbbr", model.CoAbbr),
            };
            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var claimsPrincipal = new ClaimsPrincipal(claimsIdentity);
            var prop = new AuthenticationProperties
            {
                IsPersistent = true,
                ExpiresUtc = DateTime.Now.AddDays(1)
            };
            _memoryCache.Set("CompanyCd", model.CompanyCd, DateTime.Now.AddDays(2));
            _memoryCache.Set("CoAbbr", model.CoAbbr, DateTime.Now.AddDays(2));
            await _httpContextAccessor.HttpContext.SignInAsync(claimsPrincipal, prop);
        }
        public async Task SignOutAsync()
        {
            _memoryCache.Remove("CompanyCd");
            _memoryCache.Remove("ActivityId");
            await _httpContextAccessor.HttpContext.SignOutAsync();
        }
        public LoggedInUserModel GetLoggedInUser()
        {
            var user = new LoggedInUserModel();
            var auth = _httpContextAccessor.HttpContext.AuthenticateAsync(CookieAuthenticationDefaults.AuthenticationScheme).Result;
            string result = string.Empty;
            if (auth.Succeeded)
            {
                var claims = auth.Principal.Claims;
                if (claims.Any())
                {
                    user.UserOrEmployee = claims.FirstOrDefault(m => m.Type == "UserOrEmployee")?.Value;
                    user.UserCd = claims.FirstOrDefault(m => m.Type == "UserCd")?.Value;
                    user.UserAbbr = claims.FirstOrDefault(m => m.Type == "UserAbbr")?.Value;
                    user.Username = claims.FirstOrDefault(m => m.Type == "Username")?.Value;
                    user.UserType = Convert.ToInt32(claims.FirstOrDefault(m => m.Type == "UserType")?.Value);
                    user.CompanyCd = claims.FirstOrDefault(m => m.Type == "CompanyCd")?.Value;
                    user.CoAbbr = claims.FirstOrDefault(m => m.Type == "CoAbbr")?.Value;
                    user.Browser = claims.FirstOrDefault(m => m.Type == "Browser")?.Value;
                    user.ActivityId = claims.FirstOrDefault(m => m.Type == "ActivityId")?.Value;
                }
            }
            return user;
        }
        public async Task UpdateClaim(string key, string value)
        {
            _memoryCache.Set(key, value, DateTime.Now.AddDays(2));
            ClaimsPrincipal user = _httpContextAccessor.HttpContext.User;
            ClaimsIdentity identity = (ClaimsIdentity)user.Identity;
            Claim oldClaim = identity.FindFirst(key);
            if (oldClaim != null)
                identity.RemoveClaim(oldClaim);
            if (identity.Claims.Any())
            {
                Claim newClaim = new(key, value);
                identity.AddClaim(newClaim);
                var prop = new AuthenticationProperties
                {
                    IsPersistent = true,
                    ExpiresUtc = DateTime.Now.AddDays(1)
                };
                await _httpContextAccessor.HttpContext.SignInAsync(user, prop);
            }
        }
    }
}