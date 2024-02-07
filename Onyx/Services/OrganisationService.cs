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
        public void SaveComponent(EarnDedModel model)
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
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
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
        public void SaveLoanType(LoanTypeModel model)
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
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
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
        public void SaveWorkingHour(WorkingHourModel model, string CoCd)
        {
            var procedureName = "CompanyWHrs_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_Narr", model.Description);
            parameters.Add("v_FromDt", model.FromDt);
            parameters.Add("v_ToDt", model.ToDt);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_DutyHrs", model.DutyHrs);
            parameters.Add("v_RelgTyp", model.RelgTypCd);
            parameters.Add("v_HolTyp", model.HolTypCd);
            parameters.Add("v_EntryBy", model.EntryBy);
            var connectionString = _commonService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
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
        public void SaveOvertimeRate(OvertimeRateModel model, string CoCd)
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
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
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
    }
}