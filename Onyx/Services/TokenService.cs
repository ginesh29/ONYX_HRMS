using Dapper;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data.SqlClient;
using System.Data;

namespace Onyx.Services
{
    public class TokenService(DbGatewayService dbGatewayService)
    {
        private readonly DbGatewayService _dbGatewayService = dbGatewayService;
        #region Counter
        public IEnumerable<Counter_GetRow_Result> GetCounters(string Cd = "")
        {
            var procedureName = "Counter_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CounterCd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Counter_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveCounter(CounterModel model)
        {
            var procedureName = "Counter_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_CounterCd", model.Cd.Trim());
            parameters.Add("v_CounterName", model.Name);
            parameters.Add("v_Active", model.Active);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteCounter(string Cd)
        {
            var procedureName = "Counter_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_CounterCd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public string GetToken_SrNo()
        {
            var query = "SELECT 'CNTR'+right('000'+ convert(varchar(3),isnull(Max(substring(cd,4,len(trim(cd)))),0)+1),3)  AS NextCode FROM Counters";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (query);
            return data;
        }
        #endregion

        #region Service
        public IEnumerable<Counter_GetRow_Result> GetServices(string Cd = "")
        {
            var procedureName = "Service_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_ServiceCd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Counter_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveService(ServiceModel model)
        {
            var procedureName = "Service_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_ServiceCd", model.Cd.Trim());
            parameters.Add("v_ServiceName", model.Name);
            parameters.Add("v_Active", model.Active);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteService(string Cd)
        {
            var procedureName = "Service_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_ServiceCd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public string GetService_SrNo()
        {
            var query = "SELECT 'Service'+right('000'+ convert(varchar(3),isnull(Max(substring(cd,4,len(trim(cd)))),0)+1),3)  AS NextCode FROM Services";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (query);
            return data;
        }
        #endregion
    }
}
