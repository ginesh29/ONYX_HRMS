using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Localization;
using Microsoft.Extensions.Caching.Memory;
using Newtonsoft.Json;
using Onyx.Models.ViewModels;
using System.Security.Claims;

namespace Onyx.Services
{
    public class AuthService(IHttpContextAccessor httpContextAccessor)
    {
        private readonly IHttpContextAccessor _httpContextAccessor = httpContextAccessor;
        public async Task SignInUserAsync(LoggedInUserModel model)
        {
            var claims = new List<Claim>()
            {
                new("Username", model.Username),
                new("UserAbbr", model.UserLinkedTo),
                new("UserType",model.UserType.ToString()),
                new("Browser", model.Browser),
                new("UserCd", model.UserCd),
                new("UserOrEmployee", model.UserOrEmployee),
                new("CompanyCd", model.CompanyCd),
                new("CoAbbr", model.CoAbbr),
                new("AmtDecs", model.AmtDecs.ToString()),
                new("LoginId", model.LoginId),
            };
            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var claimsPrincipal = new ClaimsPrincipal(claimsIdentity);
            var prop = new AuthenticationProperties
            {
                IsPersistent = true,
                ExpiresUtc = DateTime.Now.AddYears(100),
            };
            await _httpContextAccessor.HttpContext.SignInAsync(claimsPrincipal, prop);
        }
        public async Task SignOutAsync()
        {
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
                    user.UserLinkedTo = claims.FirstOrDefault(m => m.Type == "UserAbbr")?.Value;
                    user.Username = claims.FirstOrDefault(m => m.Type == "Username")?.Value;
                    user.UserType = Convert.ToInt32(claims.FirstOrDefault(m => m.Type == "UserType")?.Value);
                    user.CompanyCd = claims.FirstOrDefault(m => m.Type == "CompanyCd")?.Value;
                    user.CoAbbr = claims.FirstOrDefault(m => m.Type == "CoAbbr")?.Value;
                    user.Browser = claims.FirstOrDefault(m => m.Type == "Browser")?.Value;
                    user.ActivityId = claims.FirstOrDefault(m => m.Type == "ActivityId")?.Value;
                    user.AmtDecs = Convert.ToInt32(claims.FirstOrDefault(m => m.Type == "AmtDecs")?.Value);
                    user.LoginId = claims.FirstOrDefault(m => m.Type == "LoginId")?.Value;
                }
            }
            return user;
        }
        public TokenSettingModel GetTokenSetting()
        {
            _httpContextAccessor.HttpContext.Request.Cookies.TryGetValue("TokenSetting", out var tokenSettingJson);
            var tokenSetting = tokenSettingJson != null ? JsonConvert.DeserializeObject<TokenSettingModel>(tokenSettingJson) : new TokenSettingModel();
            return tokenSetting;
        }
        public async Task UpdateClaim(string key, string value)
        {
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
                    ExpiresUtc = DateTime.Now.AddYears(100)
                };
                await _httpContextAccessor.HttpContext.SignInAsync(user, prop);
            }
        }
    }
}