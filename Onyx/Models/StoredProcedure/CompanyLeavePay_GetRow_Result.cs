namespace Onyx.Models.StoredProcedure
{
    public class CompanyLeavePay_GetRow_Result
    {
        public string Leave { get; set; }
        public string PayType { get; set; }
        public string Paycode { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string LvCd { get; set; }
        public string PayTypCd { get; set; }
        public string PayCd { get; set; }
    }
}
