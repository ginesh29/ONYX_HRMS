namespace Onyx.Models.StoredProcedure
{
    public class Token_Getrow_Result
    {
        public string TokenNo { get; set; }
        public string ServiceCd { get; set; }
        public string ServiceName { get; set; }
        public string MobileNo { get; set; }
        public string Status { get; set; }
        public DateTime? CalledDt { get; set; }
        public DateTime? ServedDt { get; set; }
        public string ServedBy { get; set; }
        public string CounterCd { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
    }
}
