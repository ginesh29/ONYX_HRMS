using Onyx.Models.StoredProcedure;

namespace Onyx.Models.ViewModels
{
    public class EmpProfileGrid
    {
        public IEnumerable<Employee_GetRow_Result> Employees { get; set; }
        public int TotalCount { get; set; }
    }
}
