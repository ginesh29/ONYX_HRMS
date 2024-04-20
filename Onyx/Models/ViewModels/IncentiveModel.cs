using Onyx.Models.StoredProcedure;

namespace Onyx.Models.ViewModels
{
    public class IncentiveModel
    {
        public List<EmpTrans_Incentives_GetRow_Result> IncentiveData { get; set; }
        public IncentiveFilterModel FilterModel { get; set; }
    }
}
