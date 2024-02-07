﻿using Dapper;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using Onyx.Data;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Sockets;
using System.Security;

namespace Onyx.Services
{
    public class CommonService(AppDbContext context)
    {
        private readonly AppDbContext _context = context;

        public string GetConnectionString()
        {
            var procedureName = "CompanyDatabases_Getrow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoAbbr", CommonSetting.MAINCOMPANY);
            using var connection = _context.CreateConnection();
            var company = connection.QueryFirstOrDefault<CompanyDatabases_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return $"Server={company.Server};Initial catalog={company.DbName};uid={company.DbUser}; pwd={company.DbPwd};TrustServerCertificate=True;Connection Timeout=120;";
        }
        public IEnumerable<GetMenuWithPermissions_Result> GetMenuWithPermissions(string UserCd)
        {
            var connectionString = GetConnectionString();
            var procedureName = "GetMenuWithPermissions";
            var parameters = new DynamicParameters();
            parameters.Add("UserCd", UserCd);
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<GetMenuWithPermissions_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<GetUserBranches_Result> GetUserBranches(string UserCd)
        {
            var connectionString = GetConnectionString();
            var procedureName = "GetUserBranches";
            var parameters = new DynamicParameters();
            parameters.Add("UserCd", UserCd);
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<GetUserBranches_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveUserMenu(string UserCd, string ActiveMenuIds)
        {
            var connectionString = GetConnectionString();
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
            var connectionString = GetConnectionString();
            string insertQuery = PermissionIdsWithActions != null ? "INSERT INTO UserPermission(UserCd,MenuId,uAdd,uEdit,uDelete,uView,uPrint) VALUES" : null;

            string MenuId = string.Empty;
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
            List<PermissionModel> Permissions = new List<PermissionModel>();
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
        public void SaveUserBranch(string UserCd, string[] UserBranchIds)
        {
            var connectionString = GetConnectionString();
            string insertQuery = UserBranchIds != null ? "INSERT INTO UserBranch(UserCd,Div,Des) VALUES" : null;
            if (UserBranchIds != null)
            {
                foreach (var item in UserBranchIds)
                    insertQuery += $"('{UserCd}','{item}','Y'),";
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
            var connectionString = GetConnectionString();
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
        public Parameters_GetRow_Result GetJobCardStartAndEndTime(string CoCd, string Cd)
        {
            var connectionString = GetConnectionString();
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
            var connectionString = GetConnectionString();
            var procedureName = "ActvityLogHead_MaxActivityId_Getrow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connection = new SqlConnection(connectionString);
            DateTime? result = connection.QueryFirstOrDefault<DateTime>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result != null ? Convert.ToDateTime(result) : DateTime.Now;
        }
    }
}