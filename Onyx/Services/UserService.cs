using Dapper;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data.SqlClient;
using System.Data;

namespace Onyx.Services
{
    public class UserService(DbGatewayService dbGatewayService)
    {
        private readonly DbGatewayService _dbGatewayService = dbGatewayService;
        public Validate_User_Result ValidateUser(LoginModel model)
        {
            var connectionString = _dbGatewayService.GetConnectionString(model.CoAbbr);
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
            var connectionString = _dbGatewayService.GetConnectionString(model.CoAbbr);
            var procedureName = "Validate_Employee";
            var parameters = new DynamicParameters();
            parameters.Add("v_EMPID", model.LoginId);
            parameters.Add("v_PWD", model.Password.Encrypt());
            var connection = new SqlConnection(connectionString);
            var employee = connection.QueryFirstOrDefault<Validate_Employee_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return employee;
        }
        public IEnumerable<Users_GetRow_Result> GetUsers(string UserCd = "", string CoAbbr = null)
        {
            var connectionString = _dbGatewayService.GetConnectionString(CoAbbr);
            var procedureName = "Users_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", UserCd);
            var connection = new SqlConnection(connectionString);
            var user = connection.Query<Users_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }
    }
}
