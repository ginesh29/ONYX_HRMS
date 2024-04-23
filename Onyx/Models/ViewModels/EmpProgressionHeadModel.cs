using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpProgressionHeadModel
    {
        [Display(Name = "Trans. No")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string TransNo { get; set; }
        [Display(Name = "Trans. Date")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? TransDt { get; set; }
        public string FormatedTransDt { get; set; }
        [Display(Name = "Employee")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string EmpCode { get; set; }
        public string Name { get; set; }
        public string EmpName { get; set; }
        public string DesigFrom { get; set; }

        public string DesigTo { get; set; }
        [Display(Name = "Designation From")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string DesigFromCd { get; set; }
        [Display(Name = "Designation To")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string DesigToCd { get; set; }
        public string ApprName { get; set; }
        public string ApprBy { get; set; }
        public DateTime? ApprDt { get; set; }
        public string FormatedApprDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Remarks { get; set; }
        public string Status { get; set; }
        public string StatusCd { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string EP_Typ { get; set; }
        [Display(Name = "Progression Type")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string EP_TypeCd { get; set; }
        public decimal? Current_Approval_Level { get; set; }
        public string Current_Approval { get; set; }
        public string PayTyp { get; set; }
        [Display(Name = "Pay Type")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string PayTypCd { get; set; }
        public string PayCd { get; set; }
        [Display(Name = "Component")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string PayCodeCd { get; set; }
        [Display(Name = "Effective Date")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? EffDt { get; set; }
        [Display(Name = "%/Amount")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string PercAmt { get; set; }
        [Display(Name = "Current Amount")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public decimal CurrentAmt { get; set; }
        [Display(Name = "Revised Amount")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public decimal RevisedAmt { get; set; }
        public string EntryBy { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Narr { get; set; }
    }
}
