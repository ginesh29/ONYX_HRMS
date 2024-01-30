using Dapper;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Onyx.Data;
using Onyx.Models;
using Onyx.Models.Stored_Procedure;
using System.Data;
using System.Data.SqlClient;
using System.Security.Claims;

namespace Onyx.Services
{
    public class AuthService(AppDbContext context, IHttpContextAccessor httpContextAccessor)
    {
        private readonly AppDbContext _context = context;
        private readonly IHttpContextAccessor _httpContextAccessor = httpContextAccessor;
        public CompanyDatabases_Getrow_Result GetCompanyDetail(string CoAbbr)
        {
            var procedureName = "CompanyDatabases_Getrow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoAbbr", CoAbbr);
            using var connection = _context.CreateConnection();
            var company = connection.QueryFirstOrDefault<CompanyDatabases_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return company;
        }
        public string GetCompanyConnectionString(string CoAbbr)
        {
            var company = GetCompanyDetail(CoAbbr);
            return $"Server={company.Server};Initial catalog={company.DbName};uid={company.DbUser}; pwd={company.DbPwd};TrustServerCertificate=True;Connection Timeout=120;";
        }
        public Validate_User_Result ValidateLogin(LoginModel model)
        {
            var connectionString = GetCompanyConnectionString(model.CoAbbr);
            var procedureName = "Validate_User";
            var parameters = new DynamicParameters();
            parameters.Add("v_UserID", model.UserId);
            parameters.Add("v_PWD", model.Password.Encrypt());
            var connection = new SqlConnection(connectionString);
            var user = connection.QueryFirstOrDefault<Validate_User_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }
        public async Task SignInUserAsync(LoggedInUserModel model, bool rememberMe)
        {
            var claims = new List<Claim>()
            {
                new("loginCompanyGroup", model.CompanyGroup),
                new("loginUserName", model.Username),
                new("loginUserCd",model.UserCd),
                new("loginUser", model.User),
                new("loginUserAbbr", model.UserAbbr),
                new("CompanyGroupAbbr", model.CompanyGroupAbbr),
                new("CompanyAbbr", model.CompanyAbbr),
            };
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
        //public LoggedInUserModel GetLoggedInUser()
        //{
        //    var user = new LoggedInUserModel();
        //    var claims = _httpContextAccessor.HttpContext.User.Claims;
        //    if (claims.Any())
        //    {
        //        user.UserCd = Convert.ToInt32(claims.FirstOrDefault(m => m.Type == "loginUserCd")?.Value);
        //        user.Username = claims.FirstOrDefault(m => m.Type == "loginUsername")?.Value;
        //        user.CompanyId = claims.FirstOrDefault(m => m.Type == "loginCompanyId")?.Value;
        //        user.CompanyName = claims.FirstOrDefault(m => m.Type == "loginCompany")?.Value;
        //        user.UserType = claims.FirstOrDefault(m => m.Type == "loginUserType")?.Value;
        //    }
        //    return user;
        //}
        //public string ChangePassword(ChangePassword model)
        //{
        //    var procedureName = "Ly_Users_Update1";
        //    var parameters = new DynamicParameters();
        //    parameters.Add("v_UName", model.Username, DbType.String);
        //    parameters.Add("v_UPWD", model.Password, DbType.String);
        //    parameters.Add("v_UPWD1", model.NewPassword, DbType.String);
        //    using var connection = _context.CreateConnection();
        //    var msg = connection.QueryFirstOrDefault<string>
        //        (procedureName, parameters, commandType: CommandType.StoredProcedure);
        //    return msg;
        //}
    }
}