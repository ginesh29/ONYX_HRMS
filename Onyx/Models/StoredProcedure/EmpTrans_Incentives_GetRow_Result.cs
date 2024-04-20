namespace Onyx.Models.StoredProcedure
{
    public class EmpTrans_Incentives_GetRow_Result
    {
        public string Cd { get; set; }
        public string EmpName { get; set; }
        public string Branch { get; set; }
        public string Dept { get; set; }
        public decimal Amt { get; set; }
        public decimal Amt1 { get; set; }
        public string Status { get; set; }
        public string Image { get; set; }
        public decimal Salary { get; set; }
        public string SalTyp { get; set; }
        public decimal? Attendance { get; set; }
        public decimal SalesAmt { get; set; }
        public string Curr { get; set; }
        public int SrNo { get; set; }
        public bool Active { get; set; }
        public bool IsValid { get; set; }
        public string ErrorMessage { get; set; }
    }
}
