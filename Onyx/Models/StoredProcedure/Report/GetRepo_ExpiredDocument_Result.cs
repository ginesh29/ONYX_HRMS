namespace Onyx.Models.StoredProcedure.Report
{
    public class GetRepo_ExpiredDocument_Result
    {
        public string Cd { get; set; }
        public string Name { get; set; }
        public string DocTypCd { get; set; }
        public string DocTypSDes { get; set; }
        public decimal SrNo { get; set; }
        public string DocNo { get; set; }
        public string OthRefNo { get; set; }
        public DateTime IssueDt { get; set; }
        public DateTime ExpDt { get; set; }
        public string FormattedIssueDt { get; set; }
        public string FormattedExpDt { get; set; }
        public string IssuePlace { get; set; }
        public string Seacrh { get; set; }
        public string CoName { get; set; }
        public string Type { get; set; }
        public string BrCd { get; set; }
        public int NoOfDays { get; set; }
        public string VehCd { get; set; }
    }
}
