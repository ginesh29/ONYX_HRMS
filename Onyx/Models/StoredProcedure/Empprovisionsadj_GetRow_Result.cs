namespace Onyx.Models.StoredProcedure
{
    public class Empprovisionsadj_GetRow_Result
    {
        public string TransNo { get; set; }
        public DateTime TransDt { get; set; }
        public string FormattedTransDt { get; set; }
        public string RefDoc { get; set; }
        public string EmpCd { get; set; }
        public string Name { get; set; }
        public string ProvTyp { get; set; }
        public string Prov { get; set; }
        public int Days { get; set; }
        public double Amt { get; set; }
        public string Purpose { get; set; }
        public string Narr { get; set; }
        public string ApprBy { get; set; }
        public DateTime RefDt { get; set; }
        public string Status { get; set; }
        public DateTime ApprDt { get; set; }
        public int CurrentApprovalLevel { get; set; }
        public string CurrentApproval { get; set; }
    }
}
