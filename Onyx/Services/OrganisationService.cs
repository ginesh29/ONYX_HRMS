using Dapper;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data.SqlClient;
using System.Data;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace Onyx.Services
{
    public class OrganisationService(DbGatewayService dbGatewayService, AuthService authService, CommonService commonService)
    {
        private readonly DbGatewayService _dbGatewayService = dbGatewayService;
        private readonly LoggedInUserModel _loggedInUser = authService.GetLoggedInUser();
        private readonly CommonService _commonService = commonService;

        #region Component
        public IEnumerable<CompanyEarnDed_GetRow_Result> GetComponents(string type)
        {
            var procedureName = "CompanyEarnDed_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            parameters.Add("v_Typ", type);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyEarnDed_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveComponent(EarnDedModel model)
        {
            var procedureName = "CompanyEarnDed_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Cd);
            parameters.Add("v_Typ", model.TypeCd);
            parameters.Add("v_Abbr", model.Abbriviation);
            parameters.Add("v_SDes", model.SDes);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_PercAmt", model.PercAmt_Cd);
            parameters.Add("v_PercVal", model.Perc_Val);
            parameters.Add("v_TrnTyp", model.TrnTypCd);
            parameters.Add("v_LoanTyp", model.LoanTyp ? "Yes" : "No");
            parameters.Add("v_JobFlag", model.JobCosting ? "Yes" : "No");
            parameters.Add("v_Ot", model.OT ? "Yes" : "No");
            parameters.Add("v_OtCd", model.OtCd ? "Yes" : "No");
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteComponent(string Cd, string type)
        {
            var procedureName = "CompanyEarnDed_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            parameters.Add("v_Typ", type);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Loan Type
        public IEnumerable<CompanyLoanTypes_GetRow_Result> GetLoanTypes(bool showInActive = false)
        {
            var procedureName = "CompanyLoanTypes_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyLoanTypes_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return showInActive == true ? data : data.Where(m => m.Active);
        }
        public CommonResponse SaveLoanType(LoanTypeModel model)
        {
            var procedureName = "CompanyLoanTypes_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_PayTyp", model.PayTyp);
            parameters.Add("v_PayCd", model.PayCd);
            parameters.Add("v_DedTyp", model.DedTyp);
            parameters.Add("v_DedCd", model.DedCd);
            parameters.Add("v_Sdes", model.SDes);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_Abbr", model.Abbriviation);
            parameters.Add("v_Percval", model.IntPerc);
            parameters.Add("v_ChgTyp", model.ChgsTypCd);
            parameters.Add("v_Active", model.Active);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteLoanType(string Cd)
        {
            var procedureName = "CompanyLoanTypes_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Working Hour
        public IEnumerable<CompanyWHrs_GetRow_Result> GetWorkingHours(string CoCd)
        {
            var procedureName = "CompanyWHrs_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyWHrs_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveWorkingHour(WorkingHourModel model, string CoCd)
        {
            var procedureName = "CompanyWHrs_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code.Trim());
            parameters.Add("v_Narr", model.Description);
            parameters.Add("v_FromDt", model.FromDt);
            parameters.Add("v_ToDt", model.ToDt);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_DutyHrs", model.DutyHrs);
            parameters.Add("v_RelgTyp", model.RelgTypCd);
            parameters.Add("v_HolTyp", model.HolTypCd);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteWorkingHour(string Cd)
        {
            var procedureName = "CompanyWHrs_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Overtime Rate
        public IEnumerable<CompanyOvertimeRates_GetRow_Result> GetOvertimeRates(string CoCd)
        {
            var procedureName = "CompanyOvertimeRates_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Typ", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyOvertimeRates_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveOvertimeRate(OvertimeRateModel model, string CoCd)
        {
            var procedureName = "CompanyOvertimeRates_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Typ", model.TypCd);
            parameters.Add("v_HolTyp", model.HolTypCd);
            parameters.Add("v_PayCd", model.PayCode);
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_Rate", model.Rate);
            parameters.Add("v_HrsApply", model.HrsApply);
            parameters.Add("v_Sdes", model.Sdes);
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteOvertimeRate(string Cd, string type, string CoCd)
        {
            var procedureName = "CompanyOvertimeRates_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_SrNo", Cd);
            parameters.Add("v_Typ", type);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public int GetOvertimeRate_SrNo(string CoCd, string type)
        {
            var procedureName = "CompanyOTRatesSrNo1_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Typ", type);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion

        #region Calendar Event
        public IEnumerable<CompanyCalendar_GetRow_Result> GetCalendarEvents(string CoCd, string Cd = "")
        {
            var procedureName = "CompanyCalendar_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Cd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyCalendar_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveCalendarEvent(CompanyCalendarModel model, string CoCd)
        {
            var procedureName = "CompanyCalendar_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Cd", model.Cd);
            parameters.Add("v_Date", model.Date);
            parameters.Add("v_Title", model.Title);
            parameters.Add("v_Holiday", model.Holiday);
            parameters.Add("v_Invite", model.Invite);
            parameters.Add("v_EmailSubject", model.EmailSubject);
            parameters.Add("v_MessageBody", model.MessageBody);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse DeleteCalendarEvent(string Cd)
        {
            var procedureName = "CompanyCalendar_Delete_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void SaveCalendarEventAttendees(string EventCd, List<string> EmpIds)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            string insertQuery = EmpIds != null ? "INSERT INTO CalendarEventAttendees(EventCd,EmpCd) VALUES" : null;
            if (EmpIds != null)
            {
                foreach (var item in EmpIds)
                    insertQuery += $"('{EventCd}','{item.Trim()}'),";
                insertQuery = insertQuery.Trim([',']);
            }
            string query = $"delete from CalendarEventAttendees where EventCd = '{EventCd}';{Environment.NewLine}{insertQuery}";
            var connection = new SqlConnection(connectionString);
            connection.Execute(query);
        }
        public string GetCalendarEvent_SrNo()
        {
            var query = $"SELECT FORMAT(MAX(Cd) + 1, '00') AS NextID FROM companycalendar_N;";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (query);
            return data;
        }
        #endregion

        #region Notification
        public IEnumerable<Notification_GetRow_Result> GetNotifications(string CoCd)
        {
            var procedureName = "Notification_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Notification_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveNotificationMaster(NotificationModel model, string CoCd)
        {
            var procedureName = "Notification_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_ProcessId", model.ProcessId);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_NoOfDays", model.NoOfDays);
            parameters.Add("v_BeforeOrAfter", model.BeforeOrAfter);
            parameters.Add("v_EmailSubject", model.EmailSubject);
            parameters.Add("v_MessageBody", model.MessageBody);
            parameters.Add("v_DocTyp", model.DocTyp);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse SaveNotificationDetail(NotificationModel model, string EmpCd, string CoCd)
        {
            var procedureName = "Notification_Detail_Insert_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_ProcessId", model.ProcessId);
            parameters.Add("v_DocTyp", model.DocTyp);
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_EmpCd", EmpCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteNotificationMaster(int Cd, string ProcessId, string CoCd)
        {
            var procedureName = "Notification_Master_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_SrNo", Cd);
            parameters.Add("v_ProcessId", ProcessId);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteNotificationDetail(int Cd, string ProcessId, string CoCd)
        {
            var procedureName = "Notification_Detail_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_SrNo", Cd);
            parameters.Add("v_ProcessId", ProcessId);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public int GetNotification_SrNo(string CoCd, string ProcessId, string DocType)
        {
            var procedureName = "Notification_GetSrNo";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_ProcessId", ProcessId);
            parameters.Add("v_Typ", "1");
            parameters.Add("v_DocTyp", DocType);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<Notification_Type_GetRow_Result> GetNotificationTypes(string CoCd)
        {
            var procedureName = "Notification_Type_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Notification_Type_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion

        #region Bank
        public IEnumerable<CompanyBank_GetRow_Result> GetBanks()
        {
            var procedureName = "CompanyBank_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_BankCd", string.Empty);
            parameters.Add("v_BranchCd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyBank_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveBank(BankModel model)
        {
            var procedureName = "Bank_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_BankCd", model.BankCd);
            parameters.Add("v_BranchCd", model.BranchCd);
            parameters.Add("v_Bank", model.Bank);
            parameters.Add("v_Swift", model.Swift);
            parameters.Add("v_Add1", model.Address1);
            parameters.Add("v_Add2", model.Address2);
            parameters.Add("v_Add3", model.Address3);
            parameters.Add("v_Contact", model.Contact);
            parameters.Add("v_Phone", model.Phone);
            parameters.Add("v_Fax", model.Fax);
            parameters.Add("v_Email", model.Email);
            parameters.Add("v_URL", model.URL);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse DeleteBank(string bankCd, string branchCd)
        {
            var procedureName = "Bank_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_BankCd", bankCd);
            parameters.Add("v_BranchCd", branchCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        #endregion

        #region Document
        public IEnumerable<CompanyDocuments_GetRow_Result> GetDocuments(string CoCd)
        {
            var procedureName = "CompanyDocuments_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_DocTypCd", string.Empty);
            parameters.Add("v_DivCd", string.Empty);
            parameters.Add("v_Usercd", _loggedInUser.UserLinkedTo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyDocuments_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveDocument(CompanyDocumentModel model, string CoCd)
        {
            var procedureName = "CompanyDocuments_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_DivCd", model.DivCd);
            parameters.Add("v_DocTypCd", model.DocTypCd);
            parameters.Add("v_DocNo", model.DocNo);
            parameters.Add("v_IssueDt", model.IssueDt);
            parameters.Add("v_IssuePlace", model.IssuePlace);
            parameters.Add("v_ExpDt", model.ExpDt);
            parameters.Add("v_RefNo", model.RefNo);
            parameters.Add("v_RefDt", model.RefDt);
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_Partners", model.Partners);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteDocument(string docTypeCd, string divCd, string CoCd)
        {
            var procedureName = "CompanyDocuments_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Div", divCd);
            parameters.Add("v_DocTyp", docTypeCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<CompDocImages_GetRow_Result> GetDocumentFiles(string divCd, string docTypCd, string CoCd)
        {
            var procedureName = "CompDocImages_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Div", divCd);
            parameters.Add("v_DocTyp", docTypCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompDocImages_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveDocumentFile(CompDocImageModel model)
        {
            var procedureName = "CompDocImages_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", model.CompanyCode);
            parameters.Add("v_Div", model.DivCd);
            parameters.Add("v_DocTyp", model.DocumentTypeCd);
            parameters.Add("v_SlNo", model.SlNo);
            parameters.Add("v_ImageFile", model.ImageFile);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public CommonResponse DeleteDocumentFile(string divCd, string docTypCd, int srNo, string CoCd)
        {
            var procedureName = "CompDocImages_Delete_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Div", divCd);
            parameters.Add("v_DocTyp", docTypCd);
            parameters.Add("v_SlNo", srNo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        #endregion

        #region Vehicle
        public IEnumerable<CompanyVehicle_GetRow_Result> GetVehicles()
        {
            var procedureName = "CompanyVehicle_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyVehicle_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveVehicle(CompanyVehicleModel model)
        {
            var procedureName = "CompanyVehicle_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Cd);
            parameters.Add("v_SDes", model.SDes);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_Div", model.BranchCd);
            parameters.Add("v_Loc", model.LocationCd);
            parameters.Add("v_Brand", model.Brand);
            parameters.Add("v_Model", model.ModelCd);
            parameters.Add("v_PurDt", model.PurDt);
            parameters.Add("v_OrgPrice", model.OrgPrice);
            parameters.Add("v_Owner", model.OwnerCd);
            parameters.Add("v_Driver", model.DriverCd);
            parameters.Add("v_EngineNo", model.EngineNo);
            parameters.Add("v_ChassisNo", model.ChassisNo);
            parameters.Add("v_PlateColor", model.PlateColorCd);
            parameters.Add("v_RegnNo", model.RegnNo);
            parameters.Add("v_RegnFrmDt", model.RegnFrmDt);
            parameters.Add("v_RegnExpDt", model.RegnExpDt);
            parameters.Add("v_State", model.StateCd);
            parameters.Add("v_PetrolCard", model.PetrolCard);
            parameters.Add("v_PetrolCardAmt", model.PetrolCardAmt);
            parameters.Add("v_InsCo", model.InsCo);
            parameters.Add("v_InsPolicyNo", model.InsPolicyNo);
            parameters.Add("v_InsAmt", model.InsAmt);
            parameters.Add("v_InsPrem", model.InsPrem);
            parameters.Add("v_InsFrmDt", model.InsFrmDt);
            parameters.Add("v_InsExpDt", model.InsExpDt);
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse DeleteVehicle(string cd)
        {
            var procedureName = "CompanyVehicle_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<VehDocuments_GetRow_Result> GetVehicleDocuments(string vehCd)
        {
            var procedureName = "VehDocuments_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_VehCd", vehCd);
            parameters.Add("v_DocTyp", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<VehDocuments_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveVehicleDocument(VehDocumentModel model)
        {
            var procedureName = "VehDocuments_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_VehCd", model.VehCd);
            parameters.Add("v_DocTyp", model.DocTypCd);
            parameters.Add("v_DocNo", model.DocNo);
            parameters.Add("v_OthRefNo", model.OthRefNo); // NOTE: does n't exists in TelconHRP database
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_IssueDt", model.IssueDt);
            parameters.Add("v_IssuePlace", model.IssuePlace);
            parameters.Add("v_ExpDt", model.ExpDt);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public int GetVehicleDocument_SrNo(string vehCd, string docType)
        {
            var procedureName = "VehDocuments_GetSrNo";
            var parameters = new DynamicParameters();
            parameters.Add("v_VehCd", vehCd);
            parameters.Add("v_DocTyp", docType);
            parameters.Add("v_SrNo", 0);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse DeleteVehicleDocument(string vehCd, string docType)
        {
            var procedureName = "VehDocuments_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_VehCd", vehCd);
            parameters.Add("v_DocTyp", docType);
            parameters.Add("v_SrNo", 0);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<VehDocImages_GetRow_Result> GetVehicleDocumentFiles(string vehCd)
        {
            var procedureName = "VehDocImages_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_VehCd", vehCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<VehDocImages_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveVehicleDocumentFile(CompDocImageModel model)
        {
            var procedureName = "VehDocImages_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_VehCd", model.VehCd);
            parameters.Add("v_DocTyp", model.DocumentTypeCd);
            parameters.Add("v_SlNo", model.SlNo);
            parameters.Add("v_ImageFile", model.ImageFile);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public CommonResponse DeleteVehicleDocumentFile(string vehCd, string docType, int slNo)
        {
            var procedureName = "VehDocImages_Delete_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_VehCd", vehCd);
            parameters.Add("v_DocTyp", docType);
            parameters.Add("v_SlNo", slNo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        #endregion

        #region Designation
        public IEnumerable<Designation_GetRow_Result> GetDesignations()
        {
            var procedureName = "Designation_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Designation_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveDesignation(DesignationModel model)
        {
            var procedureName = "Designation_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Cd);
            parameters.Add("v_SDes", model.SDes);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteDesignation(string Cd)
        {
            var procedureName = "Designation_Delete_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public string GetDesignation_SrNo()
        {
            //var query = $"SELECT 'DESG' + CAST(MAX(CAST(REPLACE(LTRIM(RTRIM(Cd)), 'DESG', '') AS INT)) + 1 AS VARCHAR) AS NextCode FROM Designation;";
            var query = $"SELECT 'DESG'+right('000'+ convert(varchar(3),isnull(Max(substring(cd,5,len(trim(cd)))),0)+1),3)  AS NextCode FROM Designation";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (query);
            return data;
        }
        #endregion

        #region Leave Type
        public IEnumerable<CompanyLeave_GetRow_Result> GetLeaveTypes(string CoCd)
        {
            var procedureName = "CompanyLeave_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyLeave_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveLeaveType(CompanyLeaveModel model, string Cocd)
        {
            var procedureName = "CompanyLeave_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Cd);
            parameters.Add("v_SDes", model.SDes);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_ApprLvl", model.ApprLvl);
            parameters.Add("v_LvMax", model.LvMax);
            parameters.Add("v_Accrued", model.Accrued ? "Y" : "N");
            parameters.Add("v_Encash", model.EnCash ? "Y" : "N");
            parameters.Add("v_EncashMinLmt", model.EnCashMinLmt);
            parameters.Add("v_PayFact", model.PayFact);
            parameters.Add("v_AccrLmt", model.AccrLmt);
            parameters.Add("v_Service", model.ServicePrd ? "Y" : "N");
            parameters.Add("v_CoCd", Cocd);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            parameters.Add("v_Active", model.Active);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteLeaveType(string Cd)
        {
            var procedureName = "CompanyLeave_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Leave Pay Component
        public IEnumerable<CompanyLeavePay_GetRow_Result> GetLeavePayComponents(string CoCd)
        {
            var procedureName = "CompanyLeavePay_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_LvCd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyLeavePay_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveLeavePayComponent(CompanyLeavePayModel model, string CoCd)
        {
            var procedureName = "CompanyLeavePay_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_PayTyp", model.PayTypCd);
            parameters.Add("v_PayCd", model.PayCd);
            parameters.Add("v_LvCd", model.LvCd);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteLeavePayComponent(string lvCd, string payTypCd, string payCd, string CoCd)
        {
            var procedureName = "CompanyLeavePay_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("@v_CoCd", CoCd);
            parameters.Add("@v_PayTyp", payTypCd);
            parameters.Add("@v_PayCd", payCd);
            parameters.Add("@v_LvCd", lvCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Travel Fare
        public IEnumerable<AirFare_GetRow_Result> GetTravelFares()
        {
            var procedureName = "AirFare_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_SectCd", string.Empty);
            parameters.Add("v_Class", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<AirFare_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveTravelFare(AirFareModel model)
        {
            var procedureName = "AirFare_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_SectCd", model.SectCd);
            parameters.Add("v_Class", model.ClassCd);
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_FromDt", model.FromDate);
            parameters.Add("v_ToDt", model.ToDate);
            parameters.Add("v_SDes", model.SDes);
            parameters.Add("v_Fare", model.Fare);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteTravelFare(int cd, string sectCd, string classCd)
        {
            var procedureName = "AirFare_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_SectCd", sectCd);
            parameters.Add("v_Class", classCd);
            parameters.Add("v_SrNo", cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public int GetTravelFare_SrNo(string sectCd, string classCd)
        {
            var procedureName = "AirFare_SrNo_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_SectCd", sectCd);
            parameters.Add("v_Class", classCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion

        #region Approval Process
        public IEnumerable<CompanyProcessApproval_GetRow> GetApprovalProcesses(string CoCd)
        {
            var procedureName = "CompanyProcessApproval_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_ProcessId", "0");
            parameters.Add("v_ApplTyp", "0");
            parameters.Add("v_Div", "0");
            parameters.Add("v_Dept", "0");
            parameters.Add("v_typ", "0");
            parameters.Add("v_Usercd", _loggedInUser.UserLinkedTo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyProcessApproval_GetRow>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CompanyProcessApproval_GetRow GetApprovalProcess(string processIdCd, string applTypCd, string branchCd, string deptCd, string CoCd)
        {
            var procedureName = "CompanyProcessApproval_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_ProcessId", processIdCd);
            parameters.Add("v_ApplTyp", applTypCd);
            parameters.Add("v_Div", branchCd);
            parameters.Add("v_Dept", deptCd);
            parameters.Add("v_typ", "1");
            parameters.Add("v_Usercd", _loggedInUser.UserLinkedTo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<CompanyProcessApproval_GetRow>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<CompanyProcessApproval_Detail_GetRow_Result> GetCompanyProcessApproval_Detail(string processIdCd, string applTypCd, string branchCd, string deptCd, string CoCd)
        {
            var procedureName = "CompanyProcessApproval_Detail_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_ProcessId", processIdCd);
            parameters.Add("v_ApplTyp", applTypCd);
            parameters.Add("v_Div", branchCd);
            parameters.Add("v_Dept", deptCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyProcessApproval_Detail_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveApprovalProcess(CompanyProcessApprovalModel model, string CoCd)
        {
            var procedureName = "CompanyProcessApproval_Update_N";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var parameters = new DynamicParameters();
            parameters.Add("v_ProcessId", model.ProcessIdCd);
            parameters.Add("v_ApplTyp", model.ApplTypCd);
            parameters.Add("v_Div", model.BranchCd ?? "0");
            parameters.Add("v_Dept", model.DeptCd ?? "0");
            parameters.Add("v_CoCd", CoCd);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void SaveApprovalProcess_Detail(CompanyProcessApprovalModel model, int srNo, string empCd, string CoCd)
        {
            var procedureName = "CompanyProcessApproval_Detail_Insert_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_ProcessId", model.ProcessIdCd);
            parameters.Add("v_ApplTyp", model.ApplTypCd);
            parameters.Add("v_Div", model.BranchCd ?? "0");
            parameters.Add("v_Dept", model.DeptCd ?? "0");
            parameters.Add("v_SrNo", srNo);
            parameters.Add("v_EmpCd", empCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public CommonResponse DeleteApprovalProcess(string processId, string applTyp, string branchCd, string deptCd, string CoCd)
        {
            var procedureName = "CompanyProcessApproval_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_ProcessId", processId);
            parameters.Add("v_ApplTyp", applTyp);
            parameters.Add("v_Div", branchCd);
            parameters.Add("v_Dept", deptCd);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteCompanyProcessApproval_Detail(string processId, string applTyp, string branchCd, string deptCd, string CoCd)
        {
            var procedureName = "CompanyProcessApproval_Detail_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_ProcessId", processId);
            parameters.Add("v_ApplTyp", applTyp);
            parameters.Add("v_Div", branchCd ?? "0");
            parameters.Add("v_Dept", deptCd ?? "0");
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<CompanyProcessApproval_Type_GetRow_Result> GetProcessApprovalTypes(string CoCd)
        {
            var procedureName = "CompanyProcessApproval_Type_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyProcessApproval_Type_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<CompanyProvisions_GetRow_Result> GetCompanyProvisions()
        {
            var procedureName = "CompanyProvisions_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyProvisions_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<CompanyFundTypes_GetRow_Result> GetCompanyFundTypes()
        {
            var procedureName = "CompanyFundTypes_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyFundTypes_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<SelectListItem> GetDocumentTypeByType(string proccessId, string CoCd)
        {
            IEnumerable<SelectListItem> result = [];
            if (proccessId == "HRPSS2" || proccessId == "HRPSS3")
            {
                var leaveTypes = GetLeaveTypes(CoCd).Select(m => new SelectListItem
                {
                    Value = m.Cd.Trim(),
                    Text = m.SDes
                });
                result = leaveTypes;
            }
            else if (proccessId == "HRPSS1")
            {
                var loanTypes = GetLoanTypes().Select(m => new SelectListItem
                {
                    Value = m.Cd.Trim(),
                    Text = m.Sdes
                });
                result = loanTypes;
            }
            else if (proccessId == "HRPT6")
            {
                var empProgressions = _commonService.GetSysCodes(SysCode.EmpProgression).Select(m => new SelectListItem
                {
                    Value = m.Cd.Trim(),
                    Text = m.SDes
                });
                result = empProgressions;
            }
            else if (proccessId == "HRPT14")
            {
                var provisions = GetCompanyProvisions().Select(m => new SelectListItem
                {
                    Value = m.Cd.Trim(),
                    Text = m.SDes
                });
                result = provisions;
            }
            else if (proccessId == "HRPT8")
            {
                var docTypes = _commonService.GetCodesGroups(CodeGroup.EmpDocType).Select(m => new SelectListItem
                {
                    Value = m.Code.Trim(),
                    Text = m.ShortDes
                });
                result = docTypes;
            }
            else if (proccessId == "HRPSS4")
            {
                var fundTypes = GetCompanyFundTypes().Select(m => new SelectListItem
                {
                    Value = m.Cd.Trim(),
                    Text = m.Des
                });
                result = fundTypes;
            }
            return result;
        }
        #endregion
    }
}