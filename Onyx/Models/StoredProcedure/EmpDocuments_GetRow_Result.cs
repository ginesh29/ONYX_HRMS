namespace Onyx.Models.StoredProcedure
{
    public class EmpDocuments_GetRow_Result
    {
        public string EmpCd { get; set; }
        public string EmpName { get; set; }
        public string DocTypSDes { get; set; }
        public string DocNo { get; set; }
        public string OthRefNo { get; set; }
        public DateTime? IssueDt { get; set; }
        public DateTime? ExpDt { get; set; }
        public string FormatedIssueDt { get; set; }
        public string FormatedExpDt { get; set; }
        public string IssuePlace { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string FormatedEntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string FormatedEditDt { get; set; }
        public string Filter { get; set; }
        public string DocTypCd { get; set; }
        public decimal SrNo { get; set; }
        public bool Expiry { get; set; }
    }
}
