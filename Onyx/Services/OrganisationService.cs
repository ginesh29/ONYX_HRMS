using Dapper;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data.SqlClient;
using System.Data;

namespace Onyx.Services
{
    public class OrganisationService(CommonService commonService)
    {
        private readonly CommonService _commonService = commonService;
        #region Component
        public IEnumerable<CompanyEarnDed_GetRow_Result> GetComponents()
        {
            var procedureName = "CompanyEarnDed_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            parameters.Add("v_Typ", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyEarnDed_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveComponent(EarnDedModel model)
        {
            var procedureName = "CompanyEarnDed_Update";
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
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Loan Type
        public IEnumerable<CompanyLoanTypes_GetRow_Result> GetLoanTypes()
        {
            var procedureName = "CompanyLoanTypes_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyLoanTypes_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveLoanType(LoanTypeModel model)
        {
            var procedureName = "CompanyLoanTypes_Update";
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
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteLoanType(string Cd)
        {
            var procedureName = "CompanyLoanTypes_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyWHrs_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveWorkingHour(WorkingHourModel model, string CoCd)
        {
            var procedureName = "CompanyWHrs_Update";
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteWorkingHour(string Cd)
        {
            var procedureName = "CompanyWHrs_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyOvertimeRates_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveOvertimeRate(OvertimeRateModel model, string CoCd)
        {
            var procedureName = "CompanyOvertimeRates_Update";
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
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public int GetOvertimeRate_SrNo(string CoCd, string type)
        {
            var procedureName = "CompanyOTRatesSrNo1_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Typ", type);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion

        #region Calendar Event
        public IEnumerable<CompanyCalendar_GetRow_Result> GetCalendarEvents(string CoCd)
        {
            var procedureName = "CompanyCalendar_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyCalendar_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveCalendarEvent(CompanyCalendarModel model, string CoCd)
        {
            var procedureName = "CompanyCalendar_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Cd", model.Cd);
            parameters.Add("v_Date", model.Date);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_Holiday", model.Holiday);
            parameters.Add("v_MeetingLink", model.MeetingLink);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteCalendarEvent(string Cd)
        {
            var procedureName = "CompanyCalendar_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void SaveCalendarEventAttendees(string EventCd, List<string> EmpIds)
        {
            var connectionString = _commonService.GetConnectionString();
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
        #endregion

        #region Notification
        public IEnumerable<Notification_GetRow_Result> GetNotifications(string CoCd)
        {
            var procedureName = "Notification_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Notification_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveNotificationMaster(NotificationModel model, string CoCd)
        {
            var procedureName = "Notification_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_ProcessId", model.ProcessId);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_NoOfDays", model.NoOfDays);
            parameters.Add("v_BeforeOrAfter", model.BeforeOrAfter);
            parameters.Add("v_MessageBody", model.MessageBody);
            parameters.Add("v_DocTyp", model.DocTyp);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse SaveNotificationDetail(NotificationModel model, string EmailId, string CoCd)
        {
            var procedureName = "Notification_Detail_Insert";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_ProcessId", model.ProcessId);
            parameters.Add("v_DocTyp", model.DocTyp);
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_EmailIdCC", EmailId);
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyBank_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        //public CommonResponse SaveBank(BankModel model)
        //{
        //    var procedureName = "Bank_Update";
        //    var parameters = new DynamicParameters();
        //    parameters.Add("v_Cd", model.Code.Trim());
        //    parameters.Add("v_Des", model.Description);
        //    parameters.Add("v_CoCd", model.CoCd);
        //    parameters.Add("v_BU_Cd", "");
        //    parameters.Add("v_SDes", model.Name);
        //    parameters.Add("v_Image", model.Image ?? "");
        //    parameters.Add("v_EntryBy", model.EntryBy);
        //    parameters.Add("v_Mode", model.Mode);
        //    var connectionString = _commonService.GetConnectionString();
        //    var connection = new SqlConnection(connectionString);
        //    var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
        //    return result;
        //}
        //public void DeleteBank(string Cd, string CoCd)
        //{
        //    var procedureName = "Bank_Delete";
        //    var parameters = new DynamicParameters();
        //    parameters.Add("v_Cd", Cd);
        //    parameters.Add("v_CoCd", CoCd);
        //    var connectionString = _commonService.GetConnectionString();
        //    var connection = new SqlConnection(connectionString);
        //    connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        //}
        #endregion

        #region Document
        public IEnumerable<CompanyDocuments_GetRow_Result> GetDocuments(string CoCd)
        {
            var procedureName = "CompanyDocuments_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_DocTypCd", string.Empty);
            parameters.Add("v_DivCd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyDocuments_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion

        #region Vehicle
        public IEnumerable<CompanyVehicle_GetRow_Result> GetVehicles()
        {
            var procedureName = "CompanyVehicle_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyVehicle_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion

        #region Designation
        public IEnumerable<Designation_GetRow_Result> GetDesignations()
        {
            var procedureName = "Designation_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Designation_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyLeave_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion
    }
}