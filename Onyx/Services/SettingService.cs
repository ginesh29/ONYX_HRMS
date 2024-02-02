using Dapper;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data;
using System.Data.SqlClient;

namespace Onyx.Services
{
    public class SettingService(CommonService commonService)
    {
        private readonly CommonService _commonService = commonService;
        #region User Group
        public IEnumerable<UserGroups_GetRow> GetUserGroups()
        {
            var procedureName = "UserGroups_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<UserGroups_GetRow>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveUserGroup(UserGroupModel model)
        {
            var procedureName = "UserGroups_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Cd);
            parameters.Add("v_ViewAllEmp", model.ViewAllEmp);
            parameters.Add("v_Des", model.Des);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteUserGroup(string Cd)
        {
            var procedureName = "UserGroups_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region User
        public IEnumerable<Users_GetRow_Result> GetUsers()
        {
            var procedureName = "Users_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Users_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveUser(UserModel model)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "Users_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_LoginId", model.LoginId);
            parameters.Add("v_Abbr", model.Abbr);
            parameters.Add("v_Grp", model.UserGroupCd);
            parameters.Add("v_UPWD", model.UPwd.Encrypt());
            parameters.Add("v_UName", model.Username);
            parameters.Add("v_ExpiryDt", Convert.ToDateTime(model.ExpiryDt).ToString("d"));
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", null);
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteUser(string Cd)
        {
            var procedureName = "Users_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion
    }
}
