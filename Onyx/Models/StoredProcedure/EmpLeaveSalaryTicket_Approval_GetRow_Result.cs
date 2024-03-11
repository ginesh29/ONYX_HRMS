namespace Onyx.Models.StoredProcedure
{
    public class EmpLeaveSalaryTicket_Approval_GetRow_Result
    {
        public string TransNo { get; set; }
        public DateTime? TransDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmpCd { get; set; }
        public string Emp { get; set; }
        public decimal? LvSalary { get; set; }
        public decimal? LvTicket { get; set; }
        public decimal? Current_Approval_Level { get; set; }
        public string Current_Approval { get; set; }
        public string Approvals { get; set; }
    }
}
