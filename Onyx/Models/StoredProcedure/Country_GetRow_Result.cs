namespace Onyx.Models.StoredProcedure
{
    public class Country_GetRow_Result
    {
        public string Code { get; set; }
        public string ShortDesc { get; set; }
        public string Description { get; set; }
        public string Nationality { get; set; }
        public string Region { get; set; }
        public int Provisions { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
    }
}
