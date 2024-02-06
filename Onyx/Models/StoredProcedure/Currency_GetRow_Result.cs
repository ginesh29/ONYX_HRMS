namespace Onyx.Models.StoredProcedure
{
    public class Currency_GetRow_Result
    {
        public string Code { get; set; }
        public string Des { get; set; }
        public string MainCurr { get; set; }
        public string SubCurr { get; set; }
        public int NoDecs { get; set; }
        public decimal Rate { get; set; }
        public string Symbol { get; set; }
        public string Abbr { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string HrCurr { get; set; }
    }
}
