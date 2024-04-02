using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmployeeFilterModel
    {
        [Display(Name = "Employee Name/Code")]
        public string Name { get; set; }
        public string Branches { get; set; }
        public string Departments { get; set; }
        public string Sponsors { get; set; }
        public string Designations { get; set; }
        [Display(Name = "Employee Type")]
        public string EmployeeTypes { get; set; }
        [Display(Name = "Leave Status")]
        public string LeaveStatus { get; set; }
        [Display(Name = "Employee Status")]
        public string EmployeeStatus { get; set; }
    }
}
