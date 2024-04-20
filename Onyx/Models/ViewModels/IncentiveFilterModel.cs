using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class IncentiveFilterModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Branch { get; set; }
        public string Designation { get; set; }
        [Display(Name = "Employee")]
        public string EmpCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Month/Year")]
        public string MonthYear { get; set; }
        public string Prd { get; set; }
        public string Year { get; set; }
        public string EmpType { get; set; }
        public DateTime FromDt { get; set; }
        public DateTime ToDt { get; set; }
        public string EntryBy { get; set; }
    }
}
