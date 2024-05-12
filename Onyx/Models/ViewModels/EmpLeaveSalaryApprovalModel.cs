using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpLeaveSalaryApprovalModel
    {
        public string Emp { get; set; }
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
        public string ApprBy { get; set; }
        public int ApprLvl { get; set; }
        public string Status { get; set; }
        public string EmpCd { get; set; }
        public int Current_Approval_Level { get; set; }
        public string Current_Approval { get; set; }
        public string Approvals { get; set; }
        public string Remarks { get; set; }
    }
}
