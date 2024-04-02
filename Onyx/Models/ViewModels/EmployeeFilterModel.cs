using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmployeeFilterModel
    {
        [Display(Name = "Employee Name/Code")]
        public string Name { get; set; }
        public List<string> Branches { get; set; }
        public List<string> Departments { get; set; }
        public List<string> Sponsors { get; set; }
        public List<string> Designations { get; set; }
        [Display(Name = "Employee Type")]
        public List<string> EmployeeTypes { get; set; }
        [Display(Name = "Leave Status")]
        public string LeaveStatus { get; set; }
        [Display(Name = "Employee Status")]
        public string EmployeeStatus { get; set; }
        public bool Active { get; set; } = true;
    }
}
