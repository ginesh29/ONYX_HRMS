using Onyx.Models.StoredProcedure;

namespace Onyx.Models.ViewModels
{
    public class VariablePayDedComponentModel
    {
        public List<EmpTrans_VarCompFixAmt_GetRow_Result> VariableComponentsData { get; set; }
        public VariablePayDedComponentFilterModel FilterModel { get; set; }
    }
}
