namespace Onyx.Models.StoredProcedure
{
    public class Notification_GetRow_Result
    {
        public string CoCd { get; set; }
        public string ProcessId { get; set; }
        public string DocTyp { get; set; }
        public string DocTypDes { get; set; }
        public int SrNo { get; set; }
        public string NotificationType { get; set; }
        public int NoOfDays { get; set; }
        public string BeforeOrAfter { get; set; }
        public string MessageBody { get; set; }
        public string EmailIds { get; set; }
    }
}
