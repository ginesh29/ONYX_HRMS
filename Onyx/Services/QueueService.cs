using Dapper;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data.SqlClient;
using System.Data;

namespace Onyx.Services
{
    public class QueueService(DbGatewayService dbGatewayService)
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
        public string GetCounter_SrNo()
        {
            var query = "SELECT 'CNTR'+right('000'+ convert(varchar(3),isnull(Max(substring(cd,5,len(trim(cd)))),0)+1),3)  AS NextCode FROM Counters";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (query);
            return data;
        }
        public IEnumerable<AdModel> GetAdFiles(string counteCd, int srNo = 0)
        {
            var procedureName = "AdImages_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CounterCd", counteCd);
            parameters.Add("v_Cd", srNo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<AdModel>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void DeleteAdFile(string counterCd, string cd)
        {
            var procedureName = "Ad_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_CounterCd", counterCd);
            parameters.Add("v_Cd", cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void SaveAdFile(AdModel model)
        {
            var procedureName = "CompDocImages_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Cd);
            parameters.Add("v_CounterCd", model.CounterCd);
            parameters.Add("v_ImageFile", model.ImageFile);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Service
        public IEnumerable<Service_GetRow_Result> GetServices(string Cd = "")
        {
            var procedureName = "Service_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_ServiceCd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Service_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveService(ServiceModel model)
        {
            var procedureName = "Service_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_ServiceCd", model.Cd.Trim());
            parameters.Add("v_ServiceName", model.Name);
            parameters.Add("v_ServicePrefix", model.Prefix);
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
            var query = "SELECT 'SRVC'+right('000'+ convert(varchar(3),isnull(Max(substring(cd,5,len(trim(cd)))),0)+1),3)  AS NextCode FROM Services";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (query);
            return data;
        }
        #endregion

        #region Token
        public IEnumerable<Token_Getrow_Result> GetTokens(string Cd = "")
        {
            var procedureName = "Token_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_TokenNo", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Token_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveToken(TokenModel model)
        {
            var procedureName = "Token_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_TokenNo", model.TokenNo);
            parameters.Add("v_ServiceCd", model.ServiceCd);
            parameters.Add("v_MobileNo", model.MobileNo);
            parameters.Add("v_Status", model.Status);
            parameters.Add("v_CalledDt", model.CalledDt);
            parameters.Add("v_ServedDt", model.ServedDt);
            parameters.Add("v_ServedBy", model.ServedBy);
            parameters.Add("v_CounterCd", model.CounterCd);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public string GetToken_SrNo(string prefix, string serviceCd)
        {
            var query = $"SELECT '{prefix}-'+right('000'+ convert(varchar(3),isnull(Max(substring(TokenNo,5,len(trim(TokenNo)))),0)+1),3)  AS NextCode FROM Tokens where ServiceCd = '{serviceCd}'";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>(query);
            return data;
        }
        #endregion
    }
}
