namespace Onyx.Models.StoredProcedure.Report
{
    public class GetRepo_EmpTransactionDetail_Result
    {
        public string Month { get; set; }
        public int Yr { get; set; }
        public int Prd { get; set; }
        public string Period { get; set; }
        public string Cd { get; set; }
        public string EmpName { get; set; }
        public string Branch { get; set; }
        public int BasicSalaray { get; set; }
        public int Deductions { get; set; }
        public int TMF { get; set; }
        public int Allowance { get; set; }
        public int OverTime { get; set; }
        public int Incentives { get; set; }
        public int LastSalary { get; set; }
        public int StaffAdvGiven { get; set; }
        public int StaffAdvCollected { get; set; }
        public int StaffFundGiven { get; set; }
        public int StaffFundCollected { get; set; }
        public int TMFPay { get; set; }
        public int LSA { get; set; }
        public int LTA { get; set; }
        public int Pension { get; set; }
        public string Description { get; set; }
    }
}
