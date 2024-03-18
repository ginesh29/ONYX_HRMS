using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpprovisionsadjModel
    {
        [Display(Name = "Trans. No")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string TransNo { get; set; }
        [Display(Name = "Trans. Date")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime TransDt { get; set; }
        public string RefDoc { get; set; }
        public DateTime RefDt { get; set; }
        [Display(Name = "Employee")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string EmpCd { get; set; }
        [Display(Name = "Provision Type")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string ProvTyp { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public int Days { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Amount")]
        public double Amt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Purpose { get; set; }
        [Display(Name = "Narration")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Narr { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Status { get; set; }
        public string ApprBy { get; set; }
        public DateTime ApprDt { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime EditDt { get; set; }

        public string FormattedTransDt { get; set; }
        public string Name { get; set; }
        public string Prov { get; set; }
        public int CurrentApprovalLevel { get; set; }
        public string CurrentApproval { get; set; }
    }
}
