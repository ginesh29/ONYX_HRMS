namespace Onyx.Models.StoredProcedure.Report
{
    public class GetRepo_FixedPayrollCom_Result
    {
        public string EmpCd { get; set; }
        public string Name { get; set; }
        public string EdCd { get; set; }
        public string PayCode { get; set; }
        public string EdTyp { get; set; }
        public string PayType { get; set; }
        public string SrNo { get; set; }
        public decimal Amount { get; set; }
        public string CurrDes { get; set; }
        public string AmtDes { get; set; }
        public DateTime EffDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Branch { get; set; }
        public string Location { get; set; }
        public string CC { get; set; }
        public string Department { get; set; }
        public string PTYP { get; set; }
        public string CoName { get; set; }
        public decimal Basic { get; set; }
        public DateTime Last_Incr_Date { get; set; }
        public decimal Last_Increment_Amount { get; set; }
        public decimal Total { get; set; }
    }
}
