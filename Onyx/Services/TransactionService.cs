using Dapper;
using Onyx.Models.ViewModels;
using System.Data.SqlClient;
using System.Data;
using Onyx.Models.StoredProcedure;

namespace Onyx.Services
{
    public class TransactionService(CommonService commonService)
    {
        private readonly CommonService _commonService = commonService;

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
            parameters.Add("v_DocDt", DateTime.Now.ToString(CommonSetting.DateFormat));
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
            parameters.Add("v_DocDt", DateTime.Now.ToString(CommonSetting.DateFormat));
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
            parameters.Add("v_WP_FromDt", model.LvFrom);
            parameters.Add("v_WP_ToDt", model.LvTo);
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

        public IEnumerable<EmpTransfers_GetRow_Result> GetEmpTransferData(string TransNo = "", string Type = "")
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
    }
}
