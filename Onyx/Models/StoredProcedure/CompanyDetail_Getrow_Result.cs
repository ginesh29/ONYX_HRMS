namespace Onyx.Models.StoredProcedure
{
    public class CompanyDetail_Getrow_Result
    {
        public string Cd { get; set; }
        public string CoName { get; set; }
        public string Add1 { get; set; }
        public string Add2 { get; set; }
        public string Add3 { get; set; }
        public string Phone { get; set; }
        public string Logo { get; set; }
        public string Fax { get; set; }
        public string Email { get; set; }
        public int QtyDecs { get; set; }
        public int AmtDecs { get; set; }
        public string BaseCurr { get; set; }
        public string RptCurr { get; set; }
        public DateTime? FinBeginDt { get; set; }
        public string FormatedFinBeginDt { get; set; }
        public DateTime? FinEndDt { get; set; }
        public string FormatedFinEndDt { get; set; }
        public int? Prd { get; set; }
        public int? Year { get; set; }
        public string DayDate { get; set; }
    }
}
