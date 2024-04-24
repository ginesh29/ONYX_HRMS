using Onyx.Models.StoredProcedure;

namespace Onyx.Models.ViewModels
{
    public class EmpLeaveSinglePayrollModel
    {
        public List<EmpAttendance_Salary_SinglePayroll_Result> Salary_SinglePayrollAttendanceData { get; set; }
        public List<EmpComponent_Salary_SinglePayroll_Result> Component_SinglePayrollAttendanceData { get; set; }
    }
}
