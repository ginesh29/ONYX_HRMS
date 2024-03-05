using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpLeaveSalaryModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Trans. Ref No")]
        public string TransNo { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Transaction Date")]
        public DateTime? TransDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Employee")]
        public string EmployeeCode { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Leave Salary")]
        public decimal LvSalary { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Leave Ticket")]
        public decimal LvTicket { get; set; }
        public string EntryBy { get; set; }
    }
}
