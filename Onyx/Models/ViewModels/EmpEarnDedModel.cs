using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpEarnDedModel
    {
        [Display(Name = "Employee")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string EmpCd { get; set; }
        public string Emp { get; set; }
        public string Type { get; set; }
        public string Description { get; set; }
        public string Currency { get; set; }
        [Display(Name = "Amount Value")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public decimal? Amt { get; set; }
        [Display(Name = "Percentage Value")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public decimal? PercVal { get; set; }
        public decimal? Basic { get; set; }
        [Display(Name = "Effective Date")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? EffDt { get; set; }
        public string FormatedEffDt { get; set; }
        public DateTime? EndDt { get; set; }
        public string FormatedEndDt { get; set; }
        [Display(Name = "Component")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string EdCd { get; set; }
        [Display(Name = "Component Type")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string EdTyp { get; set; }
        public string CurrCd { get; set; }
        [Display(Name = "Perc/Amt")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string PercAmt { get; set; }
        public int SrNo { get; set; }
        public string ComponentClass { get; set; }
        public string EntryBy { get; set; }
        public string Cd { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Cd) ? "U" : "I";
            }
        }
    }
}
