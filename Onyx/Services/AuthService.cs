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
                new("loginUsername", model.Username),
                new("loginUserCd",model.UserCd),
                new("loginUserType",model.UserType.ToString()),
                new("loginCompanyCd", model.CompanyCd),
                new("loginCompanyAbbr", model.CompanyAbbr)
            };
            if (model.EmployeeCd != null)
                claims.Add(new("loginEmployeeCd", model.EmployeeCd));
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
            var claims = _httpContextAccessor.HttpContext.User.Claims;
            if (claims.Any())
            {
                user.UserCd = claims.FirstOrDefault(m => m.Type == "loginUserCd")?.Value;
                user.Username = claims.FirstOrDefault(m => m.Type == "loginUsername")?.Value;
                user.UserType = Convert.ToInt32(claims.FirstOrDefault(m => m.Type == "loginUserType")?.Value);
                user.CompanyCd = claims.FirstOrDefault(m => m.Type == "loginCompanyCd")?.Value;
                user.CompanyAbbr = claims.FirstOrDefault(m => m.Type == "loginCompanyAbbr")?.Value;
                user.EmployeeCd = claims.FirstOrDefault(m => m.Type == "loginEmployeeCd")?.Value;
            }
            return user;
        }
    }
}