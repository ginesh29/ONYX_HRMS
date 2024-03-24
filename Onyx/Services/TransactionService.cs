using Dapper;
using Onyx.Models.ViewModels;
using System.Data.SqlClient;
using System.Data;
using Onyx.Models.StoredProcedure;
using ExcelDataReader;

namespace Onyx.Services
{
    public class TransactionService(CommonService commonService, EmployeeService employeeService)
    {
        private readonly CommonService _commonService = commonService;
        private readonly EmployeeService _employeeService = employeeService;

        #region Loan Application
        public CommonResponse SaveLoan(EmpLoanModel model)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "EmpLoan_Update";
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
        public int GetEmpLoan_Due(string EmpCd, DateTime? EffDt)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "EmpLoan_Due";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", EmpCd);
            parameters.Add("v_Prd", EffDt);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<int>
               (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public string GetNextLoanTransNo(string CoCd, string tableId)
        {
            var procedureName = "Tool_Generate_No";
            var connectionString = _commonService.GetConnectionString();
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
            var procedureName = "EmpLoan_Approval_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", string.Empty);
            parameters.Add("v_Typ", "0");
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", EmpCd);
            parameters.Add("v_EmpUser", EmpUser);
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLoan_Adjustment_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion

        #region Leave Application
        public void SaveLeave(EmpLeaveModel model)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "EmpLeave_Update";
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
        public int GetEmpMaxLeave(string CoCd, string LeaveType)
        {
            var connectionString = _commonService.GetConnectionString();
            var query = $"select LvMax from CompanyLeaveDetail where CoCd='{CoCd}' and LvCd='{LeaveType}'";
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<int>
               (query);
            return result;
        }
        public string GetNextLeaveTransNo()
        {
            var procedureName = "EmpLeave_TransNo";
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (procedureName, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpLeave_Approval_GetRow_Result> GetEmpLeaveApprovalData(string CoCd, string EmpCd, string EmpUserType)
        {
            var procedureName = "EmpLeave_Approval_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", string.Empty);
            parameters.Add("v_Typ", "3");
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", EmpCd);
            parameters.Add("v_EmpUser", EmpUserType);
            parameters.Add("v_Div", "0");
            parameters.Add("v_Dept", "0");
            parameters.Add("v_EmpCd1", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLeave_Approval_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpLeave_View_GetRow_Result> GetEmpLeaveData(string TransNo = "", string Type = "")
        {
            var procedureName = "EmpLeave_View_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", string.Empty);
            parameters.Add("v_TransNo", TransNo);
            parameters.Add("v_Typ", Type);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLeave_View_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public Employee_LeaveHistory_Detail GetEmployee_LeaveHistory(string empCd, DateTime FromDt, DateTime ToDt)
        {
            var procedureName = "Employee_LeaveHistory";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_FromDt", FromDt);
            parameters.Add("v_ToDt", ToDt);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var multiResult = connection.QueryMultiple(procedureName, parameters, commandType: CommandType.StoredProcedure);
            var empLeaveDetail = multiResult.ReadFirstOrDefault<Employee_LeaveDetail>();
            var previousleavehistory = multiResult.Read<PreviousLeaveHistory>();
            var incomeDetails = multiResult.Read<IncomeDetails>();
            var outstanding = multiResult.ReadFirstOrDefault<OutstandingDetail>();
            var leaveApprovalDetail = multiResult.ReadFirstOrDefault<LeaveApprovalDetails>();
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<EmpLeave_Allowances_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveLeaveApproval(EmpLeaveApprovalModel model)
        {
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "EmpLeaveAppr_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_ApprLvl", model.Current_Approval_Level);
            parameters.Add("v_LvApprDays", model.ApprDays);
            parameters.Add("v_LvApprBy", model.ApprBy);
            parameters.Add("v_LvApprDt", model.ApprDt);
            parameters.Add("v_Status", model.Status);
            parameters.Add("v_WP_FromDt", model.WpFrom);
            parameters.Add("v_WP_ToDt", model.WpTo);
            parameters.Add("v_WOP_FromDt", model.WopFrom);
            parameters.Add("v_WOP_ToDt", model.WopTo);
            parameters.Add("v_Narr", model.Remark);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Reason", model.Remark);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>
               (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse SaveLeaveConfirm(EmpLeaveConfirmModel model, string CoCd)
        {
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
            var procedureName = "EmpLeaveSalary_Update";
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (procedureName, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmpLeaveSalaryTicket_Approval_GetRow_Result> GetEmpLeaveSalaryApprovalData(string EmpCd, string EmpOrUser, string CoCd)
        {
            var procedureName = "EmpLeaveSalaryTicket_Approval_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", string.Empty);
            parameters.Add("v_Typ", "3");
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", EmpCd);
            parameters.Add("v_EmpUser", EmpOrUser);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLeaveSalaryTicket_Approval_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveLeaveSalaryApproval(EmpLeaveSalaryApprovalModel model)
        {
            var connectionString = _commonService.GetConnectionString();
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
            var procedureName = "EmpLeaveSalaryTicket_View_Getrow";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", string.Empty);
            parameters.Add("v_Typ", string.Empty);
            parameters.Add("v_EmpCd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLeaveSalaryTicket_View_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveLeaveSalaryDisburse(EmpLeaveSalaryDisburseModel model, string CoCd)
        {
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (procedureName, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion

        #region Emp Transfer
        public IEnumerable<EmpTransfers_GetRow_Result> GetEmpTransferData()
        {
            var procedureName = "EmpTransfers_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Srno", 0);
            parameters.Add("v_EmpCd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpTransfers_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveEmpTransfer(EmpTransferModel model)
        {
            var procedureName = "EmpTransfers_Update";
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
            parameters.Add("v_BU_From", string.Empty);
            parameters.Add("v_BU_To", string.Empty);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Narr", model.Narration);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public int GetEmpTransferSrNo(string EmpCd)
        {
            var procedureName = "EmpTransfer_SrNo_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Empcd", EmpCd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<int>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        #endregion

        #region Emp Provision Adjustment
        public IEnumerable<Empprovisionsadj_GetRow_Result> GetEmpProvisionAdjData(string empCd, string empUser)
        {
            var procedureName = "Empprovisionsadj_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", string.Empty);
            parameters.Add("v_Typ", "6");
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_EmpUser", empUser);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Empprovisionsadj_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public string GetEmpProvisionAdjSrNo()
        {
            var procedureName = "Empprovisionsadj_TransNo";
            var parameters = new DynamicParameters();
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<string>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse SaveEmpProvisionAdj(EmpprovisionsadjModel model)
        {
            var procedureName = "Empprovisionsadj_Update";
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }

        public CommonResponse SetEmpprovisionsadjAppr(EmpprovisionsadjModel model)
        {
            var procedureName = "EmpprovisionsadjAppr_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", model.TransNo);
            parameters.Add("v_ApprLvl", model.CurrentApprovalLevel);
            parameters.Add("v_ApprBy", model.ApprBy);
            parameters.Add("v_ApprDt", model.ApprDt);
            parameters.Add("v_Status", model.Status);
            parameters.Add("v_Narr", model.Narr);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteEmpProvisionAdj(string transNo)
        {
            var procedureName = "Empprovisionsadj_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_TransNo", transNo);
            var connectionString = _commonService.GetConnectionString();
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpAttendance_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse UpdateEmpMonthlyAttendance(EmpAttendance_Getrow_Result model, AttendanceFilterModel filterModel)
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
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<CommonResponse>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void DeleteEmpAttendance(string empCd, string period, string branch)
        {
            var procedureName = "EmpAttendance_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", empCd ?? string.Empty);
            parameters.Add("v_Prd", period);
            parameters.Add("v_Div", branch);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
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
                bool validEmployee = _employeeService.GetEmployees(CoCd).Any(m => m.Cd == Convert.ToString(reader.GetValue(0)));
                string errorMessage = string.Empty;
                if (!validEmployee)
                    errorMessage += "Employee Code not valid,";
                var excelData = new EmpAttendance_Getrow_Result
                {
                    IsValid = validEmployee,
                    ErrorMessage = errorMessage,
                    Cd = Convert.ToString(reader.GetValue(0)),
                    W_days = Convert.ToInt32(reader.GetValue(1)),
                    P_HDays = Convert.ToInt32(reader.GetValue(2)),
                    Up_HDays = Convert.ToInt32(reader.GetValue(3)),
                    W_OT = Convert.ToInt32(reader.GetValue(4)),
                    H_OT = Convert.ToInt32(reader.GetValue(5))
                };
                result.Add(excelData);
            }
            return result;
        }
        public void ImportAttendanceExcelData(IEnumerable<EmpAttendance_Getrow_Result> excelData, AttendanceFilterModel filterModel)
        {
            foreach (var item in excelData)
            {
                var spYearMonth = filterModel.MonthYear.Split("/");
                filterModel.MonthYear = $"{spYearMonth[1]}{spYearMonth[0]}";
                item.NHrs = Convert.ToInt32((item.W_days - item.Up_HDays - item.P_HDays) * float.Parse(filterModel.WorkingHrDay));
                UpdateEmpMonthlyAttendance(item, filterModel);
            }
        }
        #endregion
    }
}
