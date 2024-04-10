using Dapper;
using System.Data.SqlClient;
using System.Data;
using Onyx.Models.StoredProcedure.Report;
using Onyx.Models.ViewModels.Report;

namespace Onyx.Services
{
    public class ReportService(DbGatewayService dbGatewayService)
    {
        private readonly DbGatewayService _dbGatewayService = dbGatewayService;
        public IEnumerable<GetRepo_EmpShortList_Result> GetEmpShortList(EmpShortListFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpShortList_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Employee", filterModel.EmpCd ?? "All");
            parameters.Add("v_Branch", filterModel.Branch ?? "All");
            parameters.Add("v_Location", filterModel.Section ?? "All");
            parameters.Add("v_Department", filterModel.Department ?? "All");
            parameters.Add("v_Sponsor", filterModel.Sponsor ?? "All");
            parameters.Add("v_Desg", filterModel.Designation ?? "All");
            parameters.Add("v_Age", filterModel.Age);
            parameters.Add("v_Qualification", filterModel.Qualification ?? "All");
            parameters.Add("v_Status", filterModel.Status ?? "All");
            parameters.Add("v_Nationality", filterModel.Nationality ?? "All");
            var connection = new SqlConnection(connectionString);
            var user = connection.Query<GetRepo_EmpShortList_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }

        public IEnumerable<GetRepo_EmpTransactionDetail_Result> GetEmpTransactions(string empCd, string startPeriod, string endPeriod, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpTransactionDetail_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_RFrmPrd", startPeriod);
            parameters.Add("v_RToPrd", endPeriod);
            var connection = new SqlConnection(connectionString);
            var user = connection.Query<GetRepo_EmpTransactionDetail_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }
        public IEnumerable<Employee_LeaveHistory_GetRow_Result> GetBalanceTransactions(string empCd, DateTime? toDate, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "Employee_LeaveHistory_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", empCd ?? "All");
            parameters.Add("v_ToDt", toDate ?? DateTime.Now.Date);
            var connection = new SqlConnection(connectionString);
            var user = connection.Query<Employee_LeaveHistory_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return user;
        }
    }
}
