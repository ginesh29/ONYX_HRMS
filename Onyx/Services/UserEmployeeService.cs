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
            var connectionString = _commonService.GetConnectionString(model.CoAbbr);
            var procedureName = "Validate_User";
            var parameters = new DynamicParameters();
            parameters.Add("v_UserID", model.Username);
            parameters.Add("v_PWD", model.Password.Encrypt());
            var connection = new SqlConnection(connectionString);
            var user = connection.QueryFirstOrDefault<Validate_User_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }
        public Validate_Employee_Result ValidateEmployee(LoginModel model)
        {
            var connectionString = _commonService.GetConnectionString(model.CoAbbr);
            var procedureName = "Validate_Employee";
            var parameters = new DynamicParameters();
            parameters.Add("v_EMPID", model.Username);
            parameters.Add("v_PWD", model.Password.Encrypt());
            var connection = new SqlConnection(connectionString);
            var employee = connection.QueryFirstOrDefault<Validate_Employee_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return employee;
        }
        public Users_GetRow_Result GetUser(string CoAbbr, string UserCd)
        {
            var connectionString = _commonService.GetConnectionString(CoAbbr);
            var procedureName = "Users_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", UserCd);
            var connection = new SqlConnection(connectionString);
            var user = connection.QueryFirstOrDefault<Users_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }
        public Employee_Find_Result GetEmployee(string CoAbbr, string Cd)
        {
            var connectionString = _commonService.GetConnectionString(CoAbbr);
            var procedureName = "Employee_Find";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", Cd);
            parameters.Add("v_Typ", "2");
            parameters.Add("v_CoCd", "");
            var connection = new SqlConnection(connectionString);
            var employee = connection.QueryFirstOrDefault<Employee_Find_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return employee;
        }
    }
}
