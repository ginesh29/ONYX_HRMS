namespace Onyx.Models.StoredProcedure
{
    public class EmpLeaveSalaryTicket_View_Getrow_Result
    {
        public string TransNo { get; set; }
        public DateTime? AppDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmpCd { get; set; }
        public string Emp { get; set; }
        public decimal? LvSalary { get; set; }
        public decimal? LvTicket { get; set; }
        public string ApprBy { get; set; }
        public DateTime? ApprDt { get; set; }
        public string FormatedApprDt { get; set; }
        public string Div { get; set; }
    }
}
