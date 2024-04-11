﻿using Dapper;
using System.Data.SqlClient;
using System.Data;
using Onyx.Models.StoredProcedure.Report;
using Onyx.Models.ViewModels.Report;
using static System.Runtime.InteropServices.JavaScript.JSType;

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
            var result = connection.Query<GetRepo_EmpShortList_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }

        public IEnumerable<GetRepo_EmpTransactionDetail_Result> GetEmpTransactions(EmpTransactionFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_EmpTransactionDetail_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", filterModel.EmpCd);
            parameters.Add("v_RFrmPrd", filterModel.StartPeriod);
            parameters.Add("v_RToPrd", filterModel.EndPeriod);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_EmpTransactionDetail_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public IEnumerable<Employee_LeaveHistory_GetRow_Result> GetBalanceTransactions(BalanceTransactionFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "Employee_LeaveHistory_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", filterModel.EmpCd ?? "All");
            parameters.Add("v_ToDt", filterModel.ToDate ?? DateTime.Now.Date);
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
        public IEnumerable<GetRepo_PaySlip_Format_Result> GetPaySlips(PaySlipFilterModel filterModel, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetRepo_PaySlip_Format_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Div", filterModel.BranchCd ?? "All");
            parameters.Add("v_RPrd", filterModel.Period);
            parameters.Add("v_RYear", filterModel.Year);
            parameters.Add("v_EmpCd", filterModel.EmpCd ?? "All");
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_PaySlip_Format_Result>
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
            parameters.Add("v_EmpCd",  string.Empty);
            var connection = new SqlConnection(connectionString);
            var result = connection.Query<GetRepo_EmpLoanDueList_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
    }
}
