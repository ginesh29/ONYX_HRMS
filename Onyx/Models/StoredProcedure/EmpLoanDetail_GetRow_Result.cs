namespace Onyx.Models.StoredProcedure
{
    public class EmpLoanDetail_GetRow_Result
    {
        public string TransNo { get; set; }
        public decimal SrNo { get; set; }
        public string EmpCd { get; set; }
        public string EdCd { get; set; }
        public string EdTyp { get; set; }
        public string Typ { get; set; }
        public string RecoTyp { get; set; }
        public decimal AmtVal { get; set; }
        public decimal? ChgsAmt { get; set; }
        public DateTime EffDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string FormatedEffDate { get; set; }
    }
}
