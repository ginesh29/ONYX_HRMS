using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpLoanModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Trans. Ref No")]
        public string TransNo { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Transaction Date")]
        public DateTime? TransDt { get; set; }
        public string FormatedTransDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Employee")]
        public string EmployeeCode { get; set; }
        public string EmpName { get; set; }
        public string EmpBranch { get; set; }
        public string LoanType { get; set; }
        public string DocRef { get; set; }
        public string DocDt { get; set; }
        public string FormatedDocDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Amount")]
        public decimal? Amt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
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
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "No. of Installment")]
        public decimal? NoInstReq { get; set; }
        public DateTime? DedStartDt { get; set; }
        public string FormatedDedStartDt { get; set; }
        public string Guarantor { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Guarantor Name")]
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
        public string CompanyName { get; set; }
        public string CompanyAdress { get; set; }
        public string CompanyFax { get; set; }
        public string CompanyPhone { get; set; }
        public string CompanyEmail { get; set; }
        public string CompanyLogo { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Loan Type")]
        public string LoanTypeCd { get; set; }
        public decimal? Balance { get; set; }
        public decimal DetailSrno { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Guarantor Details")]
        public string GuarantorDetails { get; set; }
        public string Approvals { get; set; }
        public string PrintApproval { get; set; }
        public string Desg { get; set; }
        public string EntryBy { get; set; }
    }
}
