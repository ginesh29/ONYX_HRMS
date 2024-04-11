namespace Onyx.Models.StoredProcedure.Report
{
    public class GetRepo_EmpLoan_Result
    {
        public string TransNo { get; set; }
        public string TransTyp { get; set; }
        public DateTime TransDt { get; set; }
        public string FormattedTransDt { get; set; }
        public string LoanTyp { get; set; }
        public string EmpCd { get; set; }
        public string EmpName { get; set; }
        public string EmpBranch { get; set; }
        public string DocRef { get; set; }
        public string DocDt { get; set; }
        public string FormattedDocDt { get; set; }
        public decimal Amt { get; set; }
        public string Purpose { get; set; }
        public decimal ApprAmt { get; set; }
        public string LoanApprBy { get; set; }
        public string ApprName { get; set; }
        public DateTime LoanApprDt { get; set; }
        public string FormattedLoanApprDt { get; set; }
        public decimal? ChgsPerc { get; set; }
        public decimal? ChgsAmt { get; set; }
        public string RecoMode { get; set; }
        public DateTime? DedStartDt { get; set; }
        public string RecoPrd { get; set; }
        public string NoInst { get; set; }
        public string Guarantor { get; set; }
        public string GuarantorName { get; set; }
        public string GuarantorDetails { get; set; }
        public string Narr { get; set; }
        public string LoanStatus { get; set; }
        public string PayMode { get; set; }
        public string ChgsTyp { get; set; }
        public string CoName { get; set; }
    }
}
