namespace Onyx.Models.StoredProcedure
{
    public class EmpLoan
    {
        public DateTime TransDt { get; set; }
        public decimal ApprAmt { get; set; }
        public decimal? NoInst { get; set; }
        public string Type { get; set; }
        public string Status { get; set; }
        public string Reason { get; set; }
    }

    public class EmpLeave
    {
        public DateTime TransDt { get; set; }
        public DateTime FromDt { get; set; }
        public DateTime ToDt { get; set; }
        public int? NoOfDays { get; set; }
        public string Type { get; set; }
        public string LvStatus { get; set; }
        public string Reason { get; set; }
    }
    public class EmplLoanAndLeaveHistory_Result
    {
        public IEnumerable<EmpLeave> EmpLeaves { get; set; }
        public IEnumerable<EmpLoan> EmpLoans { get; set; }
    }
}
