using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpLeaveSalaryDisburseModel
    {
        public string TransNo { get; set; }
        public DateTime? AppDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmpCd { get; set; }
        public string Emp { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Leave Salary")]
        public decimal? LvSalary { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Leave Ticket")]
        public decimal? LvTicket { get; set; }
        public string ApprBy { get; set; }
        public DateTime? ApprDt { get; set; }
        public string FormatedApprDt { get; set; }
        public string Div { get; set; }
        public string Status { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Remarks { get; set; }
    }
}
