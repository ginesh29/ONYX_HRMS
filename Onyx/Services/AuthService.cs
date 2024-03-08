using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Onyx.Models.ViewModels;
using System.Security.Claims;

namespace Onyx.Services
{
    public class AuthService(IHttpContextAccessor httpContextAccessor)
    {
        private readonly IHttpContextAccessor _httpContextAccessor = httpContextAccessor;
        public async Task SignInUserAsync(LoggedInUserModel model, bool rememberMe)
        {
            var claims = new List<Claim>()
            {
                new("Username", model.Username),
                new("UserAbbr", model.UserAbbr),
                new("LoginId", model.LoginId),
                new("UserType",model.UserType.ToString()),
                new("Browser", model.Browser),
                new("UserCd", model.UserCd),
                new("UserOrEmployee", model.UserOrEmployee)
            };
            if (!string.IsNullOrEmpty(model.CompanyCd))
            {
                claims.Add(new("CompanyCd", model.CompanyCd));
            }
            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var claimsPrincipal = new ClaimsPrincipal(claimsIdentity);
            var prop = new AuthenticationProperties();
            if (rememberMe)
            {
                prop.IsPersistent = rememberMe;
                prop.ExpiresUtc = DateTime.UtcNow.AddDays(1);
            }
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
                    user.UserAbbr = claims.FirstOrDefault(m => m.Type == "UserAbbr")?.Value;
                    user.Username = claims.FirstOrDefault(m => m.Type == "Username")?.Value;
                    user.LoginId = claims.FirstOrDefault(m => m.Type == "LoginId")?.Value;
                    user.UserType = Convert.ToInt32(claims.FirstOrDefault(m => m.Type == "UserType")?.Value);
                    user.CompanyCd = claims.FirstOrDefault(m => m.Type == "CompanyCd")?.Value;
                    user.Browser = claims.FirstOrDefault(m => m.Type == "Browser")?.Value;
                }
            }
            return user;
        }
        public async Task UpdateClaim(string key, string value)
        {
            ClaimsPrincipal user = _httpContextAccessor.HttpContext.User;
            ClaimsIdentity identity = (ClaimsIdentity)user.Identity;
            Claim oldClaim = identity.FindFirst(key);
            identity.RemoveClaim(oldClaim);
            Claim newClaim = new(key, value);
            identity.AddClaim(newClaim);
            await _httpContextAccessor.HttpContext.SignInAsync(user);
        }
    }
}