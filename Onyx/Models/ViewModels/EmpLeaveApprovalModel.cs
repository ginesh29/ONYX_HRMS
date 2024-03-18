using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpLeaveApprovalModel
    {
        public string TransNo { get; set; }
        public DateTime? TransDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmpCd { get; set; }
        public string Emp { get; set; }
        public string LvTyp { get; set; }
        public int? LvTaken { get; set; }
        public DateTime? DocDt { get; set; }
        public string FormatedDocDt { get; set; }
        public string Substitute { get; set; }
        public DateTime? LvFrom { get; set; }
        public string FormatedFromDt { get; set; }
        public DateTime? LvTo { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Date Range(WP)")]
        public string LvDateRange { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Date Range(WOP)")]
        public string WopDateRange { get; set; }
        public string FormatedToDt { get; set; }
        public string LvInter { get; set; }
        public DateTime? WpFrom { get; set; }
        public string FormatedWP_FromDt { get; set; }
        public DateTime? WpTo { get; set; }
        public string FormatedWp_ToDt { get; set; }
        public DateTime? WopFrom { get; set; }
        public string FormatedWOP_FromDt { get; set; }
        public DateTime? WopTo { get; set; }
        public string FormatedWOP_ToDt { get; set; }
        public string ApprBy { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Approval Date")]
        public DateTime? ApprDt { get; set; }
        public string FormatedApprDt { get; set; }
        public decimal? ApprDays { get; set; }
        public string Branch { get; set; }
        public string Desg { get; set; }
        public string Reason { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Remark { get; set; }
        public int LvDays { get; set; }
        public int WopLvDays { get; set; }
        public string Status { get; set; }
        public string EntryBy { get; set; }
        public int Current_Approval_Level { get; set; }
    }
}
