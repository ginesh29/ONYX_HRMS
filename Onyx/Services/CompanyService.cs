using Dapper;
using Onyx.Models.StoredProcedure;
using System.Data;
using System.Data.SqlClient;

namespace Onyx.Services
{
    public class CompanyService(CommonService commonService)
    {
        private readonly CommonService _commonService = commonService;

        public IEnumerable<Branch_UserCo_GetRow_Result> GetUserCompanies(string UserCd)
        {
            var procedureName = "Branch_UserCo_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_UserCd", UserCd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var companies = connection.Query<Branch_UserCo_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return companies;
        }
    }
}