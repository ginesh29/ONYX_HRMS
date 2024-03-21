using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;

namespace Onyx.Models
{
    public class AttendanceModel
    {
        public List<EmpAttendance_Getrow_Result> AttendanceData { get; set; }
        public AttendanceFilterModel FilterModel { get; set; }
    }
}
