namespace Onyx.Models.StoredProcedure
{
    public class EmpCalendar_GetRow_Result
    {
        public int? SrNo { get; set; }
        public string EmpCd { get; set; }
        public DateTime Date { get; set; }
        public bool Holiday { get; set; }
        public string Title { get; set; }
        public string Narr { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
    }
}
