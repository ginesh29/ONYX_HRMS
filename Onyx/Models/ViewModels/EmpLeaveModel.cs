using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpLeaveModel
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
        public string EmployeeName { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Leave Type")]
        public string LeaveType { get; set; }
        public string IntLocal { get; set; }
        public DateTime? FromDt { get; set; }
        public string FormatedFromDt { get; set; }
        public DateTime? ToDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Date Range")]
        public string DateRange { get; set; }
        public string FormatedToDt { get; set; }
        public int LvTaken { get; set; }
        public string DocRef { get; set; }
        public string DocDt { get; set; }
        public string SubtituteCode { get; set; }
        public string SubstituteName { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Reason { get; set; }
        public string Narr { get; set; }
        public string LvApprBy { get; set; }
        public string LvStatus { get; set; }
        public string Typ { get; set; }
        public int? Joiningdays { get; set; }
        public int? Returningdays { get; set; }
        public string EntryBy { get; set; }
    }
}
