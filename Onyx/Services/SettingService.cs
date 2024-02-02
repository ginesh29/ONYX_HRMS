using Dapper;
using Onyx.Models.ViewModels;
using System.Data;
using System.Data.SqlClient;

namespace Onyx.Services
{
    public class SettingService(CommonService commonService)
    {
        private readonly CommonService _commonService = commonService;
        #region User Groups
        public IEnumerable<UserGroupModel> GetUserGroups()
        {
            var procedureName = "UserGroups_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<UserGroupModel>
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
    }
}
