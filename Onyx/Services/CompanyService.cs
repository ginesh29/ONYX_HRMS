using Dapper;
using Onyx.Data;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data;
using System.Data.SqlClient;

namespace Onyx.Services
{
    public class CompanyService
    {
        private readonly AppDbContext _context;
        private readonly AuthService _authService;
        private readonly CommonService _commonService;
        public CompanyService(AppDbContext context, AuthService authService, CommonService commonService)
        {
            _context = context;
            _authService = authService;
            _commonService = commonService;
        }

        public IEnumerable<Branch_UserCo_GetRow> GetCompanies(string CoAbbr, string UserCd)
        {
            var procedureName = "Branch_UserCo_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_UserCd", UserCd);
            var connectionString = _commonService.GetConnectionString(CoAbbr);
            var connection = new SqlConnection(connectionString);
            var companies = connection.Query<Branch_UserCo_GetRow>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
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
    }
}