namespace Onyx.Models.StoredProcedure
{
    public class EmpLoan_Approval_GetRow_Result
    {
        public string TransNo { get; set; }
        public DateTime? TransDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmployeeCode { get; set; }
        public string EmpName { get; set; }
        public string Desg { get; set; }
        public string LoanType { get; set; }
        public string DocRef { get; set; }
        public string DocDt { get; set; }
        public string FormatedDocDt { get; set; }
        public int? Amt { get; set; }
        public int? NoInstReq { get; set; }
        public string Purpose { get; set; }
        public string Narr { get; set; }
        public string LoanApprBy { get; set; }
        public string ApprovalName { get; set; }
        public DateTime? LoanApprDt { get; set; }
        public string FormatedLoanApprDt { get; set; }
        public decimal? ApprAmt { get; set; }
        public string RecoMode { get; set; }
        public decimal? RecoPrd { get; set; }
        public decimal? NoInst { get; set; }
        public DateTime? DedStartDt { get; set; }
        public string FormatedDedStartDtDt { get; set; }
        public string Guarantor { get; set; }
        public string GuarantorName { get; set; }
        public string GuarantorDetails { get; set; }
        public string LoanStatus { get; set; }
        public string PayMode { get; set; }
        public string ChgsTyp { get; set; }
        public decimal? ChgsPerc { get; set; }
        public string ImagePath { get; set; }
    }
}
