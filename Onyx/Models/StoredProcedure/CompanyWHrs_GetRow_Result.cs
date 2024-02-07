namespace Onyx.Models.StoredProcedure
{
    public class CompanyWHrs_GetRow_Result
    {
        public string Code { get; set; }
        public string Narr { get; set; }
        public DateTime FromDt { get; set; }
        public DateTime ToDt { get; set; }
        public string FormattedFromDate { get; set; }
        public string FormattedToDate { get; set; }
        public decimal? DutyHrs { get; set; }
        public string Religion { get; set; }
        public string HolTypDesc { get; set; }
        public string RelgTypCd { get; set; }
        public string HolTypCd { get; set; }
    }
}
