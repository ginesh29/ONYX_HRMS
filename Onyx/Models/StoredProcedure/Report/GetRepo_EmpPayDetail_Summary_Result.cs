namespace Onyx.Models.StoredProcedure.Report
{
    public class GetRepo_EmpPayDetail_Summary_Result
    {
        public string Cd { get; set; }
        public string EmpName { get; set; }
        public decimal MonthPay { get; set; }
        public decimal LS { get; set; }
        public decimal LT { get; set; }
        public decimal Additions { get; set; }
        public decimal Deductions { get; set; }
        public string Curr { get; set; }
        public string Company { get; set; }
        public string Prd { get; set; }
        public string Yr { get; set; }
        public string Type { get; set; }
        public string Branch { get; set; }
    }
}
