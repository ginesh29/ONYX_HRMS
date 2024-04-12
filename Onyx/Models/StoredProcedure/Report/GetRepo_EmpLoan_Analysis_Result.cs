namespace Onyx.Models.StoredProcedure.Report
{
    public class GetRepo_EmpLoan_Analysis_Result
    {
        public string TransNo { get; set; }
        public DateTime TransDt { get; set; }
        public string LoanTyp { get; set; }
        public string Caption { get; set; }
        public string Remarks { get; set; }
        public string LoanType { get; set; }
        public string LastApprName { get; set; }
        public DateTime LoanApprDt { get; set; }
        public string EmpCd { get; set; }
        public string Employee { get; set; }
        public decimal Amt { get; set; }
        public decimal ApprAmt { get; set; }
        public int NoInst { get; set; }
        public DateTime DedStartDt { get; set; }
        public DateTime FormatedDedStartDt { get; set; }
        public string RecoMode { get; set; }
        public string RecoModeDes { get; set; }
        public string PayMode { get; set; }
        public string PayModeDes { get; set; }
        public int RecoPrd { get; set; }
        public string Guarantor { get; set; }
        public string GuarantorDetails { get; set; }
        public string Branch { get; set; }
        public string Location { get; set; }
        public string CC { get; set; }
        public string Dept { get; set; }
        public string DocRef { get; set; }
        public string DocDt { get; set; }
        public string LoanStatus { get; set; }
        public string Narr { get; set; }
        public string CoName { get; set; }
        public int Count { get; set; }
        public decimal Balance { get; set; }
    }
}
