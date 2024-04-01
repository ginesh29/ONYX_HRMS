using Dapper;
using System.Data.SqlClient;
using System.Data;
using Onyx.Models.StoredProcedure.Report;

namespace Onyx.Services
{
    public class ReportService(DbGatewayService dbGatewayService)
    {
        private readonly DbGatewayService _dbGatewayService = dbGatewayService;
        public IEnumerable<GetRepo_EmpShortList_Result> GetEmpShortList(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpShortList";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);

            var connection = new SqlConnection(connectionString);
            var user = connection.Query<GetRepo_EmpShortList_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }
    }
}
