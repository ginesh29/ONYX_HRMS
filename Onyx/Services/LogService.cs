using Dapper;
using Onyx.Models.ViewModels;
using System.Data.SqlClient;
using System.Data;
using System.Net.Sockets;
using System.Net;
using Microsoft.AspNetCore.Http;

namespace Onyx.Services
{
    public class LogService(DbGatewayService dbGatewayService, IHttpContextAccessor httpContextAccessor)
    {
        private readonly DbGatewayService _dbGatewayService = dbGatewayService;
        private readonly IHttpContextAccessor _httpContextAccessor = httpContextAccessor;
        public string SetActivityLogHead(ActivityLogModel model)
        {
            var ipAddress = _httpContextAccessor.HttpContext.Connection.RemoteIpAddress;
            var os = Environment.OSVersion.Platform.ToString();
            var connectionString = _dbGatewayService.GetConnectionString(model.CoAbbr);
            var procedureName = "ActivityLogHead_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", model.CoCd);
            parameters.Add("v_ActivityId", model.ActivityId ?? string.Empty);
            parameters.Add("v_SessionId", "");
            parameters.Add("v_UserCd", model.UserCd);
            parameters.Add("v_IP", ipAddress);
            parameters.Add("v_OS", os);
            parameters.Add("v_Browser", model.Browser);
            parameters.Add("v_StartTime", DateTime.Now);
            parameters.Add("v_EndTime", model.ActivityType == "U" ? DateTime.Now : null);
            parameters.Add("v_typ", model.ActivityType);
            var connection = new SqlConnection(connectionString);
            string result = connection.QueryFirstOrDefault<string>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
    }
}
