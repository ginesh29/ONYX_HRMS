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
        #region Employee
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
        public IEnumerable<Employee_GetRow_Result> GetEmployees(string CoCd, string Cd = "", string departments = "0", string designations = "0", string branches = "0", string locations = "0")
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "Employee_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd ?? string.Empty);
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
        public IEnumerable<Employee_Find_Result> EmployeeFind(string Cd, string CoCd)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "Employee_Find";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", Cd);
            parameters.Add("v_Typ", "1");
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            var employee = connection.Query<Employee_Find_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return employee;
        }
        public CommonResponse SaveEmployee(Employee_Find_Result model, string CoCd)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "Employee_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Cd);
            parameters.Add("v_Salute", model.Salute);
            parameters.Add("v_Fname", model.Fname);
            parameters.Add("v_Mname", model.Mname ?? string.Empty);
            parameters.Add("v_Lname", model.Lname);
            parameters.Add("v_Sex", model.Sex);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Div", model.Div);
            parameters.Add("v_POB", model.POB);
            parameters.Add("v_Nat", model.Nat);
            parameters.Add("v_Relg", model.Relg);
            parameters.Add("v_Marital", model.Marital);
            parameters.Add("v_Desg", model.Desg);
            parameters.Add("v_Dob", model.Dob);
            parameters.Add("v_Father", model.Father);
            parameters.Add("v_Mother", model.Mother);
            parameters.Add("v_Spouse", model.Spouse);
            parameters.Add("v_Sponsor", model.Sponsor);
            parameters.Add("v_Dept", model.Dept);
            parameters.Add("v_LocCd", model.LocCd);
            parameters.Add("v_RepTo", model.RepTo);
            parameters.Add("v_UserCd", model.UserCd);
            parameters.Add("v_Probation", model.Probation);
            parameters.Add("v_Pwd", model.ConfirmPassword);
            parameters.Add("v_ImageFile", model.Imagefile);
            parameters.Add("v_ImageSign", model.ImageSign);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Personal_No", model.Personal_No);
            parameters.Add("v_PayMode", model.PayMode);
            parameters.Add("v_PayFreq", model.PayFreq);
            parameters.Add("v_BankCd", model.BankCd);
            parameters.Add("v_BasicCurr", model.BasicCurr);
            parameters.Add("v_Basic", model.Basic);
            parameters.Add("v_CurrCd", model.CurrCd);
            parameters.Add("v_Doj", model.Doj);
            parameters.Add("v_Confrm", model.Confrm);
            parameters.Add("v_Leaving", model.Leaving);
            parameters.Add("v_FareEligible", model.FareEligibleValue ? "Y" : "N");
            parameters.Add("v_NoTickets", model.NoTickets);
            parameters.Add("v_TravSect", model.TravSect);
            parameters.Add("v_TravClass", model.TravClass);
            parameters.Add("v_HomeBase", model.HomeBase);
            parameters.Add("v_LvDays", model.LvMax);
            parameters.Add("v_LvSalaryDays", model.LvDays);
            parameters.Add("v_LvPrd", model.LvPrd);
            parameters.Add("v_EmpTyp", model.EmpTyp);
            parameters.Add("v_Status", model.Status);
            parameters.Add("v_PassportLocation", model.PassportLocation);
            parameters.Add("v_CalcBasis", model.CalcBasis);
            parameters.Add("v_GT", model.GTValue ? "Y" : "N");
            parameters.Add("v_LS", model.LSValue ? "Y" : "N");
            parameters.Add("v_LT", model.LTValue ? "Y" : "N");
            parameters.Add("v_Active", model.ActiveValue ? "Y" : "N");
            //parameters.Add("v_OTEligible", model.OTEligible);
            //parameters.Add("v_TradeCd", model.TradeCd);
            //parameters.Add("v_ApprCd", model.ApprCd);
            //parameters.Add("v_ShiftCd", model.ShiftCd);
            //parameters.Add("v_LeaveOB", model.LeaveOB);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>
               (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse RemoveAvatar(string Cd)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "EmployeePhoto_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            parameters.Add("ImageFile", string.Empty);
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
        #region Qualification
        public IEnumerable<EmpQualification_GetRow_Result> GetEmpQualifications(string empCd, string CoCd)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "EmpQualification_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_SrNo", 0);
            var connection = new SqlConnection(connectionString);
            var qualifications = connection.Query<EmpQualification_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return qualifications;
        }
        public void DeleteEmpQualification(string empCd, int srNo)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "EmpQualification_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_SrNo", srNo);
            var connection = new SqlConnection(connectionString);
            connection.Query<EmpQualification_GetRow_Result>(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public CommonResponse SaveEmpQualification(EmpQualificationModel model)
        {
            var connectionString = _commonService.GetConnectionString();
            var parameters = new DynamicParameters();
            var procedureName = "EmpQualification_Update";
            parameters.Add("v_EmpCd", model.EmpCd);
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_QualCd", model.QualCd);
            parameters.Add("v_Univ", model.University);
            parameters.Add("v_Country", model.CountryCd);
            parameters.Add("v_PassYr", model.PassingYear);
            parameters.Add("v_Markgr", model.MarksGrade);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public int GetEmpQualification_SrNo(string empCd)
        {
            var connectionString = _commonService.GetConnectionString();
            var parameters = new DynamicParameters();
            var procedureName = "EmpQualification_SrNo_GetRow";
            parameters.Add("v_EmpCd", empCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<int>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        #endregion

        #region Experience
        public IEnumerable<EmpExperience_GetRow_Result> GetEmpExperiences(string empCd)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "EmpExperience_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_SrNo", 0);
            var connection = new SqlConnection(connectionString);
            var qualifications = connection.Query<EmpExperience_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return qualifications;
        }
        public void DeleteEmpExperience(string empCd, int srNo)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "EmpExperience_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_SrNo", srNo);
            var connection = new SqlConnection(connectionString);
            connection.Query<EmpQualification_GetRow_Result>(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public CommonResponse SaveEmpExperience(EmpExperienceModel model)
        {
            var connectionString = _commonService.GetConnectionString();
            var parameters = new DynamicParameters();
            var procedureName = "EmpExperience_Update";
            parameters.Add("v_EmpCd", model.EmpCd);
            parameters.Add("v_SrNo", model.Srno);
            parameters.Add("v_Stdt", model.StartingDate);
            parameters.Add("v_Enddt", model.EndingDate);
            parameters.Add("v_Desg", model.Desg);
            parameters.Add("v_Coname", model.CompanyName);
            parameters.Add("v_Country", model.CountryCd);
            parameters.Add("v_Coref", model.CompanyReference);
            parameters.Add("v_Narr", model.Narration);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public int GetEmpExperience_SrNo(string empCd)
        {
            var connectionString = _commonService.GetConnectionString();
            var parameters = new DynamicParameters();
            var procedureName = "EmpExperience_SrNo_GetRow";
            parameters.Add("v_EmpCd", empCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<int>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        #endregion
        #endregion
    }
}
