using Dapper;
using Onyx.Data;
using Onyx.Models.StoredProcedure;
using System.Data;

namespace Onyx.Services
{
    public class DbGatewayService(AppDbContext context, IHttpContextAccessor httpContextAccessor)
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
        public string GetConnectionString(string CoAbbr = null)
        {
            CoAbbr ??= _httpContextAccessor.HttpContext.User.Claims.FirstOrDefault(m => m.Type == "CoAbbr")?.Value;
            var procedureName = "CompanyDatabases_Getrow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoAbbr", CoAbbr);
            using var connection = _context.CreateConnection();
            var company = connection.QueryFirstOrDefault<CompanyDatabases_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return $"Server={company.Server};Initial catalog={company.DbName};uid={company.DbUser}; pwd={company.DbPwd};TrustServerCertificate=True;Connection Timeout=120;";
        }
    }
}
