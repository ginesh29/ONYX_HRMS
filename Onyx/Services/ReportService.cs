using Dapper;
using System.Data.SqlClient;
using System.Data;
using Onyx.Models.StoredProcedure.Report;
using Onyx.Models.ViewModels.Report;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;

namespace Onyx.Services
{
    public class ReportService(DbGatewayService dbGatewayService)
    {
        private readonly DbGatewayService _dbGatewayService = dbGatewayService;
        public IEnumerable<GetRepo_EmpShortList_Result> GetEmpShortList(EmpShortListFilterModel filterModel, string UserCd, string CoCd)
        {
            var branches = filterModel.Branches != null ? string.Join(",", filterModel.Branches) : null;
            var sponsors = filterModel.Sponsors != null ? string.Join(",", filterModel.Sponsors) : null;
            var statuses = filterModel.Statuses != null ? string.Join(",", filterModel.Statuses) : null;
            var empTypes = filterModel.EmployeeTypes != null ? string.Join(",", filterModel.EmployeeTypes) : null;
            var nationalities = filterModel.Nationalities != null ? string.Join(",", filterModel.Nationalities) : null;

            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpShortList_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Employee", filterModel.EmpCd ?? "All");
            parameters.Add("v_Branch", branches ?? "All");
            parameters.Add("v_Location", filterModel.Section ?? "All");
            parameters.Add("v_Department", filterModel.Department ?? "All");
            parameters.Add("v_Sponsor", sponsors ?? "All");
            parameters.Add("v_Desg", filterModel.Designation ?? "All");
            parameters.Add("v_Age", filterModel.Age ?? "0");
            parameters.Add("v_Qualification", filterModel.Qualification ?? "All");
            parameters.Add("v_Status", statuses ?? "All");
            parameters.Add("v_Nationality", nationalities ?? "All");
            parameters.Add("v_EmployeeType", empTypes ?? "All");
            parameters.Add("v_RowsCnt", filterModel.Active ? "Y" : "N");
            parameters.Add("v_UserCd", UserCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_EmpShortList_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }

        public EmpTransactionModel GetEmpTransactions(EmpTransactionFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpTransactionDetail_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", filterModel.EmpCd);
            parameters.Add("v_RFrmPrd", filterModel.StartPeriod);
            parameters.Add("v_RToPrd", filterModel.EndPeriod);
            var connection = new SqlConnection(connectionString);
            var multiResult = connection.QueryMultiple(procedureName, parameters, commandType: CommandType.StoredProcedure);
            var Header = multiResult.ReadFirstOrDefault<EmpReportHeaderModel>();
            var Data = multiResult.Read<dynamic>();
            var Total = Data.ToList().GetDynamicListTotal();
            return new EmpTransactionModel { Header = Header, ReportData = Data.ToList(), Totals = Total };
        }
        public IEnumerable<Employee_LeaveHistory_GetRow_Result> GetBalanceTransactions(BalanceTransactionFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "Employee_LeaveHistory_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", filterModel.EmpCd ?? "All");
            parameters.Add("v_ToDt", filterModel.ToDate.IsNotEmptyDate() ? filterModel.ToDate.ToString(CommonSetting.InputDateFormat) : DateTime.Now.ToString(CommonSetting.InputDateFormat));
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<Employee_LeaveHistory_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_Provisions_Result> GetProvisions(ProvisionFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_Provisions_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_DivCd", filterModel.BranchCd ?? "All");
            parameters.Add("v_ProvTyp", filterModel.ProvisionType);
            parameters.Add("v_Prd", filterModel.Period);
            parameters.Add("v_Year", filterModel.Year);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_Provisions_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_PaySlip_Result> GetPaySlips(PaySlipFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_PaySlip_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Div", filterModel.BranchCd ?? "All");
            parameters.Add("v_RPrd", filterModel.Period);
            parameters.Add("v_RYear", filterModel.Year);
            parameters.Add("v_EmpCd", filterModel.EmpCd ?? "All");
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_PaySlip_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<EmpLeaveMaster_GetRow_Result> GetEmpLeaveMaster(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "EmpLeaveMaster_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", string.Empty);
            parameters.Add("v_LvTyp", string.Empty);
            parameters.Add("v_Cocd", CoCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<EmpLeaveMaster_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<Getrepo_Emptransfers_Result> GetEmpTransfer(EmpTranferFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "Getrepo_Emptransfers_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cocd", CoCd);
            parameters.Add("v_Employee", filterModel.EmpCd);
            parameters.Add("v_Branch1", filterModel.BranchFrom);
            parameters.Add("v_Branch2", filterModel.BranchFrom);
            parameters.Add("v_Location1", filterModel.SectionFrom);
            parameters.Add("v_Location2", filterModel.SectionTo);
            parameters.Add("v_Department1", filterModel.DepartmentFrom);
            parameters.Add("v_Department2", filterModel.DepartmentTo);
            parameters.Add("v_Dt1", filterModel.StartDate);
            parameters.Add("v_Dt2", filterModel.EndDate);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<Getrepo_Emptransfers_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }

        public IEnumerable<GetRepo_EmpLoan_Result> GetEmpLoan(EmpLoanFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpLoan";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cocd", CoCd);
            parameters.Add("v_EmpCd", filterModel.EmpCd ?? string.Empty);
            parameters.Add("v_Header", string.Empty);
            parameters.Add("v_Typ", filterModel.Status);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_EmpLoan_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_EmpLoanDueList_Result> GetEmpLoanDueList(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpLoanDueList";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cocd", CoCd);
            parameters.Add("v_EmpCd", string.Empty);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_EmpLoanDueList_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_EmpLoan_Analysis_Result> GetEmpLoanAnalysis(EmpLoanAnalysisFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpLoan_Analysis_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cocd", CoCd);
            parameters.Add("v_Employee", filterModel.EmpCd ?? "All");
            parameters.Add("v_Branch", filterModel.Branch ?? "All");
            parameters.Add("v_Location", filterModel.Section ?? "All");
            parameters.Add("v_Department", filterModel.Department ?? "All");
            parameters.Add("v_Sponsor", filterModel.Sponsor ?? "All");
            parameters.Add("v_LoanTyp", filterModel.LoanType ?? "0");
            parameters.Add("v_LoanStatus", filterModel.LoanStatus ?? string.Empty);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_EmpLoan_Analysis_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<dynamic> GetEmpLeaveAnalysis(EmpLeaveAnalysisFilterModel filterModel, string CoCd, string UserCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpLeave_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cocd", CoCd);
            parameters.Add("v_Employee", filterModel.EmpCd ?? "All");
            parameters.Add("v_Branch", filterModel.Branch ?? "All");
            parameters.Add("v_Location", filterModel.Section ?? "All");
            parameters.Add("v_Department", filterModel.Department ?? "All");
            parameters.Add("v_Sponsor", filterModel.Sponsor ?? "All");
            parameters.Add("v_Typ", filterModel.LeaveType ?? string.Empty);
            parameters.Add("v_LvStat", filterModel.LeaveStatus ?? string.Empty);
            parameters.Add("v_Dt1", filterModel.StartDate.ToString() ?? string.Empty);
            parameters.Add("v_Dt2", filterModel.EndDate.ToString() ?? string.Empty);
            parameters.Add("orderBy", filterModel.OrderBy ?? string.Empty);
            parameters.Add("v_UserCd", UserCd);
            parameters.Add("v_ReportType", filterModel.ReportType);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<dynamic>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_ExpiredDocument_Result> GetDocExpired(ExpiredDocFilterModel filterModel, string UserCd, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_ExpiredDocument_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cocd", CoCd);
            parameters.Add("v_FromDate", filterModel.StartDate.IsNotEmptyDate() ? filterModel.StartDate.ToString(CommonSetting.InputDateFormat) : string.Empty);
            parameters.Add("v_ToDate", filterModel.EndDate.IsNotEmptyDate() ? filterModel.EndDate.ToString(CommonSetting.InputDateFormat) : string.Empty);
            parameters.Add("v_Employee", "All");
            parameters.Add("v_DocTyp", filterModel.DocType ?? "All");
            parameters.Add("v_Typ", filterModel.Type);
            parameters.Add("v_UserCd", UserCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_ExpiredDocument_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_FixedEarnDed_Result> GetPayAnalysis(PayAnalysisFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_FixedEarnDed_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_RPrd", filterModel.Period);
            parameters.Add("v_RYear", filterModel.Year);
            parameters.Add("v_BranchCd", filterModel.BranchCd ?? string.Empty);
            parameters.Add("v_EmpCd", filterModel.EmpCd ?? string.Empty);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_FixedEarnDed_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_FixedPayrollCom_Result> GetEmpFixedPayroll(EmplFixedPayrollFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_FixedPayrollCom_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_EmpCd", filterModel.EmpCd ?? string.Empty);
            parameters.Add("v_Div", filterModel.BranchCd ?? string.Empty);
            parameters.Add("v_Cocd", CoCd);
            parameters.Add("v_Dt1", filterModel.StartDate ?? Convert.ToDateTime(CommonSetting.DeafultDate));
            parameters.Add("v_Dt2", filterModel.EndDate ?? DateTime.Now.Date);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_FixedPayrollCom_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_EmpPayDetail_Result> GetRepo_EmpPayDetail(EmpPayRegisterFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpPayDetail_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cocd", CoCd);
            parameters.Add("v_RPrd", filterModel.Month);
            parameters.Add("v_RYear", filterModel.Year);
            parameters.Add("v_Employee", filterModel.EmpCd ?? "All");
            parameters.Add("v_Branch", filterModel.Branch ?? "All");
            parameters.Add("v_Location", filterModel.Section ?? "All");
            parameters.Add("v_Department", filterModel.Department ?? "All");
            parameters.Add("v_Sponsor", filterModel.Sponsor ?? "All");
            parameters.Add("v_Desg", filterModel.Designation ?? "All");
            parameters.Add("v_Nat", filterModel.Nationality ?? "All");
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_EmpPayDetail_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<dynamic> GetRepo_EmpPayDetail_Format(EmpPayRegisterFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpPayDetail_Format_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cocd", CoCd);
            parameters.Add("v_RPrd", filterModel.Month);
            parameters.Add("v_RYear", filterModel.Year);
            parameters.Add("v_Employee", filterModel.EmpCd ?? "All");
            parameters.Add("v_Branch", filterModel.Branch ?? "All");
            parameters.Add("v_Location", filterModel.Section ?? "All");
            parameters.Add("v_Department", filterModel.Department ?? "All");
            parameters.Add("v_Sponsor", filterModel.Sponsor ?? "All");
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<dynamic>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_EmpPayDetail_Summary_Result> GetRepo_EmpPayDetail_Summary(EmpPayRegisterFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpPayDetail_Summary";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cocd", CoCd);
            parameters.Add("v_RPrd", filterModel.Month);
            parameters.Add("v_RYear", filterModel.Year);
            parameters.Add("v_Employee", filterModel.EmpCd ?? "All");
            parameters.Add("v_Branch", filterModel.Branch ?? "All");
            parameters.Add("v_Location", filterModel.Section ?? "All");
            parameters.Add("v_Department", filterModel.Department ?? "All");
            parameters.Add("v_Sponsor", filterModel.Sponsor ?? "All");
            parameters.Add("v_Desg", filterModel.Designation ?? "All");
            parameters.Add("v_Nat", filterModel.Nationality ?? "All");
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_EmpPayDetail_Summary_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_Branch_Result> GetRepo_Branches(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_Branch";
            var parameters = new DynamicParameters();
            parameters.Add("Co_Cd", CoCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_Branch_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_Users_Result> GetRepo_Users()
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_Users_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_GrpDes", string.Empty);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_Users_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_CompanyVehicle_Result> GetRepo_Vehicles(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_CompanyVehicle";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_CompanyVehicle_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_Codes_Result> GetRepo_Codes(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_Codes";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_Codes_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_Country_Result> GetRepo_Country(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_Country";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_Country_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_Currency_Result> GetRepo_Currency(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_Currency";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_Currency_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_Dept_Result> GetRepo_Department(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_Dept";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_Dept_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<GetRepo_CompanyLoans_Result> GetRepo_LoanType(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_CompanyLoans";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_CompanyLoans_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
    }
}