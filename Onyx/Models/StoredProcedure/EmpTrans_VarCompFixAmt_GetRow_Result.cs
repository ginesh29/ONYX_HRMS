namespace Onyx.Models.StoredProcedure
{
    public class EmpTrans_VarCompFixAmt_GetRow_Result
    {
        public int SrNo { get; set; }
        public string Cd { get; set; }
        public string EmpName { get; set; }
        public string Branch { get; set; }
        public string Dept { get; set; }
        public decimal Amt { get; set; }
        public string Status { get; set; }
        public string Curr { get; set; }
        public bool IsValid { get; set; }
        public string ErrorMessage { get; set; }
        public string Narr { get; set; }
        public string TransId { get; set; }
        public bool Active { get; set; }
    }
}
