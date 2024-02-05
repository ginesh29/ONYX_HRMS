namespace Onyx.Models.StoredProcedure
{
    public class Users_GetRow_Result
    {
        public string Code { get; set; }
        public string Abbr { get; set; }
        public string LoginId { get; set; }
        public string UPwd { get; set; }
        public string Username { get; set; }
        public DateTime ExpiryDt { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string UserGrpCd { get; set; }
        public string ViewAllEmp { get; set; }
        public string UserGroupCd { get; set; }
    }
}
