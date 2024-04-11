namespace Onyx.Models.StoredProcedure.Report
{
    public class GetRepo_EmpLoanDueList_Result
    {
        public string Empcd { get; set; }
        public string TransNo { get; set; }
        public DateTime ApprDate { get; set; }
        public string EmpName { get; set; }
        public decimal ApprAmt { get; set; }
        public string LoanTyp { get; set; }
        public decimal Deducted { get; set; }
        public decimal Balance { get; set; }
        public string CoName { get; set; }
    }
}
