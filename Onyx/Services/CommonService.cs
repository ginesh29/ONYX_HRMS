using Dapper;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data;
using System.Data.SqlClient;

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
        public GetMenuWithPermissions_Result GetPermissionsByProcessId(string UserCd, string processId)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "GetMenuWithPermissions";
            var parameters = new DynamicParameters();
            parameters.Add("UserCd", UserCd);
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<GetMenuWithPermissions_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            if (UserCd != "001")
                data = data.Where(m => m.ProcessId.Trim() == processId && m.Visible == "Y");
            else
                data = data.Select(m => { m.UView = "Y"; m.UAdd = "Y"; m.UEdit = "Y"; m.UDelete = "Y"; return m; });
            return data.FirstOrDefault();
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
        public int SetActivityLogDetail(string ActivityId, string ProcessId, string ActivityAbbr, string Message)
        {
            var procedureName = "ActivityLogDetail_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_ActivityId", ActivityId);
            parameters.Add("v_ProcessId", ProcessId);
            parameters.Add("v_ActivityAbbr", ActivityAbbr);
            parameters.Add("v_TimeStamp", DateTime.Now);
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
            parameters.Add("v_opt", string.Empty);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<Parameters_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public Parameters_GetRow_Result GetParameterByProcess(string CoCd, string Cd)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "ParameterByProcess_GetRow";
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
        public IEnumerable<GetSysCodes_Result> GetBusinessUnits(string CoCd)
        {
            var procedureName = "BusinessUnits_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<GetSysCodes_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<WidgetMaster_GetRow_Result> GetWidgetMaster()
        {
            var procedureName = "WidgetMaster_GetRow";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var widgets = connection.Query<WidgetMaster_GetRow_Result>
                (procedureName, commandType: CommandType.StoredProcedure);
            return widgets;
        }
        public IEnumerable<UserWidgets_GetRow_Result> GetUserWidget(string UserCd)
        {
            var procedureName = "UserWidgets_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_UserCd", UserCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var widgets = connection.Query<UserWidgets_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return widgets;
        }
        public void SaveUserWidget(WidgetModel widget, string UserCd)
        {
            var procedureName = "UserWidgets_Update";
            var parameters = new DynamicParameters();
            parameters.Add("v_UserCd", UserCd);
            parameters.Add("v_Widget_Id", widget.Id);
            parameters.Add("v_XPos", widget.X);
            parameters.Add("v_YPos", widget.Y);
            parameters.Add("v_Width", widget.W);
            parameters.Add("v_Height", widget.H);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public void DeleteUserWidget(string UserCd, string WidgetId = null)
        {
            var procedureName = "UserWidgets_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_UserCd", UserCd);
            parameters.Add("v_Widget_Id", WidgetId);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
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
        public IEnumerable<SelectListItem> GetEmpWorkingStatuses()
        {
            var statusTypes = new List<SelectListItem>()
            {
                new() {Text="Present(Working)", Value="P"},
                new() { Text="Leave requested", Value="N"},
                new() {Text="Leave approved", Value="A"},
                new() { Text="On Leave", Value="F"}};
            return statusTypes;
        }
        public IEnumerable<SelectListItem> GetEmpLeaveStatuses()
        {
            var statusTypes = new List<SelectListItem>()
            {
                new() {Text="Unapproved", Value="N"},
                new() { Text="Approved", Value="Y"},
                new() {Text="Confrimed", Value="F"},
                new() { Text="Rejected", Value="R"},
                new() { Text = "Revised", Value = "V" },
                new() { Text = "Cancelled", Value = "C" },
                new() { Text = "Rejoined", Value = "J" }};
            return statusTypes;
        }
        public IEnumerable<SelectListItem> GetEmpLoanStatuses()
        {
            var statusTypes = new List<SelectListItem>()
            {
                new() {Text="Unapproved", Value="N"},
                new() { Text="Approved", Value="A"},
                new() {Text="Disburse", Value="D"},
                new() { Text="Rejected", Value="R"},
                new() { Text = "Closed", Value = "C" }};
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
        public void PrePayrollProcess(string Period, string Year, string Branch, string CoCd)
        {
            var procedureName = "PrePayroll_Process";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_Prd", Period);
            parameters.Add("v_Year", Year);
            parameters.Add("v_Div", Branch ?? "0");
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Query(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public class SpModel
        {
            public string Type { get; set; }
            public string Name { get; set; }
            public DateTime Modify_Date { get; set; }
        }
        public void GenerateModifiedSp(bool singleFile = true)
        {
            var modifiedSpQuery = @$"SELECT Name, Modify_Date, trim(type)Type FROM sys.objects
	                                WHERE (Type = 'P' or Type = 'TR') and Modify_Date > '2024-01-01'
	                                ORDER BY Modify_Date DESC";
            var connectionString = "Server=108.181.157.253,10005;Initial catalog=LSHRMS_Telal;uid=absluser; pwd=0c4gn2zn;TrustServerCertificate=True;Connection Timeout=120;";
            var connection = new SqlConnection(connectionString);
            var sps = connection.Query<SpModel>(modifiedSpQuery);
            var result = string.Empty;
            string filePath;
            foreach (var item in sps)
            {
                string query = $"SELECT OBJECT_DEFINITION(OBJECT_ID('{item.Name.Trim()}')) AS Definition";
                string storedProcedureText = connection.QueryFirstOrDefault<string>(query);
                if (!string.IsNullOrEmpty(storedProcedureText))
                {
                    storedProcedureText = storedProcedureText.Replace("CREATE", "CREATE OR ALTER", StringComparison.InvariantCultureIgnoreCase);

                    string spText = $"{storedProcedureText.Replace("CREATE OR ALTER table #", "CREATE table #", StringComparison.InvariantCultureIgnoreCase).Replace("CREATE OR ALTER TABLE dbo.#", "CREATE table dbo.#", StringComparison.InvariantCultureIgnoreCase)} \n Go \n";
                    if (singleFile)
                        result += spText;
                    else
                        result = spText;
                }
                if (!singleFile)
                {
                    string type = item.Type == "P" ? "Sp" : "Trigger";
                    filePath = $@"D:\Projects\HRMS\Onyx\DB\scripts\{type}-Backup-{item.Modify_Date:ddMMyyyy}.sql";
                    File.WriteAllText(filePath, result);
                }
            }
            if (singleFile)
            {
                filePath = $@"D:\Projects\HRMS\Onyx\DB\scripts\Backup-Single-{DateTime.Now:ddMMyyyy}.sql";
                File.WriteAllText(filePath, result);
            }
        }
        public DateTime GetMinDateByCurrentPeriod(string CoCd)
        {
            var currentMonth = GetParameterByType(CoCd, "CUR_MONTH").Val;
            var currentYear = GetParameterByType(CoCd, "CUR_YEAR").Val;
            int lastDayOfMonth = DateTime.DaysInMonth(Convert.ToInt32(currentYear), Convert.ToInt32(currentMonth));
            var date = new DateTime(Convert.ToInt32(currentYear), Convert.ToInt32(currentMonth), lastDayOfMonth);
            return date;
        }
        #region Dashboard
        public IEnumerable<EmpLeave_GetRow_Result> GetRowEmpLeave(string param, string type, string CoCd)
        {
            var procedureName = "EmpLeave_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Param", param);
            parameters.Add("v_Typ", type);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmpLeave_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<EmployeeWiseForChart_Result> EmployeeWiseForChart(string type)
        {
            var procedureName = "EmployeeWiseForChart_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Typ", type);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<EmployeeWiseForChart_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public EmplLoanAndLeaveApproval EmplLoanAndLeaveApproval(string empCd, string type, string CoCd, string UserCd)
        {
            var procedureName = "EmplLoanAndLeaveApproval_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EmpCd", empCd);
            parameters.Add("v_Typ", type);
            parameters.Add("v_UserCd", UserCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var multiResult = connection.QueryMultiple(procedureName, parameters, commandType: CommandType.StoredProcedure);
            var leaveApplied = multiResult.ReadFirstOrDefault<int>();
            var onLeave = multiResult.ReadFirstOrDefault<int>();
            var working = multiResult.ReadFirstOrDefault<int>();
            var headCount = multiResult.Read<HeadCountModel>();
            var currentMonth = multiResult.ReadFirstOrDefault<string>();
            var lastMonth = multiResult.ReadFirstOrDefault<string>();
            var salaryDetails = multiResult.Read<SalaryDetailModel>();
            var userSalaryDetails = type == "E" ? multiResult.Read<SalaryDetailModel>() : [];
            return new EmplLoanAndLeaveApproval
            {
                LeaveApplied = leaveApplied,
                OnLeave = onLeave,
                Working = working,
                HeadCounts = headCount,
                CurrentMonth = currentMonth,
                LastMonth = lastMonth,
                SalaryDetails = salaryDetails,
                UserSalaryDetails = userSalaryDetails
            };
        }
        public IEnumerable<GetDashboardCalendarEvents_Result> GetCalendarEvents(string UserCd)
        {
            var procedureName = "GetDashboardCalendarEvents";
            var parameters = new DynamicParameters();
            parameters.Add("v_Usercd", UserCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<GetDashboardCalendarEvents_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion
    }
}