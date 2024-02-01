using Dapper;
using Onyx.Data;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data;
using System.Data.SqlClient;

namespace Onyx.Services
{
    public class CommonService(AppDbContext context)
    {
        private readonly AppDbContext _context = context;
        public string GetConnectionString(string CoAbbr)
        {
            var procedureName = "CompanyDatabases_Getrow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoAbbr", CoAbbr);
            using var connection = _context.CreateConnection();
            var company = connection.QueryFirstOrDefault<CompanyDatabases_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return $"Server={company.Server};Initial catalog={company.DbName};uid={company.DbUser}; pwd={company.DbPwd};TrustServerCertificate=True;Connection Timeout=120;";
        }
        public IEnumerable<UserGroupMenu_GetRow_Result> GetMenuItems(string CoAbbr, string UserCd)
        {
            var connectionString = GetConnectionString(CoAbbr);
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
        public int SetActivityLogHead(string CoAbbr, ActivityLogModel activity)
        {
            var connectionString = GetConnectionString(CoAbbr);
            var procedureName = "ActivityLogHead_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", activity.CoCd);
            parameters.Add("v_ActivityId", activity.ActivityId);
            parameters.Add("v_SessionId", activity.SessionId);
            parameters.Add("v_UserCd", activity.UserCd);
            parameters.Add("v_IP", activity.IP);
            parameters.Add("v_OS", activity.OS);
            parameters.Add("v_Browser", activity.Browser);
            parameters.Add("v_StartTime", activity.StartTime);
            parameters.Add("v_EndTime", activity.EndTime);
            parameters.Add("v_typ", activity.Type);
            var connection = new SqlConnection(connectionString);
            int result = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public Parameters_GetRow_Result GetJobCardStartAndEndTime(string CoAbbr, string CoCd, string Cd)
        {
            var connectionString = GetConnectionString(CoAbbr);
            var procedureName = "Parameters_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_opt", "");
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<Parameters_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public DateTime GetCuurentLoggedInDetails(string CoAbbr, string CoCd)
        {
            var connectionString = GetConnectionString(CoAbbr);
            var procedureName = "ActvityLogHead_MaxActivityId_Getrow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            DateTime? result = connection.QueryFirstOrDefault<DateTime>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result != null ? Convert.ToDateTime(result) : DateTime.Now;
        }
    }
}