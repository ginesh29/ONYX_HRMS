namespace Onyx.Models.StoredProcedure
{
    public class AirFare_GetRow_Result
    {
        public string Sector { get; set; }
        public string TravelClass { get; set; }
        public decimal SrNo { get; set; }
        public string FormattedFromDate { get; set; }
        public string FormattedToDate { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public string SDes { get; set; }
        public string Des { get; set; }
        public decimal? Fare { get; set; }
        public string Entryby { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string SectCd { get; set; }
        public string ClassCd { get; set; }
    }
}
