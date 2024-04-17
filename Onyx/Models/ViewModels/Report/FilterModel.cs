using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels.Report
{
    public class EmpShortListFilterModel
    {
        public string EmpCd { get; set; }
        public List<string> Sponsors { get; set; }
        public List<string> Branches { get; set; }
        public string Section { get; set; }
        public string Department { get; set; }
        public List<string> Nationalities { get; set; }
        public string Designation { get; set; }
        public string Age { get; set; }
        public string Qualification { get; set; }
        public List<string> EmployeeTypes { get; set; }
        public List<string> Statuses { get; set; }
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
    public class EmpTranferFilterModel
    {
        public string EmpCd { get; set; }
        public string BranchFrom { get; set; }
        public string BranchTo { get; set; }
        public string SectionFrom { get; set; }
        public string SectionTo { get; set; }
        public string DepartmentFrom { get; set; }
        public string DepartmentTo { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string DateRange { get; set; }
    }
    public class EmpLoanFilterModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Branch")]
        public string BranchCd { get; set; }
        public string Period { get; set; }
        public string EmpCd { get; set; }
        public string Year { get; set; }
        public string Status { get; set; }
    }
    public class EmpLoanAnalysisFilterModel
    {
        public string EmpCd { get; set; }
        public string Sponsor { get; set; }
        public string Branch { get; set; }
        public string Section { get; set; }
        public string Department { get; set; }
        public string Nationality { get; set; }
        public string Designation { get; set; }
        public string LoanType { get; set; }
        public string LoanStatus { get; set; }
    }
    public class EmpLeaveAnalysisFilterModel
    {
        public string EmpCd { get; set; }
        public string Sponsor { get; set; }
        public string Branch { get; set; }
        public string Section { get; set; }
        public string Department { get; set; }
        public string Designation { get; set; }
        public string LeaveType { get; set; }
        public string LeaveStatus { get; set; }
        public string DateRange { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string OrderBy { get; set; }
    }
    public class ExpiredDocFilterModel
    {
        public string Type { get; set; }
        public string DocType { get; set; }
        public string DateRange { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
