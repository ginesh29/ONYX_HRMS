namespace Onyx.Models.StoredProcedure.Report
{
    public class GetRepo_Currency_Result
    {
        public string Cd { get; set; }
        public string Des { get; set; }
        public string MainCurr { get; set; }
        public string SubCurr { get; set; }
        public decimal? NoDecs { get; set; }
        public decimal Rate { get; set; }
        public string CoName { get; set; }
    }
}
