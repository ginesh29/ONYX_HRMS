namespace Onyx.Models.StoredProcedure
{
    public class EmpDocIssueRcpt_GetRow_Result
    {
        public string EmployeeCode { get; set; }
        public string EmpName { get; set; }
        public int SrNo { get; set; }
        public string DocType { get; set; }
        public string DocTypCd { get; set; }
        public string DocNo { get; set; }
        public DateTime? IssueDt { get; set; }
        public DateTime? ExpDt { get; set; }
        public string FormatedIssueDt { get; set; }
        public string FormatedExpDt { get; set; }
        public string IssuePlace { get; set; }
        public string DocTypeDes { get; set; }
        public string FormatedTransDate { get; set; }
        public DateTime? TransDate { get; set; }
        public string TrnTypDes { get; set; }
        public string TrnTyp { get; set; }
        public string DocumentStatus { get; set; }
        public string Narr { get; set; }
        public string DocStat { get; set; }
        public string Status { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDate { get; set; }
        public string EditedBy { get; set; }
        public DateTime? EditDate { get; set; }
        public DateTime? TrnDt { get; set; }
        public DateTime? ApprDate { get; set; }
        public string ApprBy { get; set; }
        public string FormatedApprDate { get; set; }
        public decimal? Current_Approval_Level { get; set; }
        public string Current_Approval { get; set; }
        public string ImagePath { get; set; }
        public IEnumerable<IFormFile> DocFiles { get; set; }
    }
}
