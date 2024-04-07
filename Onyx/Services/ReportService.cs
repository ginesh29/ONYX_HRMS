using Dapper;
using System.Data.SqlClient;
using System.Data;
using Onyx.Models.StoredProcedure.Report;
using System.Net.NetworkInformation;

namespace Onyx.Services
{
    public class ReportService(DbGatewayService dbGatewayService)
    {
        private readonly DbGatewayService _dbGatewayService = dbGatewayService;
        public IEnumerable<GetRepo_EmpShortList_Result> GetEmpShortList(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpShortList_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
//,   @v_Employee Char(10)= ''
//,   @v_Branch           char(5) = ''
//,   @v_Location         char(10) = ''
//,   @v_Department Char(10)= ''
//,   @v_Sponsor Char(10)= ''
//,	@v_Desg Char(5)= ''
//,	@v_Age Char(5)= '0'
//,	@v_Qualification Char(10)= ''
//,	@v_Status Char(10)= ''
//,   @v_RowsCnt Char(1)= ''
//,	@v_Nationality Char(10)= ''
            var connection = new SqlConnection(connectionString);
            var user = connection.Query<GetRepo_EmpShortList_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }
    }
}
