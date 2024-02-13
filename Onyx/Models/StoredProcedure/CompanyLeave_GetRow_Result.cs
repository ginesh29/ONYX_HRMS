namespace Onyx.Models.StoredProcedure
{
    public class CompanyLeave_GetRow_Result
    {
        public string Cd { get; set; }
        public string SDes { get; set; }
        public string Des { get; set; }
        public decimal? ApprLvl { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string CoCd { get; set; }
        public string LvCd { get; set; }
        public decimal LvMax { get; set; }
        public string Accrued { get; set; }
        public string EnCash { get; set; }
        public decimal EnCashMinLmt { get; set; }
        public decimal PayFact { get; set; }
        public decimal AccrLmt { get; set; }
        public string ServicePrd { get; set; }
    }
}
