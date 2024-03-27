using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class VariablePayDedComponentFilterModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string Branch { get; set; }
        public string Department { get; set; }
        [Display(Name = "Employee Code")]
        public string EmpCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Month/Year")]
        public string MonthYear { get; set; }
        public string EntryBy { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Pay Type")]
        public string PayType { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Pay Code")]
        public string PayCode { get; set; }
        public DateTime FromDt { get; set; }
        public DateTime ToDt { get; set; }
    }
}
