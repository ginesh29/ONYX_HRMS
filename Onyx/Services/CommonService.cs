using Dapper;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics.Eventing.Reader;
using System.Net;
using System.Net.Sockets;
using System.Xml.Linq;

namespace Onyx.Services
{
    public class CommonService(DbGatewayService dbGatewayService)
    {
        private readonly DbGatewayService _dbGatewayService = dbGatewayService;
        public IEnumerable<Branch_UserCo_GetRow_Result> GetUserCompanies(string UserCd)
        {
            var procedureName = "Branch_UserCo_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_UserCd", UserCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var companies = connection.Query<Branch_UserCo_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return companies;
        }
        public IEnumerable<GetMenuWithPermissions_Result> GetMenuWithPermissions(string UserCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetMenuWithPermissions";
            var parameters = new DynamicParameters();
            parameters.Add("UserCd", UserCd);
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<GetMenuWithPermissions_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<UserBranch_GetRow_Result> GetUserBranches(string UserCd, string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "UserBranch_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_UserCd", UserCd);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Div", string.Empty);
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<UserBranch_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveUserMenu(string UserCd, string ActiveMenuIds)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            string insertQuery = !string.IsNullOrEmpty(ActiveMenuIds) ? "INSERT INTO UserMenu(UserCd,MenuId,Visible) VALUES" : null;
            if (!string.IsNullOrEmpty(ActiveMenuIds))
            {
                foreach (var item in ActiveMenuIds.Split(","))
                    insertQuery += $"('{UserCd}',{item},'Y'),";
                insertQuery = insertQuery.Trim([',']);
            }
            string query = $"delete from UserMenu where UserCd = '{UserCd}';{Environment.NewLine}{insertQuery}";
            var connection = new SqlConnection(connectionString);
            connection.Execute(query);
        }
        public void SaveUserPermission(string UserCd, IEnumerable<string> PermissionIdsWithActions)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            string insertQuery = PermissionIdsWithActions != null ? "INSERT INTO UserPermission(UserCd,MenuId,uAdd,uEdit,uDelete,uView,uPrint) VALUES" : null;

