using Dapper;
using Onyx.Data;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Sockets;

namespace Onyx.Services
{
    public class CommonService
    {
        private readonly AppDbContext _context;
        public CommonService(AppDbContext context)
        {
            _context = context;
        }
        public string GetConnectionString()
        {
            var procedureName = "CompanyDatabases_Getrow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoAbbr", CommonSetting.MAINCOMPANY);
            using var connection = _context.CreateConnection();
            var company = connection.QueryFirstOrDefault<CompanyDatabases_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return $"Server={company.Server};Initial catalog={company.DbName};uid={company.DbUser}; pwd={company.DbPwd};TrustServerCertificate=True;Connection Timeout=120;";
        }
        public IEnumerable<UserGroupMenu_GetRow_Result> GetMenuItems(string UserCd)
        {
            var connectionString = GetConnectionString();
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
        public int SetActivityLogHead(ActivityLogModel model)
        {
            var ip = Dns.GetHostEntry(Dns.GetHostName()).AddressList.FirstOrDefault(m => m.AddressFamily == AddressFamily.InterNetwork).ToString();
            var os = Environment.OSVersion.Platform.ToString();
            var connectionString = GetConnectionString();
            var procedureName = "ActivityLogHead_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", model.CoCd);
            parameters.Add("v_ActivityId", "");
            parameters.Add("v_SessionId", "");
            parameters.Add("v_UserCd", model.UserCd);
            parameters.Add("v_IP", ip);
            parameters.Add("v_OS", os);
            parameters.Add("v_Browser", model.Browser);
            parameters.Add("v_StartTime", DateTime.Now);
            parameters.Add("v_EndTime", DateTime.Now);
            parameters.Add("v_typ", "I");
            var connection = new SqlConnection(connectionString);
            int result = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public Parameters_GetRow_Result GetJobCardStartAndEndTime(string CoCd, string Cd)
        {
            var connectionString = GetConnectionString();
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
        public DateTime GetCuurentLoggedInDetails(string CoCd)
        {
            var connectionString = GetConnectionString();
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