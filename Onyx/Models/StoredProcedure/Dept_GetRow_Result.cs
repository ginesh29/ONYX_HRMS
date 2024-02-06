namespace Onyx.Models.StoredProcedure
{
    public class Dept_GetRow_Result
    {
        public string Code { get; set; }
        public string Department { get; set; }
        public string Description { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
    }
}
