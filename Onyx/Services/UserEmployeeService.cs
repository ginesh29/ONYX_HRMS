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
        public Employee_Find_Result FindEmployee(string Cd, string CoCd)
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
        public IEnumerable<Employee_GetRow_Result> GetEmployees(string CoCd, string departments = "0", string designations = "0", string branches = "0", string locations = "0")
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "Employee_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", "");
            parameters.Add("v_Typ", "99");
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_RowsCnt", "2");
            parameters.Add("v_Div", branches ?? "0");
            parameters.Add("v_Dept", departments ?? "0");
            parameters.Add("v_Sponsor", "0");
            parameters.Add("v_Designation", designations ?? "0");
            parameters.Add("v_Location", locations ?? "0");
            parameters.Add("v_Status", "0");
            var connection = new SqlConnection(connectionString);
            var employee = connection.Query<Employee_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return employee;
        }
        public CommonResponse SaveEmployee(Employee_GetRow_Result model, string CoCd)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "Employee_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Cd);
            parameters.Add("v_Salute", model.Salute);
            parameters.Add("v_Fname", model.FirstName);
            parameters.Add("v_Mname", model.MiddleName);
            parameters.Add("v_Lname", model.LastName);
            parameters.Add("v_Sex", model.Sex);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Div", model.BranchCd);
            //parameters.Add("v_CC", model.CC);
            parameters.Add("v_Dept", model.DepartmentCd);
            parameters.Add("v_LocCd", model.LocationCd);
            parameters.Add("v_POB", model.POB);
            parameters.Add("v_Nat", model.Nat);
            parameters.Add("v_Relg", model.Relg);
            parameters.Add("v_Marital", model.Marital);
            parameters.Add("v_Desg", model.Desg);
            parameters.Add("v_Dob", model.DOB);
            parameters.Add("v_Doj", model.DOJ);
            parameters.Add("v_RepTo", model.ReportingTo);
            parameters.Add("v_Father", model.Father);
            parameters.Add("v_Mother", model.Mother);
            parameters.Add("v_Spouse", model.Spouse);
            //parameters.Add("v_EmpCat1", model.EmployeeCategory1); //
            //parameters.Add("v_EmpCat2", model.EmployeeCategory2);//
            //parameters.Add("v_EmpCat3", model.EmployeeCategory3);//

            //parameters.Add("v_Probation", model.Probation);
            //parameters.Add("v_Confrm", model.FormatedConfrm);
            //parameters.Add("v_Leaving", model.Leaving);
            //parameters.Add("v_BasicCurr", model.BasicCurr);
            //parameters.Add("v_Basic", model.Basic);
            //parameters.Add("v_CurrCd", model.CurrencyCd);
            //parameters.Add("v_Personal_No", model.PersonID);
            //parameters.Add("v_FareEligible", model.FareEligible);
            //parameters.Add("v_NoTickets", model.NoOfTickets);
            //parameters.Add("v_TravSect", model.TravelSector);
            //parameters.Add("v_TravClass", model.TravelClass);
            //parameters.Add("v_HomeBase", model.HomeBase);
            //parameters.Add("v_PayMode", model.PayMode);
            //parameters.Add("v_PayFreq", model.PayFrequency);
            //parameters.Add("v_BankCd", model.BankCd);
            //parameters.Add("v_LvDays", model.LvDays);
            //parameters.Add("v_LvSalaryDays", model.LvSalaryDays);
            parameters.Add("v_Status", model.Status);
            parameters.Add("v_Sponsor", model.Sponsor);
            parameters.Add("v_EntryBy", model.EntryBy); //
            //parameters.Add("v_OTEligible", model.OTEligible);
            //parameters.Add("v_LvPrd", model.LvPrd);
            //parameters.Add("v_TradeCd", model.TradeCd); //
            parameters.Add("v_EmpTyp", model.EmpType);
            //parameters.Add("v_Pwd", model.Pwd);     //
            //parameters.Add("v_ApprCd", model.ApprCd);       //
            parameters.Add("v_UserCd", model.UserCd);  //
            //parameters.Add("v_ShiftCd", model.ShiftCd);  //
            //parameters.Add("v_CalcBasis", model.CalcBasis);
            //parameters.Add("v_GT", model.GT);
            //parameters.Add("v_LS", model.LS);
            //parameters.Add("v_LT", model.LT);
            //parameters.Add("v_LeaveOB", model.LeaveOB);
            //parameters.Add("v_Active", model.Active);
            //parameters.Add("v_PassportLocation", model.PassportLocation);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>
               (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
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
