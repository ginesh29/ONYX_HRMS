namespace Onyx.Models.ViewModels
{
    public class EmpLoanApprovalModel
    {
        public string TransNo { get; set; }
        public DateTime? TransDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmployeeCode { get; set; }
        public string EmpName { get; set; }
        public string EmpBranch { get; set; }
        public string LoanType { get; set; }
        public string DocRef { get; set; }
        public string DocDt { get; set; }
        public string FormatedDocDt { get; set; }
        public decimal? Amt { get; set; }
        public string Purpose { get; set; }
        public string Narr { get; set; }
        public string LoanApprBy { get; set; }
        public decimal? NoInst { get; set; }
        public DateTime? LoanApprDt { get; set; }
        public string FormatedLoanApprDt { get; set; }
        public string ApplicationStatus { get; set; }
        public decimal? ApprAmt { get; set; }
        public string RecoMode { get; set; }
        public decimal? RecoPrd { get; set; }
        public decimal? NoInstReq { get; set; }
        public DateTime? DedStartDt { get; set; }
        public string FormatedDedStartDt { get; set; }
        public string Guarantor { get; set; }
        public string GuarantorName { get; set; }
        public string LoanStatus { get; set; }
        public string PayMode { get; set; }
        public string ChgsTyp { get; set; }
        public decimal? ChgsPerc { get; set; }
        public DateTime? EntryDt { get; set; }
        public string FormatedEntryDt { get; set; }
        public string CoName { get; set; }
        public string Loaction { get; set; }
        public string Sponsor { get; set; }
        public decimal? Current_Approval_Level { get; set; }
        public string Current_Approval { get; set; }
        public string Reco_Mode { get; set; }
        public string Reco_Prd { get; set; }
        public string CompanyName { get; set; }
        public string CompanyAdress { get; set; }
        public string CompanyFax { get; set; }
        public string CompanyPhone { get; set; }
        public string CompanyEmail { get; set; }
        public string CompanyLogo { get; set; }
        public string LoanTypeCd { get; set; }
        public decimal? Balance { get; set; }
        public decimal DetailSrno { get; set; }
        public string GuarantorDetails { get; set; }
        public string Approvals { get; set; }
        public string PrintApproval { get; set; }
        public string Desg { get; set; }
    }
}
