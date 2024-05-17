using Dapper;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using System.Data;
using System.Data.SqlClient;

namespace Onyx.Services
{
    public class SettingService(DbGatewayService dbGatewayService)
    {
        private readonly DbGatewayService _dbGatewayService = dbGatewayService;
        #region Company
        public CompanyDetail_Getrow_Result GetCompany(string CoCd, string CoAbbr)
        {
            var procedureName = "Company_Getrow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", CoCd);
            parameters.Add("v_Typ", "1");
            var connectionString = _dbGatewayService.GetConnectionString(CoAbbr);
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<CompanyDetail_Getrow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public void SaveCompany(CompanyModel model)
        {
            try
            {
                var procedureName = "Company_Update";
                var parameters = new DynamicParameters();
                parameters.Add("v_Cd", model.CoCd);
                parameters.Add("v_CoName", model.CoName);
                parameters.Add("v_Add1", model.Add1);
                parameters.Add("v_Add2", model.Add2);
                parameters.Add("v_Add3", model.Add3);
                parameters.Add("v_Phone", model.Phone);
                parameters.Add("v_Fax", model.Fax);
                parameters.Add("v_Email", model.Email);
                parameters.Add("v_AmtDecs", model.AmtDecs);
                parameters.Add("v_BaseCurr", model.BaseCurr);
                parameters.Add("v_RptCurr", model.RptCurr);
                parameters.Add("v_FinBeginDt", model.FinBeginDt);
                parameters.Add("v_FinEndDt", model.FinEndDt);
                parameters.Add("v_QtyDecs", model.QtyDecs);
                parameters.Add("v_Logo", model.Logo);
                parameters.Add("v_LoginBg", model.LoginBg);
                var connectionString = _dbGatewayService.GetConnectionString();
                var connection = new SqlConnection(connectionString);
                connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }
        #endregion

        #region Branch
        public IEnumerable<Branch_GetRow_Result> GetBranches(string CoCd)
        {
            var procedureName = "Branch_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Branch_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveBranch(BranchModel model)
        {
            var procedureName = "Branch_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code.Trim());
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_CoCd", model.CoCd);
            parameters.Add("v_BU_Cd", "");
            parameters.Add("v_SDes", model.Name);
            parameters.Add("v_Image", model.Image ?? "");
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteBranch(string Cd, string CoCd)
        {
            var procedureName = "Branch_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<BankBranch_GetRow_Result> GetBankBranches(string bankCd)
        {
            var procedureName = "BankBranch_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Bank", bankCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<BankBranch_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        #endregion

        #region User
        public CommonResponse SaveUser(UserModel model)
        {
            var connectionString = _dbGatewayService.GetConnectionString();
            var procedureName = "Users_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_LoginId", model.LoginId);
            parameters.Add("v_Abbr", model.Abbr);
            parameters.Add("v_UPWD", model.UPwd);
            parameters.Add("v_UName", model.Username);
            parameters.Add("v_ExpiryDt", model.ExpiryDt.Value.ToString(CommonSetting.InputDateFormat));
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteUser(string Cd)
        {
            var procedureName = "Users_Delete_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<GetMenuWithPermissions_Result> ConvertPermissionToTree(IEnumerable<GetMenuWithPermissions_Result> flatList)
        {
            var itemDictionary = flatList.ToDictionary(item => item.MenuId);
            var tree = new List<GetMenuWithPermissions_Result>();

            foreach (var item in flatList)
            {
                if (item.Prnt == 0)
                {
                    tree.Add(item);
                }
                else if (itemDictionary.TryGetValue(item.Prnt, out GetMenuWithPermissions_Result value))
                {
                    var parent = value;
                    parent.Children ??= [];
                    parent.Children.Add(item);
                }
            }
            //var visibleMenuItems = tree.Where(m => m.Visible == "Y");
            //var parentIds = visibleMenuItems.Select(m => m.Prnt).Distinct();
            ////var menuIds = tree.Select(m => m.MenuId).Distinct();
            //tree = tree.Select(m => { m.Visible = parentIds.Contains(m.MenuId) ? "Y" : null; return m; }).ToList();
            return tree;
        }
        #endregion

        #region Department
        public IEnumerable<Dept_GetRow_Result> GetDepartments()
        {
            var procedureName = "Dept_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Dept_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveDepartment(DepartmentModel model)
        {
            var procedureName = "Dept_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_SDes", model.Name);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteDepartment(string Cd)
        {
            var procedureName = "Dept_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        public string GetDepartment_SrNo()
        {
            //var query = "SELECT 'DEP' + CAST(MAX(CAST(REPLACE(LTRIM(RTRIM(Cd)), 'DEP', '') AS INT)) + 1 AS VARCHAR) AS NextCode FROM Dept;";
            var query = "SELECT 'DEP'+right('000'+ convert(varchar(3),isnull(Max(substring(cd,4,len(trim(cd)))),0)+1),3)  AS NextCode FROM Dept";
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (query);
            return data;
        }
        #endregion

        #region Code

        public string GetNextCode(string type)
        {
            var procedureName = "Codes_Auto_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Typ", type);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.QueryFirstOrDefault<string>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<CodeGroups_GetRow_Result> GetCodeGroups(string CoCd)
        {
            var procedureName = "CodeGroups_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<CodeGroups_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public IEnumerable<Codes_Grp_GetRow_Result> GetCodeGroupItems(string grp)
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
        public IEnumerable<Codes_GetRow_Result> GetCodes()
        {
            var procedureName = "Codes_GetRow_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Codes_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveCode(CodeModel model)
        {
            var procedureName = "Codes_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_Typ", model.Type);
            parameters.Add("v_Abbr", model.Abbriviation);
            parameters.Add("v_SDes", model.ShortDes);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_Active", model.Active);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteCode(string Cd)
        {
            var procedureName = "Codes_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion

        #region Country
        public IEnumerable<Country_GetRow_Result> GetCountries()
        {
            var procedureName = "Country_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Country_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveCountry(CountryModel model)
        {
            var procedureName = "Country_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_SDes", model.ShortDesc);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_Nat", model.Nationality);
            parameters.Add("v_Region", model.Region);
            parameters.Add("v_Provisions", model.Provisions);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public CommonResponse DeleteCountry(string Cd)
        {
            var procedureName = "Country_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        #endregion

        #region Currency
        public IEnumerable<Currency_GetRow_Result> GetCurrencies(string CoCd)
        {
            var procedureName = "Currency_GetRow";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", string.Empty);
            parameters.Add("v_CoCd", CoCd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var data = connection.Query<Currency_GetRow_Result>
                (procedureName, parameters, commandType: CommandType.StoredProcedure);
            return data;
        }
        public CommonResponse SaveCurrency(CurrencyModel model, string CoCd)
        {
            var procedureName = "Currency_Update_N";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", model.Code);
            parameters.Add("v_Des", model.Description);
            parameters.Add("v_MainCurr", model.MainCurr);
            parameters.Add("v_SubCurr", model.SubCurr);
            parameters.Add("v_NoDecs", model.NoDecs);
            parameters.Add("v_Rate", model.Rate);
            parameters.Add("v_Symbol", model.Symbol);
            parameters.Add("v_Abbr", model.Abbriviation);
            parameters.Add("v_CoCd", CoCd);
            parameters.Add("v_EntryBy", model.EntryBy);
            parameters.Add("v_Mode", model.Mode);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            var result = connection.QueryFirstOrDefault<CommonResponse>(procedureName, parameters, commandType: CommandType.StoredProcedure);
            return result;
        }
        public void DeleteCurrency(string Cd)
        {
            var procedureName = "Currency_Delete";
            var parameters = new DynamicParameters();
            parameters.Add("v_Cd", Cd);
            var connectionString = _dbGatewayService.GetConnectionString();
            var connection = new SqlConnection(connectionString);
            connection.Execute(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
        #endregion
    }
}