namespace Onyx.Models.StoredProcedure
{
    public class VehDocuments_GetRow_Result
    {
        public int SrNo { get; set; }
        public string VehCd { get; set; }
        public string VehName { get; set; }
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
    }
}
