using Dapper;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data.SqlClient;
using System.Data;

namespace Onyx.Services
{
    public class UserEmployeeService(CommonService commonService)
    {
        private readonly CommonService _commonService = commonService;
        public Validate_User_Result ValidateUser(LoginModel model)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "Validate_User";
            var parameters = new DynamicParameters();
            parameters.Add("v_UserID", model.LoginId);
            parameters.Add("v_PWD", model.Password.Encrypt());
            var connection = new SqlConnection(connectionString);
            var user = connection.QueryFirstOrDefault<Validate_User_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }
        public Validate_Employee_Result ValidateEmployee(LoginModel model)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "Validate_Employee";
            var parameters = new DynamicParameters();
            parameters.Add("v_EMPID", model.LoginId);
            parameters.Add("v_PWD", model.Password.Encrypt());
            var connection = new SqlConnection(connectionString);
            var employee = connection.QueryFirstOrDefault<Validate_Employee_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return employee;
        }
        public UserModel GetUser(string UserCd)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "Users_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", UserCd);
            var connection = new SqlConnection(connectionString);
            var user = connection.QueryFirstOrDefault<UserModel>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }        
        public Employee_Find_Result GetEmployee(string Cd,string CoCd)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "Employee_Find";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", Cd);
            parameters.Add("v_Typ", "2");
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            var employee = connection.QueryFirstOrDefault<Employee_Find_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return employee;
        }
        public string UpdateEmployeePassword(string CoCd, string Cd, string Password)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "Employee_PasswordUpdate";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Pwd", Password.Encrypt());
            var connection = new SqlConnection(connectionString);
            string result = connection.QueryFirstOrDefault(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
    }
}
