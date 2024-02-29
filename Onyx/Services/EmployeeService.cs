using Dapper;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data;
using System.Data.SqlClient;

namespace Onyx.Services
{
    public class EmployeeService(CommonService commonService)
    {
        private readonly CommonService _commonService = commonService;
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

        #region Document
        public IEnumerable<EmpDocuments_GetRow_Result> GetDocuments(string empCd)
        {
            var procedureName = "EmpDocuments_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_DocTyp", string.Empty);
            parameters.Add("v_SrNo", 0);
            parameters.Add("v_Typ", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpDocuments_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveDocument(EmpDocumentModel model)
        {
            var procedureName = "EmpDocuments_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", model.EmpCd);
            parameters.Add("v_DocTyp", model.DocTypCd);
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_DocNo", model.DocNo);
            parameters.Add("v_IssueDt", model.IssueDt);
            parameters.Add("v_IssuePlace", model.IssuePlace);
            parameters.Add("v_ExpDt", model.ExpDt);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteDocument(string empCd, string docType, int SrNo)
        {
            var procedureName = "EmpDocuments_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_DocTyp", docType);
            parameters.Add("v_SrNo", SrNo);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<EmpDocImages_GetRow_Result> GetDocumentFiles(string empCd, string docTypCd)
        {
            var procedureName = "EmpDocImages_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_DocTyp", docTypCd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpDocImages_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveDocumentFile(EmpDocImageModel model)
        {
            var procedureName = "EmpDocImages_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", model.EmployeeCode);
            parameters.Add("v_DocTyp", model.DocumentTypeCd);
            parameters.Add("v_SlNo", model.SlNo);
            parameters.Add("v_ImageFile", model.ImageFile);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public CommonResponse DeleteDocumentFile(string empCd, string docTypCd, int srNo)
        {
            var procedureName = "EmpDocImages_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_DocTyp", docTypCd);
            parameters.Add("v_SrNo", srNo);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        #endregion

        #region Component
        public IEnumerable<EmpEarnDed_GetRow_Result> GetComponents(string empCd)
        {
            var procedureName = "EmpEarnDed_View_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_EdCd", string.Empty);
            parameters.Add("v_EdTyp", string.Empty);
            parameters.Add("v_Typ", "3");
            parameters.Add("v_SrNo", 0);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpEarnDed_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<CompanyEarnDed_GetRow_Result> GetComponentClasses(string type)
        {
            var query = $"Select * from CompanyEarnDed Where Typ = '{type}'";
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyEarnDed_GetRow_Result>
                (query);
            return data;
        }
        public CommonResponse SaveComponent(EmpEarnDedModel model)
        {
            var procedureName = "EmpEarnDed_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", model.EmpCd);
            parameters.Add("v_EdCd", model.EdCd);
            parameters.Add("v_EdTyp", model.EdTyp);
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_Curr", model.CurrCd);
            parameters.Add("v_PercAmt", model.PercAmt);
            parameters.Add("v_PercVal", model.PercVal);
            parameters.Add("v_AmtVal", model.Amt);
            parameters.Add("v_EffDate", model.EffDt);
            parameters.Add("v_EndDate", model.EndDt);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteComponent(string empCd, string edCd, string edTyp, int srNo)
        {
            var procedureName = "EmpEarnDed_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_EdCd", edCd);
            parameters.Add("v_EdTyp", edTyp);
            parameters.Add("v_SrNo", srNo);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Address
        public IEnumerable<EmpAddress_GetRow_Result> GetAddresses(string empCd)
        {
            var procedureName = "EmpAddress_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpAddress_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveAddress(EmpAddressModel model)
        {
            var procedureName = "EmpAddress_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", model.EmployeeCode);
            parameters.Add("v_AddTyp", model.AddTyp);
            parameters.Add("v_Contact", model.Contact);
            parameters.Add("v_Add1", model.AddressLine1);
            parameters.Add("v_Add2", model.AddressLine2);
            parameters.Add("v_Add3", model.AddressLine3);
            parameters.Add("v_City", model.City);
            parameters.Add("v_Country", model.CountryCd);
            parameters.Add("v_Phone", model.Phone);
            parameters.Add("v_Mobile", model.Mobile);
            parameters.Add("v_Fax", model.Fax);
            parameters.Add("v_Email", model.Email);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteAddress(string empCd, string type)
        {
            var procedureName = "EmpAddress_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_AddTyp", type);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Bank Account
        public IEnumerable<EmpBankAc_GetRow_Result> GetBankAccounts()
        {
            var procedureName = "EmpBankAc_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpBankAc_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveBankAccount(EmpBankAcModel model)
        {
            var procedureName = "EmpBankAc_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", model.EmpCd);
            parameters.Add("v_Bank", model.BankCd);
            parameters.Add("v_Br", model.BankBrCd);
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_AcName", model.EmployeeAcName);
            parameters.Add("v_EmpAc", model.EmpAc);
            parameters.Add("v_Typ", model.Typ);
            parameters.Add("v_Curr", model.CurrCd);
            parameters.Add("v_Amt", model.Amt);
            parameters.Add("v_BkGrp", model.BankGrpCd);
            parameters.Add("v_RouteCd", model.RouteCd);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteBankAccount(string empCd, string bankCd, string bankBrCd, int srNo)
        {
            var procedureName = "EmpBankAc_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_Bank", bankCd);
            parameters.Add("v_Br", bankBrCd);
            parameters.Add("v_SrNo", srNo);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Calendar Event
        public IEnumerable<EmpCalendar_GetRow_Result> GetCalendarEvents(string empCd)
        {
            var procedureName = "EmpCalendar_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpCalendar_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveCalendarEvent(EmpCalendarModel model)
        {
            var procedureName = "EmpCalendar_Update";
            var parameters = new DynamicParameters();
            parameters.Add("@v_SrNo", model.SrNo);
            parameters.Add("@v_Empcd", model.EmpCd);
            parameters.Add("@v_Date", model.Date);
            parameters.Add("v_Holiday", model.Holiday);
            parameters.Add("@v_Narr", model.Narr);
            parameters.Add("@v_Title", model.Title);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteCalendarEvent(int srNo)
        {
            var procedureName = "EmpCalendar_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_SrNo", srNo);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion
    }
}
