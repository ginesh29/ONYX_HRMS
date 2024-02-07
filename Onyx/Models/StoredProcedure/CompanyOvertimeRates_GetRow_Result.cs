namespace Onyx.Models.StoredProcedure
{
    public class CompanyOvertimeRates_GetRow_Result
    {
        public string Type { get; set; }
        public int SrNo { get; set; }
        public decimal? HrsApply { get; set; }
        public decimal? Rate { get; set; }
        public string Sdes { get; set; }
        public string Narr { get; set; }
        public string HolTyp { get; set; }
        public string PayCd { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string TypCd { get; set; }
        public string HolTypCd { get; set; }
        public string PayCode { get; set; }
        public string CoCd { get; set;}
    }
}
