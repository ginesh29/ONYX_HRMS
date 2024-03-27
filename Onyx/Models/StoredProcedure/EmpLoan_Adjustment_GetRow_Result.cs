namespace Onyx.Models.StoredProcedure
{
    public class EmpLoan_Adjustment_GetRow_Result
    {
        public string TransNo { get; set; }
        public DateTime? TransDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmpCd { get; set; }
        public string EmpName { get; set; }
        public string LoanTyp { get; set; }
        public string DocRef { get; set; }
        public string DocDt { get; set; }
        public string FormatedDocDt { get; set; }
        public decimal? Amt { get; set; }
        public decimal? ApprAmt { get; set; }
        public string RecoPrd { get; set; }
        public decimal? NoInst { get; set; }
        public string LoanApprBy { get; set; }
        public string LoanApprName { get; set; }
        public DateTime? LoanApprDt { get; set; }
        public string FormatedLoanApprDt { get; set; }
        public DateTime? DedStartDt { get; set; }
        public string FormatedDedStartDt { get; set; }
        public string Guarantor { get; set; }
        public string GuarantorName { get; set; }
        public string LoanStatus { get; set; }
        public string PayMode { get; set; }
        public string ChgsTyp { get; set; }
        public decimal? ChgsPerc { get; set; }
        public string RecoMode { get; set; }
        public string Purpose { get; set; }
        public string Narr { get; set; }
        public string EntryBy { get; set; }
    }
}
