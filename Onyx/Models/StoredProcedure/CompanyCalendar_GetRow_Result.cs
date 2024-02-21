namespace Onyx.Models.StoredProcedure
{
    public class CompanyCalendar_GetRow_Result
    {
        public string Cd { get; set; }
        public DateTime Date { get; set; }
        public bool Holiday { get; set; }
        public string Title { get; set; }
        public string MessageBody { get; set; }
        public string EmailSubject { get; set; }
        public string CoCd { get; set; }
    }
}
