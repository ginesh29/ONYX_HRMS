namespace Onyx.Models.StoredProcedure
{
    public class EmpProgressionDetail_GetRow_Result
    {
        public decimal SrNo { get; set; }
        public string PayTyp { get; set; }
        public string PayTypCd { get; set; }
        public string PayCd { get; set; }
        public string PayCodeCd { get; set; }
        public DateTime? EffDt { get; set; }
        public string FormatedEffDt { get; set; }
        public string PercAmt { get; set; }
        public decimal Current { get; set; }
        public decimal Incremented { get; set; }
        public string Narr { get; set; }
        public string TransNo { get; set; }
    }
}
