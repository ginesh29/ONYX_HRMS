using Onyx.Models.StoredProcedure;
using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpLeaveConfirmModel
    {
        public string TransNo { get; set; }
        public DateTime? AppDt { get; set; }
        public string FormatedTransDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string EmpCd { get; set; }
        public string Emp { get; set; }
        public string LvTyp { get; set; }
        public int? LvTaken { get; set; }
        public DateTime? DocDt { get; set; }
        public string FormatedDocDt { get; set; }
        public string Substitute { get; set; }
        public DateTime? FromDt { get; set; }
        public string FormatedFromDt { get; set; }
        public DateTime? ToDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Date Range")]
        public string DateRange { get; set; }
        [Display(Name = "Date Range(WP)")]
        public string WpDateRange { get; set; }
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
        public DateTime? ApprDt { get; set; }
        public string FormatedApprDt { get; set; }
        public int? ApprDays { get; set; }
        public string Branch { get; set; }
        public string Designation { get; set; }
        public int LvDays { get; set; }
        public int WpLvDays { get; set; }
        public int WopLvDays { get; set; }
        public string Remark { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public int? Type { get; set; }
        public decimal? Ticket { get; set; }
        [Display(Name = "Leave Salary")]
        public decimal? LvSalary { get; set; }
        public bool SinglePayroll { get; set; }
        public bool PrintAfterSave { get; set; }
        public List<EmpAttendance_Salary_SinglePayroll_Result> Salary_SinglePayrollAttendanceData { get; set; }
        public List<EmpComponent_Salary_SinglePayroll_Result> Component_SinglePayrollAttendanceData { get; set; }
    }
}
