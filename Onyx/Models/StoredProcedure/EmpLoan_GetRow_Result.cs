using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
{
    public class EmpLoan_GetRow_Result
    {
        public string TransNo { get; set; }
        public DateTime TransDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmployeeCode { get; set; }
        public string EmpName { get; set; }
        public string EmpBranch { get; set; }
        public string EmpBranchCd { get; set; }
        public string LoanType { get; set; }
        public string DocRef { get; set; }
        public string DocDt { get; set; }
        public string FormatedDocDt { get; set; }
        public int Amt { get; set; }
        public string Purpose { get; set; }
        [Display(Name = "Narration")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Narr { get; set; }
        public string LoanApprBy { get; set; }
        [Display(Name = "No of Installments")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public decimal? NoInst { get; set; }
        [Display(Name = "Approved Date")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? LoanApprDt { get; set; }
        public string FormatedLoanApprDt { get; set; }
        public string ApplicationStatus { get; set; }
        [Display(Name = "Approved Amount")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public int ApprAmt { get; set; }
        [Display(Name = "Recovery Mode")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string RecoMode { get; set; }
        public decimal? RecoPrd { get; set; }
        public decimal? NoInstReq { get; set; }
        [Display(Name = "Deduct. Start Date")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? DedStartDt { get; set; }
        public string FormatedDedStartDt { get; set; }
        [Display(Name = "Guarantor")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Guarantor { get; set; }
        public string GuarantorName { get; set; }
        [Display(Name = "Disburse/Cancel")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string LoanStatus { get; set; }
        [Display(Name = "Payment Mode")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string PayMode { get; set; }
        [Display(Name = "Charges Type")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string ChgsTyp { get; set; }
        [Display(Name = "Interest Rate %")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public decimal? ChgsPerc { get; set; }
        public DateTime? EntryDt { get; set; }
        public string FormatedEntryDt { get; set; }
        public string CoName { get; set; }
        public string Loaction { get; set; }
        public string Sponsor { get; set; }
        public int? Current_Approval_Level { get; set; }
        public string Current_Approval { get; set; }
        public string Reco_Mode { get; set; }
        [Display(Name = "Recovery Period")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string Reco_Prd { get; set; }
        public string CompanyName { get; set; }
        public string CompanyAdress { get; set; }
        public string CompanyFax { get; set; }
        public string CompanyPhone { get; set; }
        public string CompanyEmail { get; set; }
        public string CompanyLogo { get; set; }
        public string LoanTypeCd { get; set; }
        public int Balance { get; set; }
        public decimal DetailSrno { get; set; }
        [Display(Name = "Guarantor Details")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string GuarantorDetails { get; set; }
        public string Approvals { get; set; }
        public string PrintApproval { get; set; }
        public string Desg { get; set; }
        public string Mobile { get; set; }
        public int Salary { get; set; }
        public string EntryBy { get; set; }
    }
}
