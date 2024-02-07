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
        #region EarnDeduction
        public IEnumerable<CompanyEarnDed_GetRow_Result> GetEarnDeductions()
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
        public void SaveEarnDeduction(BranchModel model)
        {
            var procedureName = "CompanyEarnDed_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_Des", model.Name);
            parameters.Add("v_CoCd", model.CoCd);
            parameters.Add("v_BU_Cd", "");
            parameters.Add("v_SDes", model.Description);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteEarnDeduction(string Cd, string CoCd)
        {
            var procedureName = "CompanyEarnDed_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Loan Type
        public IEnumerable<CompanyLoanTypes_GetRow> GetLoanTypes()
        {
            var procedureName = "CompanyLoanTypes_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CompanyLoanTypes_GetRow>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveLoanType(BranchModel model)
        {
            var procedureName = "CompanyEarnDed_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_Des", model.Name);
            parameters.Add("v_CoCd", model.CoCd);
            parameters.Add("v_BU_Cd", "");
            parameters.Add("v_SDes", model.Description);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteLoanType(string Cd, string CoCd)
        {
            var procedureName = "CompanyEarnDed_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            parameters.Add("v_CoCd", CoCd);
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
        public void SaveWorkingHour(BranchModel model)
        {
            var procedureName = "CompanyEarnDed_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_Des", model.Name);
            parameters.Add("v_CoCd", model.CoCd);
            parameters.Add("v_BU_Cd", "");
            parameters.Add("v_SDes", model.Description);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteWorkingHour(string Cd, string CoCd)
        {
            var procedureName = "CompanyEarnDed_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            parameters.Add("v_CoCd", CoCd);
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
        public void SaveOvertimeRate(BranchModel model)
        {
            var procedureName = "CompanyEarnDed_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_Des", model.Name);
            parameters.Add("v_CoCd", model.CoCd);
            parameters.Add("v_BU_Cd", "");
            parameters.Add("v_SDes", model.Description);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteOvertimeRate(string Cd, string CoCd)
        {
            var procedureName = "CompanyEarnDed_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion
    }
}