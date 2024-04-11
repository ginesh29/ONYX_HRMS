namespace Onyx.Models.StoredProcedure.Report
{
    public class EmpLeaveMaster_GetRow_Result
    {
        public string EmpCd { get; set; }
        public string EmpName { get; set; }
        public string EmpCd_Name { get; set; }
        public string LvTyp { get; set; }
        public string LvTypDes { get; set; }
        public decimal MaxLv { get; set; }
        public decimal LvOpBal { get; set; }
        public decimal LvUsed { get; set; }
        public decimal LvAccr { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public decimal? CumLvNoPay { get; set; }
        public decimal? BalanceLeave { get; set; }
        public string LeaveDueDate { get; set; }
        public string CoName { get; set; }
    }
}
