using Onyx.Models.StoredProcedure;

namespace Onyx.Models.ViewModels
{
    public class AttendanceModel
    {
        public List<EmpAttendance_Getrow_Result> AttendanceData { get; set; }
        public AttendanceFilterModel FilterModel { get; set; }
    }
}
