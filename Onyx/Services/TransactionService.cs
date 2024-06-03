using Dapper;
using Onyx.Models.ViewModels;
using System.Data.SqlClient;
using System.Data;
using Onyx.Models.StoredProcedure;
using ExcelDataReader;

namespace Onyx.Services
{
    public class TransactionService(DbGatewayService dbGatewayService, AuthService authService, EmployeeService employeeService)
    {
        private readonly DbGatewayService _dbGatewayService = dbGatewayService;
        private readonly LoggedInUserModel _loggedInUser = authService.GetLoggedInUser();
        private readonly EmployeeService _employeeService = employeeService;

        #region Loan Application
        public CommonResponse SaveLoan(EmpLoanModel model)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLoan_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_TransDt", model.TransDt);
            parameters.Add("v_EmpCd", model.EmployeeCode);
            parameters.Add("v_LoanTyp", model.LoanTypeCd);
            parameters.Add("v_DocRef", string.Empty);
            parameters.Add("v_DocDt", DateTime.Now);
            parameters.Add("v_Amt", model.Amt);
            parameters.Add("v_Purpose", model.Purpose);
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_NoInstReq", model.NoInstReq);
            parameters.Add("v_Guarantor", model.GuarantorName);
            parameters.Add("v_GuarantorDetails", model.GuarantorDetails);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>
               (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public int GetEmpLoan_Due(string EmpCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLoan_Due";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", EmpCd);
            parameters.Add("v_Prd", string.Empty);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<int>
               (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public string GetNextToolTransNo(string CoCd, string tableId)
        {
            var procedureName = "Tool_Generate_No";
            var connectionString = _dbGatewayService.GetConnectionString();
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_TableId", tableId);
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpLoan_Approval_GetRow_Result> GetEmpLoanApprovalData(string EmpCd, string EmpUser, string CoCd)
        {
            var procedureName = "EmpLoan_Approval_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", string.Empty);
            parameters.Add("v_Typ", "0");
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", EmpCd);
            parameters.Add("v_EmpUser", EmpUser);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLoan_Approval_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpLoan_Disburse_GetRow_Result> GetEmpLoanDisburseData(string CoCd)
        {
            var procedureName = "EmpLoan_Disburse_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", string.Empty);
            parameters.Add("v_Typ", "0");
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLoan_Disburse_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpLoan_Adjustment_GetRow_Result> GetEmpLoanAdjustmentData(string CoCd)
        {
            var procedureName = "EmpLoan_Adjustment_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", string.Empty);
            parameters.Add("v_Typ", "0");
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLoan_Adjustment_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpLoanDetail_GetRow_Result> GetEmpLoanAdjDetail(string transNo, string status, string CoCd)
        {
            var procedureName = "EmpLoanDetail_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", transNo);
            parameters.Add("v_Typ", status);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLoanDetail_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveEmpLoanAdj(EmpLoanDetail_GetRow_Result model)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLoanDetail_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_EmpCd", model.EmpCd);
            parameters.Add("v_EdCd", model.EdCd);
            parameters.Add("v_EdTyp", model.EdTyp);
            parameters.Add("v_Typ", model.Typ);
            parameters.Add("v_RecoTyp", model.RecoTyp);
            parameters.Add("v_AmtVal", model.AmtVal);
            parameters.Add("v_ChgsAmt", model.ChgsAmt);
            parameters.Add("v_EffDate", model.EffDate);
            parameters.Add("v_EndDate", model.EndDate);
            parameters.Add("v_EditBy", model.EntryBy);
            parameters.Add("v_EditDt", DateTime.Now);
            var connection = new SqlConnection(connectionString);
            connection.QueryFirstOrDefault<CommonResponse>
              (procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteEmpLoanDetailsAdj(string transNo, string type)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLoanDetail_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", transNo);
            parameters.Add("v_Typ", type);
            var connection = new SqlConnection(connectionString);
            connection.QueryFirstOrDefault<CommonResponse>
              (procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public int GetEmpLoan_Due(string empCd, DateTime EffDt)
        {
            var procedureName = "EmpLoan_Due";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_Prd", EffDt);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpLoan_GetRow_Result> GetEmpLoanDetail(string transNo, string type, string EmpCd, string UserOrEmp, string CoCd)
        {
            var procedureName = "EmpLoan_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", transNo);
            parameters.Add("v_Typ", type);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", EmpCd);
            parameters.Add("v_EmpUser", UserOrEmp);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLoan_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveLoanApproval(EmpLoan_GetRow_Result model)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLoanAppr_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_ApprLvl", model.Current_Approval_Level);
            parameters.Add("v_ApprAmt", model.ApprAmt);
            parameters.Add("v_LoanApprBy", model.LoanApprBy);
            parameters.Add("v_LoanApprDt", model.LoanApprDt ?? DateTime.Now);
            parameters.Add("v_Status", model.LoanStatus);
            parameters.Add("v_ChgsPerc", model.ChgsPerc);
            parameters.Add("v_ChgsAmt", model.ChgsPerc);
            parameters.Add("v_RecoMode", model.RecoMode);
            parameters.Add("v_DedStartDt", model.DedStartDt ?? Convert.ToDateTime("01/01/1900"));
            parameters.Add("v_RecoPrd", model.Reco_Prd ?? "0");
            parameters.Add("v_NoInst", model.NoInst);
            parameters.Add("v_Guarantor", model.Guarantor);
            parameters.Add("v_GuarantorDetails", model.GuarantorDetails);
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_EntryDt", model.EntryDt);
            parameters.Add("v_EditBy", model.EntryBy);
            parameters.Add("v_EditDt", DateTime.Now);
            parameters.Add("v_ChgsTyp", model.ChgsTyp);
            var connection = new SqlConnection(connectionString);
            connection.QueryFirstOrDefault<CommonResponse>
              (procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void SaveEmpLoanDisbursement(EmpLoan_GetRow_Result model)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLoan_Disburse_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_LoanStatus", model.LoanStatus);
            parameters.Add("v_PayMode", model.PayMode);
            parameters.Add("v_HrDiv", model.EmpBranchCd);
            var connection = new SqlConnection(connectionString);
            connection.QueryFirstOrDefault<CommonResponse>
              (procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void Update_Loan_GeneralLedger(string empCd, decimal loanAmt, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "Update_Loan_GeneralLedger";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_LoanAmt", loanAmt);
            var connection = new SqlConnection(connectionString);
            connection.QueryFirstOrDefault<CommonResponse>
              (procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Leave Application
        public void SaveLeave(EmpLeaveModel model)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLeave_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_TransDt", model.TransDt);
            parameters.Add("v_EmpCd", model.EmployeeCode);
            parameters.Add("v_LvTyp", model.LeaveType);
            parameters.Add("v_FromDt", model.FromDt);
            parameters.Add("v_ToDt", model.ToDt);
            parameters.Add("v_LvTaken", model.LvTaken);
            parameters.Add("v_DocRef", string.Empty);
            parameters.Add("v_DocDt", DateTime.Now);
            parameters.Add("v_Substitute", string.Empty);
            parameters.Add("v_Reason", model.Reason);
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_LvInter", model.IntLocal);
            var connection = new SqlConnection(connectionString);
            connection.QueryFirstOrDefault<CommonResponse>
              (procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public bool ExistingLvApplication(string empCd, DateTime? fromDt, DateTime? endDt)
        {
            var procedureName = "VerifyExistingLvApplication_N";
            var parameters = new DynamicParameters();
            parameters.Add("EmpCd", empCd);
            parameters.Add("StartDt", fromDt);
            parameters.Add("EndDt", endDt);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<bool>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public int GetEmpMaxLeave(string CoCd, string LeaveType)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var query = $"select LvMax from CompanyLeaveDetail where CoCd='{CoCd}' and LvCd='{LeaveType}'";
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<int>
               (query);
            return result;
        }
        public string GetNextLeaveTransNo()
        {
            var procedureName = "EmpLeave_TransNo";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (procedureName, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpLeave_Approval_GetRow_Result> GetEmpLeaveApprovalData(string CoCd, string EmpCd, string EmpUserType)
        {
            var procedureName = "EmpLeave_Approval_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", string.Empty);
            parameters.Add("v_Typ", "3");
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", EmpCd);
            parameters.Add("v_EmpUser", EmpUserType);
            parameters.Add("v_Div", "0");
            parameters.Add("v_Dept", "0");
            parameters.Add("v_EmpCd1", string.Empty);
            parameters.Add("v_UserCd", _loggedInUser.UserLinkedTo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLeave_Approval_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpLeave_View_GetRow_Result> GetEmpLeaveData(string TransNo = "", string Type = "")
        {
            var procedureName = "EmpLeave_View_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", string.Empty);
            parameters.Add("v_TransNo", TransNo);
            parameters.Add("v_Typ", Type);
            parameters.Add("v_UserCd", _loggedInUser.UserLinkedTo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLeave_View_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public Employee_LeaveHistory_Detail GetEmployee_LeaveHistory(string empCd, DateTime FromDt, DateTime ToDt)
        {
            var procedureName = "Employee_LeaveHistory_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_FromDt", Convert.ToDateTime(FromDt).IsNotEmptyDate() ? FromDt.ToString(CommonSetting.InputDateFormat) : string.Empty); ;
            parameters.Add("v_ToDt", Convert.ToDateTime(ToDt).IsNotEmptyDate() ? ToDt.ToString(CommonSetting.InputDateFormat) : string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var multiResult = connection.QueryMultiple(procedureName, parameters, commandType: CommandType.StoredProcedure);
            var empLeaveDetail = multiResult.ReadFirstOrDefault<Employee_LeaveDetail>();
            var previousleavehistory = multiResult.Read<PreviousLeaveHistory>();
            var incomeDetails = multiResult.Read<IncomeDetails>();
            var outstanding = multiResult.ReadFirstOrDefault<OutstandingDetail>();
            var leaveApprovalDetail = multiResult.Read<LeaveApprovalDetails>();
            return new Employee_LeaveHistory_Detail
            {
                EmpLeaveDetail = empLeaveDetail,
                IncomeDetails = incomeDetails,
                LeaveApprovalDetails = leaveApprovalDetail,
                OutstandingDetail = outstanding,
                PreviousLeaveHistory = previousleavehistory
            };
        }
        public EmpLeave_Allowances_Result GetEmpLeave_Allowances(EmpLeaveConfirmModel model, string CoCd)
        {
            var procedureName = "EmpLeave_Allowances";
            var parameters = new DynamicParameters();
            parameters.Add("Empcd", model.EmpCd);
            parameters.Add("Wp_FromDt", model.WpFrom);
            parameters.Add("Wp_ToDt", model.WpTo);
            parameters.Add("Wop_FromDt", model.WopFrom);
            parameters.Add("Wop_ToDt", model.WopTo);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<EmpLeave_Allowances_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveLeaveApproval(EmpLeaveApprovalModel model)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLeaveAppr_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_ApprLvl", model.Current_Approval_Level);
            parameters.Add("v_LvApprDays", model.ApprDays);
            parameters.Add("v_LvApprBy", model.ApprBy);
            parameters.Add("v_LvApprDt", model.ApprDt);
            parameters.Add("v_Status", model.Status);
            parameters.Add("v_WP_FromDt", Convert.ToDateTime(model.WpFrom).IsNotEmptyDate() ? Convert.ToDateTime(model.WpFrom).ToString(CommonSetting.InputDateFormat) : CommonSetting.DeafultDate);
            parameters.Add("v_WP_ToDt", Convert.ToDateTime(model.WpTo).IsNotEmptyDate() ? Convert.ToDateTime(model.WpTo).ToString(CommonSetting.InputDateFormat) : CommonSetting.DeafultDate);
            parameters.Add("v_WOP_FromDt", Convert.ToDateTime(model.WopFrom).IsNotEmptyDate() ? Convert.ToDateTime(model.WopFrom).ToString(CommonSetting.InputDateFormat) : CommonSetting.DeafultDate);
            parameters.Add("v_WOP_ToDt", Convert.ToDateTime(model.WopTo).IsNotEmptyDate() ? Convert.ToDateTime(model.WopTo).ToString(CommonSetting.InputDateFormat) : CommonSetting.DeafultDate);
            parameters.Add("v_Narr", model.Remark);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Reason", model.Remark);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>
               (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public EmpLeaveSinglePayrollModel GetEmpAttendance_Salary_SinglePayroll(string empCd, string yearMonth, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpAttendance_Salary_SinglePayroll";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_Prd", yearMonth);
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            var multiResult = connection.QueryMultiple(procedureName, parameters, commandType: CommandType.StoredProcedure);
            var attendance = multiResult.Read<EmpAttendance_Salary_SinglePayroll_Result>();
            var basicComponents = multiResult.Read<EmpComponent_Salary_SinglePayroll_Result>();
            var components = multiResult.Read<EmpComponent_Salary_SinglePayroll_Result>();
            return new EmpLeaveSinglePayrollModel
            {
                Salary_SinglePayrollAttendanceData = attendance.ToList(),
                Component_SinglePayrollAttendanceData = basicComponents.Concat(components).ToList()
            };
        }
        public CommonResponse SaveLeaveConfirm(EmpLeaveConfirmModel model, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLeave_Confirm_Revise_Cancel_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Typ", model.Type);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_CancelBy", model.ApprBy);
            parameters.Add("v_CancelDt", model.ApprDt);
            parameters.Add("v_Remarks", model.Remark);
            parameters.Add("v_LvFare", model.Ticket);
            parameters.Add("v_LvSalary", model.LvSalary);
            parameters.Add("v_HrDiv", model.Branch);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>
               (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse SaveLeaveRevise(EmpLeaveConfirmModel model, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLeave_Revise_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Typ", model.LvTyp);
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_CancelBy", model.ApprBy);
            parameters.Add("v_CancelDt", model.ApprDt);
            parameters.Add("v_Remarks", model.Remark);
            parameters.Add("v_WP_FromDt", model.WpFrom);
            parameters.Add("v_WP_ToDt", model.WpTo);
            parameters.Add("v_WOP_FromDt", model.WopFrom);
            parameters.Add("v_WOP_ToDt", model.WopTo);
            parameters.Add("v_From_Dt", model.FromDt);
            parameters.Add("v_To_Dt", model.ToDt);
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>
               (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse SaveDutyResumption(EmpDutyResumptionModel model, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLeave_Resumption_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_EmpCd", model.EmpCd);
            parameters.Add("v_JoinDt", model.JoinDt);
            parameters.Add("v_Status", "J");
            parameters.Add("v_WP_FromDt", model.WpFrom);
            parameters.Add("v_WP_ToDt", model.WpTo);
            parameters.Add("v_WOP_FromDt", model.WopFrom);
            parameters.Add("v_WOP_ToDt", model.WopTo);
            parameters.Add("v_ToDt", model.JoinDt);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>
               (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse SaveLeaveProvision(EmpDutyResumptionModel model, string provType)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLeaveProvisions_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_FromDt", model.FromDt);
            parameters.Add("v_ProvTyp", provType);
            parameters.Add("v_ToDt", model.ToDt);
            parameters.Add("v_EmpCd", model.EmpCd);
            parameters.Add("v_WP_WOP_Flg", "1");
            parameters.Add("v_Prov_Flg", "1");
            parameters.Add("v_Narr", string.Empty);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>
               (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        #endregion

        #region Leave Salary Application
        public void SaveLeaveSalary(EmpLeaveSalaryModel model)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLeaveSalary_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_TransDt", model.TransDt);
            parameters.Add("v_EmpCd", model.EmployeeCode);
            parameters.Add("v_LvSalary", model.LvSalary);
            parameters.Add("v_LvTicket", model.LvTicket);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connection = new SqlConnection(connectionString);
            connection.Query<CommonResponse>
              (procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public string GetNextLeaveSalaryTransNo()
        {
            var procedureName = "EmpLeaveSalaryTicket_TransNo";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (procedureName, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpLeaveSalaryTicket_Approval_GetRow_Result> GetEmpLeaveSalaryApprovalData(string EmpCd, string EmpOrUser, string CoCd)
        {
            var procedureName = "EmpLeaveSalaryTicket_Approval_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", string.Empty);
            parameters.Add("v_Typ", "3");
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", EmpCd);
            parameters.Add("v_EmpUser", EmpOrUser);
            parameters.Add("v_Usercd", _loggedInUser.UserLinkedTo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLeaveSalaryTicket_Approval_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveLeaveSalaryApproval(EmpLeaveSalaryApprovalModel model)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLeaveSalaryAppr_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_ApprLvl", model.ApprLvl);
            parameters.Add("v_LvApprBy", model.ApprBy);
            parameters.Add("v_LvApprDt", model.TransDt);
            parameters.Add("v_Status", model.Status);
            parameters.Add("v_LvSalary", model.LvSalary);
            parameters.Add("v_LvTicket", model.LvTicket);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connection = new SqlConnection(connectionString);
            connection.Query<CommonResponse>
              (procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<EmpLeaveSalaryTicket_View_Getrow_Result> GetEmpLeaveSalaryDisburseData()
        {
            var procedureName = "EmpLeaveSalaryTicket_View_Getrow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", string.Empty);
            parameters.Add("v_Typ", string.Empty);
            parameters.Add("v_EmpCd", string.Empty);
            parameters.Add("v_Usercd", _loggedInUser.UserLinkedTo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLeaveSalaryTicket_View_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveLeaveSalaryDisburse(EmpLeaveSalaryDisburseModel model, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLeaveSalaryTicket_Confirm_Revise_Cancel_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Typ", model.Status);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_CancelBy", model.ApprBy);
            parameters.Add("v_CancelDt", DateTime.Now);
            parameters.Add("v_Remarks", model.Remarks);
            parameters.Add("v_LvFare", model.LvTicket);
            parameters.Add("v_LvSalary", model.LvSalary);
            parameters.Add("v_Disburse", "Y");
            var connection = new SqlConnection(connectionString);
            connection.Query<CommonResponse>
              (procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Fund Request Application
        public void SaveFundRequest(EmployeeFundModel model)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmployeeFund_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_TransDt", model.TransDt);
            parameters.Add("v_EmpCd", model.EmployeeCode);
            parameters.Add("v_Amount", model.Amount);
            parameters.Add("v_Typ", model.Type);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connection = new SqlConnection(connectionString);
            connection.Query<CommonResponse>
              (procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public string GetNextEmpFund_TransNo()
        {
            var procedureName = "EmpFund_TransNo";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (procedureName, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpFund_Approval_GetRow_Result> GetEmpFundApprovalData(string EmpCd, string EmpUser, string CoCd)
        {
            var procedureName = "EmpFund_Approval_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", string.Empty);
            parameters.Add("v_Typ", "3");
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", EmpCd);
            parameters.Add("v_EmpUser", EmpUser);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpFund_Approval_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpFund_View_Getrow_Result> GetEmpFundDisburseData(string transNo)
        {
            var procedureName = "EmpFund_View_Getrow";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", string.Empty);
            parameters.Add("v_TransNo", transNo);
            parameters.Add("v_Typ", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpFund_View_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveEmpFundApproval(EmpFund_Approval_GetRow_Result model)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpFundAppr_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_ApprLvl", model.Current_Approval_Level);
            parameters.Add("v_ApprBy", model.ApprBy);
            parameters.Add("v_ApprDt", model.ApprDate ?? DateTime.Now);
            parameters.Add("v_Status", model.Status);
            parameters.Add("v_Typ", model.Typ);
            parameters.Add("v_Amount", model.Amount);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void SaveEmpFundConfirm(EmpFund_View_Getrow_Result model, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpFund_Confirm_Revise_Cancel_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Typ", model.Status);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_CancelBy", model.ApprBy);
            parameters.Add("v_CancelDt", DateTime.Now);
            parameters.Add("v_Remarks", model.Remarks);
            parameters.Add("v_LvSalary", model.Status == "0" ? model.Amount : 0);
            parameters.Add("v_Disburse", "Y");
            parameters.Add("v_Appltyp", model.Type);
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Emp Transfer
        public IEnumerable<EmpTransfers_GetRow_Result> GetEmpTransferData(string userCd)
        {
            var procedureName = "EmpTransfers_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Srno", 0);
            parameters.Add("v_EmpCd", string.Empty);
            parameters.Add("v_Usercd", userCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpTransfers_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveEmpTransfer(EmpTransferModel model)
        {
            var procedureName = "EmpTransfers_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Empcd", model.EmpCd);
            parameters.Add("v_Srno", model.SrNo);
            parameters.Add("v_TransferDt", model.TransferDt);
            parameters.Add("v_DeptFr", model.DeptFrom);
            parameters.Add("v_DeptTo", model.DeptTo);
            parameters.Add("v_LocFr", model.LocFrom);
            parameters.Add("v_LocTo", model.LocTo);
            parameters.Add("v_BrFr", model.BrFrom);
            parameters.Add("v_BrTo", model.BrTo);
            parameters.Add("v_BU_From", model.BrFrom);
            parameters.Add("v_BU_To", model.BrTo);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Narr", model.Narration);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteEmpTransfer(string EmpCd, int SrNo)
        {
            var procedureName = "EmpTransfers_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Empcd", EmpCd);
            parameters.Add("v_Srno", SrNo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public int GetEmpTransferSrNo(string EmpCd)
        {
            var procedureName = "EmpTransfer_SrNo_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Empcd", EmpCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<int>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        #endregion

        #region Emp Provision Adjustment
        public IEnumerable<Empprovisionsadj_GetRow_Result> GetEmpProvisionAdjData(string transNo, string type, string empCd, string empUser)
        {
            var procedureName = "Empprovisionsadj_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", transNo);
            parameters.Add("v_Typ", type);
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_EmpUser", empUser);
            parameters.Add("v_Usercd", _loggedInUser.UserLinkedTo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Empprovisionsadj_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public string GetEmpProvisionAdjSrNo()
        {
            var procedureName = "Empprovisionsadj_TransNo";
            var parameters = new DynamicParameters();
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<string>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse SaveEmpProvisionAdj(EmpprovisionsadjModel model)
        {
            var procedureName = "Empprovisionsadj_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_TransDt", model.TransDt);
            parameters.Add("v_EmpCd", model.EmpCd);
            parameters.Add("v_ProvTyp", model.ProvTyp);
            parameters.Add("v_Days", model.Days);
            parameters.Add("v_Amt", model.Amt);
            parameters.Add("v_Purpose", model.Purpose);
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }

        public CommonResponse SetEmpprovisionsadjAppr(EmpprovisionsadjModel model)
        {
            var procedureName = "EmpprovisionsadjAppr_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_ApprLvl", model.CurrentApprovalLevel);
            parameters.Add("v_ApprBy", model.ApprBy);
            parameters.Add("v_ApprDt", model.ApprDt);
            parameters.Add("v_Status", "A");
            parameters.Add("v_Narr", model.Remarks);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteEmpProvisionAdj(string transNo)
        {
            var procedureName = "Empprovisionsadj_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", transNo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Emp Monthly Attendance
        public IEnumerable<EmpAttendance_Getrow_Result> GetEmpAttendanceData(AttendanceFilterModel model, string CoCd)
        {
            var procedureName = "EmpAttendance_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", model.EmpCd ?? string.Empty);
            parameters.Add("v_DivCd", model.Branch ?? string.Empty);
            parameters.Add("v_DeptCd", model.Department ?? string.Empty);
            parameters.Add("v_Prd", model.MonthYear);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpAttendance_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void UpdateEmpMonthlyAttendance(EmpAttendance_Getrow_Result model, AttendanceFilterModel filterModel)
        {
            var procedureName = "EmpAttendance_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", model.Cd);
            parameters.Add("v_Prd", filterModel.MonthYear);
            parameters.Add("v_Div", filterModel.Branch);
            parameters.Add("v_Dept", filterModel.Department);
            parameters.Add("v_NHrs", model.NHrs);
            parameters.Add("v_W_OT", model.W_OT);
            parameters.Add("v_H_OT", model.H_OT);
            parameters.Add("v_W_Days", model.W_days);
            parameters.Add("v_P_HDays", model.P_HDays);
            parameters.Add("v_Up_HDays", model.Up_HDays);
            parameters.Add("v_EntryBy", filterModel.EntryBy);
            parameters.Add("v_TrnInd", "S");
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.QueryFirstOrDefault(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteEmpAttendance(string empCd, string period, string branch)
        {
            var procedureName = "EmpAttendance_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd ?? string.Empty);
            parameters.Add("v_Prd", period);
            parameters.Add("v_Div", branch);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public bool ValidHeaderAttendanceExcel(IFormFile file)
        {
            var result = true;
            using var stream = file.OpenReadStream();
            using var reader = ExcelReaderFactory.CreateReader(stream);
            reader.Read();
            var headers = new List<string>();
            for (int i = 0; i < reader.FieldCount; i++)
                headers.Add(Convert.ToString(reader.GetValue(i)));
            headers = headers.Where(m => !string.IsNullOrEmpty(m)).ToList();
            var expectedHeaders = new List<string> { "Employee Code", "Unpaid", "W.OT", "H.OT" };
            var expectedHeaders2 = new List<string> { "Employee Code", "Unpaid" };
            if (!headers.SequenceEqual(expectedHeaders) && !headers.SequenceEqual(expectedHeaders2))
                result = false;
            return result;
        }
        public IEnumerable<EmpAttendance_Getrow_Result> GetAttendanceFromExcel(IFormFile file, string CoCd)
        {
            using var stream = file.OpenReadStream();
            using var reader = ExcelReaderFactory.CreateReader(stream);
            var result = new List<EmpAttendance_Getrow_Result>();
            reader.Read();
            while (reader.Read())
            {
                bool isEmptyRow = true;
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    if (!reader.IsDBNull(i) && !string.IsNullOrWhiteSpace(Convert.ToString(reader.GetValue(i))))
                    {
                        isEmptyRow = false;
                        break;
                    }
                }
                if (isEmptyRow)
                    continue;
                var empCd = Convert.ToString(reader.GetValue(0));
                bool validEmployee = _employeeService.FindEmployee(empCd, CoCd) != null;
                string errorMessage = "<ul class='text-left ml-0'>";
                int? WOT = reader.GetValue(2) != null ? Convert.ToInt32(reader.GetValue(2)) : null;
                int? HOT = reader.GetValue(3) != null ? Convert.ToInt32(reader.GetValue(3)) : null;
                if (!validEmployee)
                    errorMessage += "<li>Employee Code is empty or not valid</li>";
                if (!int.TryParse(Convert.ToString(reader.GetValue(1)), out int Up_HDays))
                    errorMessage += "<li>No of Unpaid Days is not valid</li>";
                if (WOT != null && HOT != null)
                {
                    if (!int.TryParse(Convert.ToString(reader.GetValue(2)), out int W_OT))
                        errorMessage += "<li>W.OT is not valid</li>";
                    if (!int.TryParse(Convert.ToString(reader.GetValue(3)), out int H_OT))
                        errorMessage += "<li>H.OT is not valid</li>";
                }
                errorMessage += "</ul>";
                var excelData = new EmpAttendance_Getrow_Result
                {
                    IsValid = validEmployee,
                    ErrorMessage = errorMessage,
                    Cd = empCd,
                    Up_HDays = Up_HDays,
                    W_OT = WOT,
                    H_OT = HOT,
                };
                result.Add(excelData);
            }
            return result;
        }
        public void ImportAttendanceExcelData(IEnumerable<EmpAttendance_Getrow_Result> excelData, AttendanceFilterModel filterModel)
        {
            var spYearMonth = filterModel.MonthYear.Split("/");
            filterModel.MonthYear = $"{spYearMonth[1]}{spYearMonth[0]}";
            int lastDayOfMonth = DateTime.DaysInMonth(Convert.ToInt32(spYearMonth[1]), Convert.ToInt32(spYearMonth[0]));
            foreach (var item in excelData)
            {
                item.W_days = lastDayOfMonth;
                item.NHrs = Convert.ToInt32((item.W_days - item.Up_HDays - item.P_HDays) * float.Parse(filterModel.WorkingHrDay));
                item.Payable = item.W_days - item.Up_HDays;
                UpdateEmpMonthlyAttendance(item, filterModel);
            }
        }
        #endregion

        #region Variable PayDed Components
        public IEnumerable<EmpTrans_VarCompFixAmt_GetRow_Result> GetVariablePayDedComponents(VariablePayDedComponentFilterModel model)
        {
            var procedureName = "EmpTrans_VarCompFixAmt_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("DivCd", model.Branch);
            parameters.Add("CCCd", "0");
            parameters.Add("DeptCd", model.Department ?? string.Empty);
            parameters.Add("v_EdCd", model.PayCode);
            parameters.Add("v_EdTyp", model.PayType);
            parameters.Add("v_FromDt", model.FromDt);
            parameters.Add("v_ToDt", model.ToDt);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpTrans_VarCompFixAmt_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void DeleteEmpTrans(string empCd, string PayCode, string PayType, string Branch)
        {
            var procedureName = "EmpTrans_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_EdCd", PayCode);
            parameters.Add("v_EdTyp", PayType);
            parameters.Add("v_Div", Branch ?? "0");
            parameters.Add("v_DocRef", string.Empty);
            parameters.Add("v_Empcd", empCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void EmpTrans_Update(EmpTrans_VarCompFixAmt_GetRow_Result model, VariablePayDedComponentFilterModel filterModel)
        {
            var procedureName = "EmpTrans_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", model.Cd.Trim());
            parameters.Add("v_EdCd", filterModel.PayCode);
            parameters.Add("v_EdTyp", filterModel.PayType);
            parameters.Add("v_DocRef", string.Empty);
            parameters.Add("v_Curr", model.Curr);
            parameters.Add("v_ExRate", 1);
            parameters.Add("v_Amt", model.Amt);
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", filterModel.EntryBy);
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_FromDt", filterModel.FromDt);
            parameters.Add("v_ToDt", filterModel.ToDt);
            parameters.Add("v_TrnInd", model.TransId);
            parameters.Add("v_EmpDiv", filterModel.Branch);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<EmpTrans_VarCompFixAmt_GetRow_Result> GetVariablePayComponentFromExcel(IFormFile file, string CoCd)
        {
            using var stream = file.OpenReadStream();
            using var reader = ExcelReaderFactory.CreateReader(stream);
            var result = new List<EmpTrans_VarCompFixAmt_GetRow_Result>();
            reader.Read();
            int cnt = 1;
            while (reader.Read())
            {
                bool isEmptyRow = true;
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    if (!reader.IsDBNull(i) && !string.IsNullOrWhiteSpace(Convert.ToString(reader.GetValue(i))))
                    {
                        isEmptyRow = false;
                        break;
                    }
                }
                if (isEmptyRow)
                    continue;
                var empCd = Convert.ToString(reader.GetValue(0));
                bool validEmployee = _employeeService.FindEmployee(empCd, CoCd) != null;
                string errorMessage = "<ul class='text-left ml-0'>";
                if (!validEmployee)
                    errorMessage += "<li>Employee Code is empty or not valid</li>";
                if (!int.TryParse(Convert.ToString(reader.GetValue(1)), out int amt))
                    errorMessage += "<li>Amount is not valid</li>";
                errorMessage += "</ul>";
                var excelData = new EmpTrans_VarCompFixAmt_GetRow_Result
                {
                    IsValid = validEmployee,
                    ErrorMessage = errorMessage,
                    Cd = empCd,
                    Amt = amt,
                    SrNo = cnt
                };
                result.Add(excelData);
                cnt++;
            }
            return result;
        }
        public bool ValidHeaderVariblePayComponentsExcel(IFormFile file)
        {
            var result = true;
            using var stream = file.OpenReadStream();
            using var reader = ExcelReaderFactory.CreateReader(stream);
            reader.Read();
            var headers = new List<string>();
            for (int i = 0; i < reader.FieldCount; i++)
                headers.Add(Convert.ToString(reader.GetValue(i)));
            headers = headers.Where(m => !string.IsNullOrEmpty(m)).ToList();
            var expectedHeaders = new List<string> { "Employee Code", "Amount" };
            if (!headers.SequenceEqual(expectedHeaders))
                result = false;
            return result;
        }
        public void ImportVariablePayComponentExcelData(IEnumerable<EmpTrans_VarCompFixAmt_GetRow_Result> excelData, VariablePayDedComponentFilterModel filterModel, string CoCd)
        {
            if (!string.IsNullOrEmpty(filterModel.MonthYear))
            {
                var spYearMonth = filterModel.MonthYear.Split("/");
                int month = Convert.ToInt32(spYearMonth[0]);
                int year = Convert.ToInt32(spYearMonth[1]);
                int lastDayOfMonth = DateTime.DaysInMonth(year, month);
                filterModel.FromDt = new DateTime(year, month, 1);
                filterModel.ToDt = new DateTime(year, month, lastDayOfMonth);
            }
            foreach (var item in excelData)
            {
                var employeeDetail = _employeeService.FindEmployee(item.Cd, CoCd); item.Curr = employeeDetail.BasicCurr.Trim();
                item.Narr = $"Variable Pay Component {item.Curr}: {item.Amt}";
                item.TransId = "M";
                EmpTrans_Update(item, filterModel);
            }
        }
        #endregion

        #region Doc Renewal
        public int EmpDocIssueRcpt_NextSrNo(string EmpCd, string type)
        {
            var procedureName = "EmpDocIssueRcpt_NextSrNo";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", EmpCd);
            parameters.Add("v_DocTyp", type);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public int ComDocIssueRcpt_NextSrNo(string CoCd, string type)
        {
            var procedureName = "CompDocIssueRcpt_NextSrNo";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_DocTyp", type);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public int VehDocIssueRcpt_NextSrNo(string VehCd, string type)
        {
            var procedureName = "VehDocIssueRcpt_NextSrNo";
            var parameters = new DynamicParameters();
            parameters.Add("v_VehCd", VehCd);
            parameters.Add("v_DocTyp", type);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveEmpDocIssueReceipt(EmpDocumentModel model)
        {
            var trnTyp = model.DocStatus == "HDS0001" ? "R" : model.DocStatus == "HDS0002" ? "I" : "P";
            var procedureName = "EmpDocIssueRcpt_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_EmpCd", model.EmpCd);
            parameters.Add("v_DocTyp", model.DocTypCd);
            parameters.Add("v_DocNo", model.DocNo);
            parameters.Add("v_IssueDt", model.IssueDt);
            parameters.Add("v_IssuePlace", model.IssuePlace);
            parameters.Add("v_ExpDt", model.ExpDt);
            parameters.Add("v_TrnDt", DateTime.Now);
            parameters.Add("v_TransTyp", trnTyp);
            parameters.Add("v_DocStatus", model.DocStatus);
            parameters.Add("v_Status", "N");
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void SaveComDocIssueReceipt(CompanyDocumentModel model)
        {
            var trnTyp = model.DocStatus == "HDS0001" ? "R" : model.DocStatus == "HDS0002" ? "I" : "P";
            var procedureName = "CompDocIssueRcpt_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_CompCd", model.CompanyCd);
            parameters.Add("v_DocTyp", model.DocTypCd);
            parameters.Add("v_DocNo", model.DocNo);
            parameters.Add("v_IssueDt", model.IssueDt);
            parameters.Add("v_IssuePlace", model.IssuePlace);
            parameters.Add("v_ExpDt", model.ExpDt);
            parameters.Add("v_TrnDt", DateTime.Now);
            parameters.Add("v_TransTyp", trnTyp);
            parameters.Add("v_DocStatus", model.DocStatus);
            parameters.Add("v_Status", "N");
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void SaveVehDocIssueReceipt(VehDocumentModel model)
        {
            var trnTyp = model.DocStatus == "HDS0001" ? "R" : model.DocStatus == "HDS0002" ? "I" : "P";
            var procedureName = "VehDocIssueRcpt_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_VehCd", model.VehCd);
            parameters.Add("v_DocTyp", model.DocTypCd);
            parameters.Add("v_DocNo", model.DocNo);
            parameters.Add("v_IssueDt", model.IssueDt);
            parameters.Add("v_IssuePlace", model.IssuePlace);
            parameters.Add("v_ExpDt", model.ExpDt);
            parameters.Add("v_TrnDt", DateTime.Now);
            parameters.Add("v_TransTyp", trnTyp);
            parameters.Add("v_DocStatus", model.DocStatus);
            parameters.Add("v_Status", "N");
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<EmpDocIssueRcpt_GetRow_Result> GetEmpDocIssueRcpt(string empCd, string docTyp, int srNo, string LoginEmpCd, string EmpUser, string type)
        {
            var procedureName = "EmpDocIssueRcpt_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_DocTyp", docTyp);
            parameters.Add("v_Typ", type);
            parameters.Add("v_SrNo", srNo);
            parameters.Add("v_LoginEmpCd", LoginEmpCd);
            parameters.Add("v_EmpUser", EmpUser);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpDocIssueRcpt_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveEmpDocIssueRcptAppr(EmpDocIssueRcpt_GetRow_Result model)
        {
            var procedureName = "EmpDocIssueRcptAppr_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", model.EmployeeCode);
            parameters.Add("v_DocTyp", model.DocType);
            parameters.Add("v_SrNo", model.SrNo);
            parameters.Add("v_ApprLvl", model.Current_Approval_Level);
            parameters.Add("v_DocNo", model.DocNo);
            parameters.Add("v_IssueDt", model.IssueDt);
            parameters.Add("v_IssuePlace", model.IssuePlace);
            parameters.Add("v_ExpDt", model.ExpDt);
            parameters.Add("v_Status", model.Status);
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_EditBy", model.EntryBy);
            parameters.Add("v_ApprBy", model.ApprBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Pre Pay Roll Process
        public bool ValiatePrePayrollDeno(string type, string CoCd)
        {
            var procedureName = "Validate_Prepayroll";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Typ", type);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result != null;
        }
        #endregion

        #region Emp Monthly Incentive
        public void UpdateEmpSalesData(EmpTrans_VarCompFixAmt_GetRow_Result model, VariablePayDedComponentFilterModel filterModel)
        {
            var procedureName = "EmpIncSales_Update";
            var parameters = new DynamicParameters();
            parameters.Add("DivCd", filterModel.Branch);
            parameters.Add("v_FromDt", filterModel.FromDt);
            parameters.Add("v_ToDt", filterModel.ToDt);
            parameters.Add("v_Empcd", model.Cd);
            parameters.Add("v_SalAmt", model.Amt);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<EmpTrans_Incentives_GetRow_Result> GetEmpIncentiveData(IncentiveFilterModel model)
        {
            var procedureName = "EmpTrans_Incentives_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("DivCd", model.Branch ?? "0");
            parameters.Add("DeptCd", model.Designation ?? "0");
            parameters.Add("v_EdCd", string.Empty);
            parameters.Add("v_EdTyp", "HEDT01");
            parameters.Add("v_FromDt", model.FromDt);
            parameters.Add("v_ToDt", model.ToDt);
            parameters.Add("v_RPrd", model.Prd);
            parameters.Add("v_RYear", model.Year);
            parameters.Add("v_Empcd", model.EmpCd ?? string.Empty);
            parameters.Add("v_EmpTyp", model.EmpType ?? "0");
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpTrans_Incentives_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public bool ValidHeaderIncentiveExcel(IFormFile file)
        {
            var result = true;
            using var stream = file.OpenReadStream();
            using var reader = ExcelReaderFactory.CreateReader(stream);
            reader.Read();
            var headers = new List<string>();
            for (int i = 0; i < reader.FieldCount; i++)
                headers.Add(Convert.ToString(reader.GetValue(i)));
            headers = headers.Where(m => !string.IsNullOrEmpty(m)).ToList();
            var expectedHeaders = new List<string> { "Employee Code", "Sales Incentive", "Incentive", "Manager Incentive" };
            if (!headers.SequenceEqual(expectedHeaders))
                result = false;
            return result;
        }
        public IEnumerable<EmpTrans_Incentives_GetRow_Result> GetIncentiveFromExcel(IFormFile file, string CoCd)
        {
            using var stream = file.OpenReadStream();
            using var reader = ExcelReaderFactory.CreateReader(stream);
            var result = new List<EmpTrans_Incentives_GetRow_Result>();
            reader.Read();
            while (reader.Read())
            {
                bool isEmptyRow = true;
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    if (!reader.IsDBNull(i) && !string.IsNullOrWhiteSpace(Convert.ToString(reader.GetValue(i))))
                    {
                        isEmptyRow = false;
                        break;
                    }
                }
                if (isEmptyRow)
                    continue;
                var empCd = Convert.ToString(reader.GetValue(0));
                bool validEmployee = _employeeService.FindEmployee(empCd, CoCd) != null;
                string errorMessage = "<ul class='text-left ml-0'>";
                if (!validEmployee)
                    errorMessage += "<li>Employee Code is empty or not valid</li>";
                if (!int.TryParse(Convert.ToString(reader.GetValue(1)), out int salesIncentive))
                    errorMessage += "<li>Sales Incentive is not valid</li>";
                if (!int.TryParse(Convert.ToString(reader.GetValue(2)), out int incentive))
                    errorMessage += "<li>Incentive is not valid</li>";
                if (!int.TryParse(Convert.ToString(reader.GetValue(3)), out int managerIncentive))
                    errorMessage += "<li>Manager Incentive is not valid</li>";
                errorMessage += "</ul>";
                var excelData = new EmpTrans_Incentives_GetRow_Result
                {
                    IsValid = validEmployee,
                    ErrorMessage = errorMessage,
                    Cd = empCd,
                    SalesAmt = salesIncentive,
                    Amt = incentive,
                    Amt1 = managerIncentive
                };
                result.Add(excelData);
            }
            return result;
        }
        public void ImportIncentiveExcelData(IEnumerable<EmpTrans_Incentives_GetRow_Result> excelData, IncentiveFilterModel model)
        {
            var spYearMonth = model.MonthYear.Split("/");
            model.Prd = spYearMonth[0];
            model.Year = spYearMonth[1];
            int lastDayOfMonth = DateTime.DaysInMonth(Convert.ToInt32(model.Year), Convert.ToInt32(model.Prd));
            model.FromDt = new DateTime(Convert.ToInt32(model.Year), Convert.ToInt32(model.Prd), 1);
            model.ToDt = new DateTime(Convert.ToInt32(model.Year), Convert.ToInt32(model.Prd), lastDayOfMonth);
            var filterModel = new VariablePayDedComponentFilterModel
            {
                Branch = model.Branch ?? "0",
                Department = model.Designation ?? "0",
                EmpCd = model.EmpCd ?? string.Empty,
                FromDt = model.FromDt,
                ToDt = model.ToDt,
                PayType = "HEDT01",
                EntryBy = _loggedInUser.UserCd,
            };
            foreach (var item in excelData)
            {
                var employeeDetail = _employeeService.FindEmployee(item.Cd, _loggedInUser.CompanyCd);
                var data = new EmpTrans_VarCompFixAmt_GetRow_Result()
                {
                    Cd = item.Cd,
                    Curr = employeeDetail.BasicCurr.Trim(),
                    SrNo = item.SrNo,
                };
                for (int i = 0; i < 2; i++)
                {
                    if (i == 0)
                    {
                        filterModel.PayCode = "207";
                        data.Amt = item.Amt;
                    }
                    else
                    {
                        filterModel.PayCode = "MGRIN";
                        data.Amt = item.Amt1;
                    }
                    data.Narr = $"Variable Pay Component {data.Curr}: {data.Amt}";
                    data.TransId = "M";
                    EmpTrans_Update(data, filterModel);
                }
                data.Amt = item.SalesAmt;
                UpdateEmpSalesData(data, filterModel);
            }
        }
        #endregion

        #region Emp Progression
        public IEnumerable<EmpProgressionHead_GetRow_Result> GetEmpProgressionData(string transNo, string type, string empCd, string empUser)
        {
            var procedureName = "EmpProgressionHead_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", transNo);
            parameters.Add("v_Typ", type);
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_EmpUser", empUser);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpProgressionHead_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public EmpProgressionDetail_GetRow_Result GetEmpProgressionDetail(string transNo)
        {
            var procedureName = "EmpProgressionDetail_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", transNo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<EmpProgressionDetail_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void UpdateEmpProgHead(EmpProgressionHeadModel model)
        {
            var procedureName = "EmpProgressionHead_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_TransDt", model.TransDt);
            parameters.Add("v_EmpCd", model.EmpCode);
            parameters.Add("v_DesigFr", model.DesigFromCd);
            parameters.Add("v_DesigTo", model.DesigToCd);
            parameters.Add("v_ApprBy", model.ApprBy);
            parameters.Add("v_ApprDt", model.ApprDt);
            parameters.Add("v_Remarks", model.Remarks);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Status", "E");
            parameters.Add("v_Typ", model.EP_TypeCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void UpdateEmpProgDetail(EmpProgressionHeadModel model)
        {
            var procedureName = "EmpProgressionDetail_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_SrNo", "1");
            parameters.Add("v_EdCd", model.PayCodeCd);
            parameters.Add("v_EdTyp", model.PayTypCd);
            parameters.Add("v_EffDate", model.EffDt);
            parameters.Add("v_PercAmt", model.PercAmt);
            parameters.Add("v_Val", model.CurrentAmt);
            parameters.Add("v_ApprVal", model.RevisedAmt);
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void UpdateEmpProgAppr(EmpProgressionHeadModel model)
        {
            var procedureName = "EmpProgressionAppr_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_ApprLvl", model.Current_Approval_Level);
            parameters.Add("v_ApprBy", model.ApprBy);
            parameters.Add("v_ApprDt", model.ApprDt);
            parameters.Add("v_Status", "A");
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_EditBy", model.EntryBy);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public EmpEarnDed2_GetRow_Result GetCurrentAmt(string empCd, string edTypeDes, string edCdDes)
        {
            var procedureName = "EmpEarnDed2_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_EdTyp", edTypeDes);
            parameters.Add("v_EdCd", edCdDes);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<EmpEarnDed2_GetRow_Result>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteEmpPrgression(string transNo)
        {
            var procedureName = "EmpProgressionHead_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", transNo);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<EmpProgressionHeadModel> GetProgressionFromExcel(IFormFile file, string CoCd)
        {
            using var stream = file.OpenReadStream();
            using var reader = ExcelReaderFactory.CreateReader(stream);
            var result = new List<EmpProgressionHeadModel>();
            reader.Read();
            int cnt = 1;
            while (reader.Read())
            {
                bool isEmptyRow = true;
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    if (!reader.IsDBNull(i) && !string.IsNullOrWhiteSpace(Convert.ToString(reader.GetValue(i))))
                    {
                        isEmptyRow = false;
                        break;
                    }
                }
                if (isEmptyRow)
                    continue;
                var empCd = Convert.ToString(reader.GetValue(0));
                bool validEmployee = _employeeService.FindEmployee(empCd, CoCd) != null;
                string errorMessage = "<ul class='text-left ml-0'>";
                if (!validEmployee)
                    errorMessage += "<li>Employee Code is empty or not valid</li>";
                if (!int.TryParse(Convert.ToString(reader.GetValue(1)), out int amt))
                    errorMessage += "<li>Amount is not valid</li>";
                errorMessage += "</ul>";
                var excelData = new EmpProgressionHeadModel
                {
                    IsValid = validEmployee,
                    ErrorMessage = errorMessage,
                    EmpCode = empCd,
                    RevisedAmt = amt
                };
                result.Add(excelData);
                cnt++;
            }
            return result;
        }
        #endregion

        #region Emp Sepration
        public GetRepo_EmpFinalSettlement_Result GetEmpSeprationDetail(EmpSeprationFilterModel model)
        {
            var procedureName = "GetRepo_EmpFinalSettlement";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", model.EmpCd);
            parameters.Add("v_SepDt", model.SeprationDate);
            parameters.Add("v_SepTyp", model.SeprationType);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<GetRepo_EmpFinalSettlement_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion
        public EmplLoanAndLeaveHistory_Result GetEmployee_LeaveLoanHistory(string empCd)
        {
            var procedureName = "EmplLoanAndLeaveHistory_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var multiResult = connection.QueryMultiple(procedureName, parameters, commandType: CommandType.StoredProcedure);
            var empLoans = multiResult.Read<EmpLoan>();
            var empLeaves = multiResult.Read<EmpLeave>();
            return new EmplLoanAndLeaveHistory_Result
            {
                EmpLeaves = empLeaves,
                EmpLoans = empLoans
            };
        }
    }
}
