using Dapper;
using Onyx.Models.ViewModels;
using System.Data.SqlClient;
using System.Data;

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
    }
}
