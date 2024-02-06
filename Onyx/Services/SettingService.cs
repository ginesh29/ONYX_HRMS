﻿using Dapper;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data;
using System.Data.SqlClient;

namespace Onyx.Services
{
    public class SettingService(CommonService commonService)
    {
        private readonly CommonService _commonService = commonService;
        #region Branch
        public IEnumerable<Branch_GetRow_Result> GetBranches(string CoCd)
        {
            var procedureName = "Branch_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Branch_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveBranch(BranchModel model)
        {
            var procedureName = "Branch_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_Des", model.Name);
            parameters.Add("v_CoCd", model.CoCd);
            parameters.Add("v_BU_Cd", "");
            parameters.Add("v_SDes", model.Description);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteBranch(string Cd, string CoCd)
        {
            var procedureName = "Branch_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            parameters.Add("v_CoCd", CoCd);
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
            //parameters.Add("v_Grp", model.BranchCd);
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

        #region User Branch
        public IEnumerable<UserBranchModel> GetUserBranches()
        {
            var procedureName = "Branch_GetRow_Result";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", string.Empty);
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<UserBranchModel>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void DeleteUserBranch(string Cd)
        {
            var procedureName = "UserBranch_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Div", Cd);
            parameters.Add("v_UserCd", Cd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Department
        public IEnumerable<Dept_GetRow_Result> GetDepartments()
        {
            var procedureName = "Dept_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Dept_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveDepartment(DepartmentModel model)
        {
            var procedureName = "Dept_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_SDes", model.Name);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteDepartment(string Cd)
        {
            var procedureName = "Dept_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion
    }
}