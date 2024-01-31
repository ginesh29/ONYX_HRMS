using Dapper;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Onyx.Data;
using Onyx.Models;
using Onyx.Models.Stored_Procedure;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;
using System.Security.Claims;

namespace Onyx.Services
{
    public class AuthService(AppDbContext context, IHttpContextAccessor httpContextAccessor)
    {
        private readonly AppDbContext _context = context;
        private readonly IHttpContextAccessor _httpContextAccessor = httpContextAccessor;
        public IEnumerable<Company_Getrow_Result> GetCompanies()
        {
            var procedureName = "Company_Getrow";
            using var connection = _context.CreateConnection();
            var companies = connection.Query<Company_Getrow_Result>
                (procedureName, commandType: CommandType.StoredProcedure);
            return companies;
        }
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
        public Validate_User_Result ValidateUser(LoginModel model)
        {
            var connectionString = GetCompanyConnectionString(model.CoAbbr);
            var procedureName = "Validate_User";
            var parameters = new DynamicParameters();
            parameters.Add("v_UserID", model.Username);
            parameters.Add("v_PWD", model.Password.Encrypt());
            var connection = new SqlConnection(connectionString);
            var user = connection.QueryFirstOrDefault<Validate_User_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }
        public Validate_Employee_Result ValidateEmployee(LoginModel model)
        {
            var connectionString = GetCompanyConnectionString(model.CoAbbr);
            var procedureName = "Validate_Employee";
            var parameters = new DynamicParameters();
            parameters.Add("v_EMPID", model.Username);
            parameters.Add("v_PWD", model.Password.Encrypt());
            var connection = new SqlConnection(connectionString);
            var employee = connection.QueryFirstOrDefault<Validate_Employee_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return employee;
        }
        public Users_GetRow_Result GetUser(string UserCd,string CoAbbr)
        {
            var connectionString = GetCompanyConnectionString(CoAbbr);
            var procedureName = "Users_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", UserCd);
            var connection = new SqlConnection(connectionString);
            var user = connection.QueryFirstOrDefault<Users_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }
        //public Validate_User_Result GetEmployee(LoginModel model)
        //{
        //    //cmd.Parameters.AddWithValue("@v_Param", objBll.Param);
        //    //cmd.Parameters.AddWithValue("@v_Typ", objBll.Typ);
        //    //cmd.Parameters.AddWithValue("@v_CoCd", objBll.CoCd);
        //    var connectionString = GetCompanyConnectionString(model.CoAbbr);
        //    var procedureName = "Employee_Find";
        //    var parameters = new DynamicParameters();
        //    parameters.Add("v_UserID", model.Username);
        //    parameters.Add("v_PWD", model.Password.Encrypt());
        //    var connection = new SqlConnection(connectionString);
        //    var user = connection.QueryFirstOrDefault<Validate_User_Result>
        //        (procedureName, parameters, commandType: CommandType.StoredProcedure);
        //    return user;
        //}
        public async Task SignInUserAsync(LoggedInUserModel model, bool rememberMe)
        {
            var claims = new List<Claim>()
            {
                new("loginUserName", model.Username),
                new("loginUserCd",model.UserCd),
                new("loginUserType",model.UserType.ToString()),
                new("loginCompanyCd", model.CompanyCd),
                new("loginCompanyAbbr", model.CompanyAbbr),
            };
            if (model.UserType == (int)UserTypeEnum.Employee)
            {
                claims.Add(new("loginEmployeeName", model.Username));
                claims.Add(new("loginEmployeeCd", model.UserCd));
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
            var claims = _httpContextAccessor.HttpContext.User.Claims;
            if (claims.Any())
            {
                user.UserCd = claims.FirstOrDefault(m => m.Type == "loginUserCd")?.Value;
                user.Username = claims.FirstOrDefault(m => m.Type == "loginUsername")?.Value;
                user.UserType = Convert.ToInt32(claims.FirstOrDefault(m => m.Type == "loginUserType")?.Value);
                user.CompanyCd = claims.FirstOrDefault(m => m.Type == "loginCompanyCd")?.Value;
                user.CompanyAbbr = claims.FirstOrDefault(m => m.Type == "loginCompanyAbbr")?.Value;
            }
            return user;
        }
        public IEnumerable<UserGroupMenu_GetRow_Result> GetMenuItems(string CoAbbr, string UserCd)
        {
            var connectionString = GetCompanyConnectionString(CoAbbr);
            var procedureName = "UserGroupMenu_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Abbr", UserCd);
            var connection = new SqlConnection(connectionString);
            var multipleResult = connection.QueryMultiple
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            var menu1 = multipleResult.Read<UserGroupMenu_GetRow_Result>();
            var menu2 = multipleResult.Read<UserGroupMenu_GetRow_Result>();
            var menu3 = multipleResult.Read<UserGroupMenu_GetRow_Result>();
            return menu1.Concat(menu2).Concat(menu3);
        }
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