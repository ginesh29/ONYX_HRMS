using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels.Report
{
    public class EmpShortListFilterModel
    {
        public string EmpCd { get; set; }
        public string Sponsor { get; set; }
        public string Branch { get; set; }
        public string Section { get; set; }
        public string Department { get; set; }
        public string Nationality { get; set; }
        public string Designation { get; set; }
        public string Age { get; set; }
        public string Qualification { get; set; }
        public string EmployeeType { get; set; }
        public string Status { get; set; }
        public string Period { get; set; }
        public bool Active { get; set; }
        public List<string> VisibleColumns { get; set; }
    }
    public class EmpTransactionFilterModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Employee")]
        public string EmpCd { get; set; }
        public string StartPeriod { get; set; }
        public string EndPeriod { get; set; }
    }
    public class BalanceTransactionFilterModel
    {
        [Display(Name = "Employee")]
        public string EmpCd { get; set; }
        public DateTime? ToDate { get; set; }
    }
    public class ProvisionFilterModel
    {
        [Display(Name = "Branch")]
        public string BranchCd { get; set; }
        public string Period { get; set; }
        public string ProvisionType { get; set; }
        public string Year { get; set; }
    }
    public class PaySlipFilterModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Branch")]
        public string BranchCd { get; set; }
        public string Period { get; set; }
        public string EmpCd { get; set; }
        public string Year { get; set; }
    }
}
