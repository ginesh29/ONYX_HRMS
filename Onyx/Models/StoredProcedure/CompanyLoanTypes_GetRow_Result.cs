namespace Onyx.Models.StoredProcedure
{
    public class CompanyLoanTypes_GetRow_Result
    {
        public string Cd { get; set; }
        public string Des { get; set; }
        public string PayTyp { get; set; }
        public string PayComp { get; set; }
        public string DedTyp { get; set; }
        public string DedComp { get; set; }
        public string Abbr { get; set; }
        public string Sdes { get; set; }
        public string ChgsTyp { get; set; }
        public string ChgsTypCd { get; set; }
        public decimal? IntPerc { get; set; }
        public string PayCd { get; set; }
        public string DedCd { get; set; }
        public string DedTypCd { get; set; }
        public string PayTypCd { get; set; }
        public bool Active { get; set; }
    }
}