            if (PermissionIdsWithActions != null)
            {
                var permissions = GetPermissionModels(PermissionIdsWithActions);
                foreach (var item in permissions)
                    insertQuery += $"('{UserCd}','{item.Id}',{item.Add},{item.Edit},{item.Delete},{item.View},{item.Print}),";
                insertQuery = insertQuery.Trim([',']);
            }
            string query = $"delete from UserPermission where UserCd = '{UserCd}';{Environment.NewLine}{insertQuery}";
            var connection = new SqlConnection(connectionString);
            connection.Execute(query);
        }
        public IEnumerable<PermissionModel> GetPermissionModels(IEnumerable<string> PermissionIdsWithActions)
        {
            List<PermissionModel> Permissions = [];
            foreach (var item in PermissionIdsWithActions)
            {
                var sp = item.Split('_');
                string IsAdd = item.Contains("Add") ? "Y" : null;
                string IsEdit = item.Contains("Edit") ? "Y" : null;
                string IsDelete = item.Contains("Delete") ? "Y" : null;
                string IsView = item.Contains("View") ? "Y" : null;
                string IsPrint = item.Contains("Print") ? "Y" : null;
                Permissions.Add(new PermissionModel { Id = sp[0], Add = IsAdd, Edit = IsEdit, Delete = IsDelete, View = IsView, Print = IsPrint });
            }
            return Permissions
            .GroupBy(p => p.Id)
            .Select(g => new PermissionModel
            {
                Id = g.Key,
                Add = g.Any(p => p.Add == "Y") ? "\'Y\'" : "null",
                Edit = g.Any(p => p.Edit == "Y") ? "\'Y\'" : "null",
                Delete = g.Any(p => p.Delete == "Y") ? "\'Y\'" : "null",
                View = g.Any(p => p.View == "Y") ? "\'Y\'" : "null",
                Print = g.Any(p => p.Print == "Y") ? "\'Y\'" : "null",
            }).ToList();
        }
        public void SaveUserBranch(string UserCd, List<string> UserBranchIds)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            string insertQuery = UserBranchIds != null ? "INSERT INTO UserBranch(UserCd,Div,Des) VALUES" : null;
            if (UserBranchIds != null)
            {
                foreach (var item in UserBranchIds)
                    insertQuery += $"('{UserCd}','{item.Trim()}','Y'),";
                insertQuery = insertQuery.Trim([',']);
            }
            string query = $"delete from UserBranch where UserCd = '{UserCd}';{Environment.NewLine}{insertQuery}";
            var connection = new SqlConnection(connectionString);
            connection.Execute(query);
        }
        public int SetActivityLogHead(ActivityLogModel model)
        {
            var ip = Dns.GetHostEntry(Dns.GetHostName()).AddressList.FirstOrDefault(m => m.AddressFamily == AddressFamily.InterNetwork).ToString();
            var os = Environment.OSVersion.Platform.ToString();
            var connectionString = _dbGatewayService.GetConnectionString(model.CoAbbr);
            var procedureName = "ActivityLogHead_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", model.CoCd);
            parameters.Add("v_ActivityId", "");
            parameters.Add("v_SessionId", "");
            parameters.Add("v_UserCd", model.UserCd);
            parameters.Add("v_IP", ip);
            parameters.Add("v_OS", os);
            parameters.Add("v_Browser", model.Browser);
            parameters.Add("v_StartTime", DateTime.Now);
            parameters.Add("v_EndTime", DateTime.Now);
            parameters.Add("v_typ", "I");
            var connection = new SqlConnection(connectionString);
            int result = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public int SetActivityLogDetail(string ActivityId, string ProcessId, string ActivityAbbr, string Message)
        {
            var procedureName = "ActivityLogDetail_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_ActivityId", ActivityId);
            parameters.Add("v_ProcessId", ProcessId);
            parameters.Add("v_ActivityAbbr", ActivityAbbr);
            parameters.Add("v_Mesg", Message);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            int result = connection.QueryFirstOrDefault<int>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public Parameters_GetRow_Result GetParameterByType(string CoCd, string Cd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "Parameters_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_opt", "");
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<Parameters_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public DateTime GetCuurentLoggedInDetails(string CoCd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "ActvityLogHead_MaxActivityId_Getrow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            DateTime? result = connection.QueryFirstOrDefault<DateTime>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result != null ? Convert.ToDateTime(result) : DateTime.Now;
        }
        public IEnumerable<GetSysCodes_Result> GetSysCodes(string type)
        {
            var procedureName = "SysCodes1_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Typ", type);
            parameters.Add("v_ExceptCd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<GetSysCodes_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<GetSysCodes_Result> GetPayElements()
        {
            var procedureName = "CompanyEarnDed_OT_GetRow";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<GetSysCodes_Result>
                (procedureName, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<Codes_Grp_GetRow_Result> GetCodesGroups(string grp)
        {
            var procedureName = "Codes_Grp_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Grp", grp);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Codes_Grp_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<SelectListItem> GetComponentTypes()
        {
            var componentTypes = new List<SelectListItem>()
            {
                new() {Text="Fixed", Value="F"},
                new() { Text="Variable", Value="V"},
                new() { Text="Per-day", Value="D"},
                new() { Text="Hourly", Value="H"},
                new() { Text="Pro-rata", Value="P"}
            };
            return componentTypes;
        }
        public IEnumerable<SelectListItem> GetPercentageAmtTypes()
        {
            var percentageAmtTypes = new List<SelectListItem>()
            {
                new() {Text="AMOUNT", Value="A"},
                new() { Text="PERCENTAGE", Value="P"},
            };
            return percentageAmtTypes;
        }
        public IEnumerable<SelectListItem> GetLeaveStatusTypes()
        {
            var statusTypes = new List<SelectListItem>()
            {
                new() {Text="Present(Working)", Value="PW"},
                new() { Text="Leave requested", Value="LR"},
                new() {Text="Leave approved", Value="LA"},
                new() { Text="On Leave", Value="OL"}};
            return statusTypes;
        }
        public IEnumerable<SelectListItem> GetCalulationBasisTypes()
        {
            var calculationTypes = new List<SelectListItem>()
            {
                new() {Text="Monthly", Value="M",Selected=true},
                new() { Text="Daily", Value="D"},
                new() {Text="Hourly", Value="H"}
            };
            return calculationTypes;
        }
        public IEnumerable<SelectListItem> GetIntLocalTypes()
        {
            var calculationTypes = new List<SelectListItem>()
            {
                new() {Text="International", Value="I",Selected=true},
                new() { Text="Local", Value="L"},
            };
            return calculationTypes;
        }
        public IEnumerable<SelectListItem> GetChargesTypes()
        {
            var chargeTypes = new List<SelectListItem>()
            {
                new() {Text= "Fixed Rate", Value="FR"},
                new() { Text= "Reduce Balance", Value="RB"},
            };
            return chargeTypes;
        }
        public IEnumerable<SelectListItem> GetYears(int startYear)
        {
            var years = new List<SelectListItem>();
            for (int yrcnt = startYear; yrcnt < DateTime.Now.Year; yrcnt++)
                years.Add(new SelectListItem { Text = yrcnt.ToString(), Value = yrcnt.ToString() });
            return years;
        }
        public IEnumerable<GetSysCodes_Result> GetEarnDedTypes(string type)
        {
            var procedureName = "CompanyEarnDed_Loan_GetRow";
            var connectionString = _dbGatewayService.GetConnectionString();
            var parameters = new DynamicParameters();
            parameters.Add("v_Typ", type);
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<GetSysCodes_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<SelectListItem> GetBeforeAfter()
        {
            var beforeAfter = new List<SelectListItem>()
            {
                new() {Text="Before", Value="B" ,Selected=true},
                new() { Text="After", Value="A"},
            };
            return beforeAfter;
        }
        public IEnumerable<SelectListItem> GetLoanStatus()
        {
            var beforeAfter = new List<SelectListItem>()
            {
                new() {Text="Disburse", Value="D" },
                new() { Text="Cancel", Value="C"},
            };
            return beforeAfter;
        }
        public int GetNext_SrNo(string tableName, string fileldName)
        {
            var query = $"SELECT Isnull(Max({fileldName}),0)+1 AS NextID FROM {tableName};";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<int>
                (query);
            return data;
        }
        public IEnumerable<GetSysCodes_Result> GetPayCodesByType(string payType)
        {
            var procedureName = "CompanyEarnDed_AllTypes_GetRow";
            var connectionString = _dbGatewayService.GetConnectionString();
            var parameters = new DynamicParameters();
            parameters.Add("v_Typ", payType);
            parameters.Add("v_TrnTyp", "V");
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<GetSysCodes_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public int MonthEndProcess(string CoCd)
        {
            var procedureName = "Tool_Process_MonthEnd";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<int>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void GenerateModifiedSp()
        {
            var modifiedSpQuery = @"SELECT name,  modify_date 
	                                FROM sys.objects
	                                WHERE type = 'P' and modify_date > '2024-01-01' and name not like '%_N%'
	                                ORDER BY modify_date DESC";
            var connectionString = "Server=GINESH-PC\\SQLEXPRESS;Initial catalog=Onyx;uid=absluser; pwd=0c4gn2zn;TrustServerCertificate=True;Connection Timeout=120;";
            var connection = new SqlConnection(connectionString);
            var sps = connection.Query<string>(modifiedSpQuery);
            foreach (var item in sps)
            {
                string query = $"SELECT OBJECT_DEFINITION(OBJECT_ID('{item.Trim()}')) AS Definition";
                string storedProcedureText = connection.QueryFirstOrDefault<string>(query);
                if (!string.IsNullOrEmpty(storedProcedureText))
                {
                    string filename = $"{item}_N";
                    string filePath = $@"D:\Projects\HRMS\Onyx\DB\scripts\{filename}.sql";
                    storedProcedureText = storedProcedureText.Replace(item, filename);
                    File.WriteAllText(filePath, storedProcedureText);
                }
            }
        }
    }
}