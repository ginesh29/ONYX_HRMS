namespace Onyx.Models.StoredProcedure
{
    public class GetRepo_EmpFinalSettlement_Result
    {
        public string Cd { get; set; }
        public string Name { get; set; }
        public DateTime DOJ { get; set; }
        public string Branch { get; set; }
        public string CC { get; set; }
        public string Dept { get; set; }
        public string Designation { get; set; }
        public string Nationality { get; set; }
        public string Religion { get; set; }
        public string Shift { get; set; }
        public decimal Basic { get; set; }
        public decimal Allowance { get; set; }
        public int? DaysWorked { get; set; }
        public int? DaysUnPaid { get; set; }
        public decimal PayableDays { get; set; }
        public string INDPAY_AL { get; set; }
        public decimal AnnLv { get; set; }
        public decimal GTProv_OpDays { get; set; }
        public decimal GTProv_OpAmt { get; set; }
        public decimal GTProv_Days { get; set; }
        public decimal GTProv_Amt { get; set; }
        public decimal GTProv_ActDays { get; set; }
        public decimal GTProv_ActAmt { get; set; }
        public decimal LSProv_OpDays { get; set; }
        public decimal LSProv_OpAmt { get; set; }
        public decimal LSProv_Days { get; set; }
        public decimal LSProv_Amt { get; set; }
        public decimal LSProv_ActDays { get; set; }
        public decimal LSProv_ActAmt { get; set; }
        public decimal LTProv_OpDays { get; set; }
        public decimal LTProv_OpAmt { get; set; }
        public decimal LTProv_Days { get; set; }
        public decimal LTProv_Amt { get; set; }
        public decimal LTProv_ActDays { get; set; }
        public decimal LTProv_ActAmt { get; set; }
        public decimal BNProv_Days { get; set; }
        public decimal BNProv_Amt { get; set; }
        public decimal NoticePay { get; set; }
        public string GT { get; set; }
        public int Result { get; set; }
        public decimal? LvOpBal { get; set; }
        public decimal? LvUsed { get; set; }
        public DateTime Lastworking { get; set; }
        public int? LastMonthworkingDays { get; set; }
        public decimal LoanBalance { get; set; }
        public decimal NoTickets { get; set; }
    }
}
