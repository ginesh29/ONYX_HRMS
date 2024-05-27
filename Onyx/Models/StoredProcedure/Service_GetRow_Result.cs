namespace Onyx.Models.StoredProcedure
{
    public class Service_GetRow_Result
    {
        public string Cd { get; set; }
        public string Name { get; set; }
        public string Prefix { get; set; }
        public bool Active { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
    }
}
