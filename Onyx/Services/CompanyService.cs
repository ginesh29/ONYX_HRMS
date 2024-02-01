using Dapper;
using Onyx.Data;
using Onyx.Models.StoredProcedure;
using System.Data;

namespace Onyx.Services
{
    public class CompanyService(AppDbContext context)
    {
        private readonly AppDbContext _context = context;
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
    }
}