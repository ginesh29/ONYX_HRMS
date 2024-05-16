namespace Onyx.Models.StoredProcedure
{
    public class ActivityLogDetail_Getrow_Result
    {
        public long ActivityId { get; set; }
        public decimal SrNo { get; set; }
        public string ProcessId { get; set; }
        public string ActivityTyp { get; set; }
        public string Mesg { get; set; }
        public DateTime TimeStamp { get; set; }
    }
}
