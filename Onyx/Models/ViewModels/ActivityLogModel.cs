namespace Onyx.Models.ViewModels
{
    public class ActivityLogModel
    {
        public string CoCd { get; set; }
        public long ActivityId { get; set; }
        public string SessionId { get; set; }
        public string UserCd { get; set; }
        public string IP { get; set; }
        public string OS { get; set; }
        public string Browser { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public string Type { get; set; }
    }
}
