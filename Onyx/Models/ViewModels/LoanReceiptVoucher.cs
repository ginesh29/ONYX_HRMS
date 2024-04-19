using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class LoanReceiptVoucher
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Trans. Ref No")]
        public string TransNo { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Payment Date")]
        public DateTime? PaymentDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Employee")]
        public string EmployeeCode { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Pay Amount")]
        public decimal PayAmt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Approved Amount")]
        public decimal? ApprAmt { get; set; }
        [Display(Name = "Recovery Mode")]
        public string RecoMode { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Loan Type")]
        public string LoanTypeCd { get; set; }
        [Display(Name = "Balance Amount")]
        public decimal? Balance { get; set; }
    }
}
