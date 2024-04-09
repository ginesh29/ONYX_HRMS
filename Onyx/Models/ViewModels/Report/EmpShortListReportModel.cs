using Onyx.Models.StoredProcedure.Report;

namespace Onyx.Models.ViewModels.Report
{
    public class EmpShortListReportModel
    {
        public List<GetRepo_EmpShortList_Result> Employees { get; set; }
        public List<string> VisibleColumns { get; set; }
    }
}
