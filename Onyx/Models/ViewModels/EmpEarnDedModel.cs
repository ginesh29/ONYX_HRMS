namespace Onyx.Models.ViewModels
{
    public class EmpEarnDedModel
    {
        public string EmpCd { get; set; }
        public string Emp { get; set; }
        public string Type { get; set; }
        public string Description { get; set; }
        public string Currency { get; set; }
        public decimal? Amt { get; set; }
        public decimal? PercVal { get; set; }
        public decimal? Basic { get; set; }
        public DateTime? EffDt { get; set; }
        public string FormatedEffDt { get; set; }
        public DateTime? EndDt { get; set; }
        public string FormatedEndDt { get; set; }
        public string EdCd { get; set; }
        public string EdTyp { get; set; }
        public string CurrCd { get; set; }
        public string PercAmt { get; set; }
        public int SrNo { get; set; }
        public string ComponentClass { get; set; }
        public string EntryBy { get; set; }
    }
}
