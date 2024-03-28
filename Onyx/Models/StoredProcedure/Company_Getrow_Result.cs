namespace Onyx.Models.StoredProcedure
{
    public class Company_Getrow_Result
    {
        public string Cd { get; set; }
        public string CoName { get; set; }
        public string Abbr { get; set; }
        public string CoGrp { get; set; }
        public DateTime? FinBeginDt { get; set; }
        public DateTime? FinEndDt { get; set; }
        public string ServerId { get; set; }
    }
}
