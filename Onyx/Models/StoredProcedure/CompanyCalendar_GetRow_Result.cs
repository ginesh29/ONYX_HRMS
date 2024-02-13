namespace Onyx.Models.StoredProcedure
{
    public class CompanyCalendar_GetRow_Result
    {
        public string Cd { get; set; }
        public DateTime Date { get; set; }
        public bool Holiday { get; set; }
        public string Description { get; set; }
        public string MeetingLink { get; set; }
        public string CoCd { get; set; }
    }
}
