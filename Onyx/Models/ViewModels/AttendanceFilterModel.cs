using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class AttendanceFilterModel
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
        [Display(Name = "Hrs/Day")]
        public string WorkingHrDay { get; set; }
    }
}
