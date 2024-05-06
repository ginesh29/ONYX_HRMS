namespace Onyx.Models.StoredProcedure.Report
{
    public class GetRepo_EmpPayDetail_Result
    {
        public char Cd { get; set; }
        public string EmpName { get; set; }
        public char? CurrCd { get; set; }
        public string Typ { get; set; }
        public char? Abbr { get; set; }
        public string Sdes { get; set; }
        public string TrnTyp { get; set; }
        public decimal? Amt { get; set; }
        public decimal? ActualAmt { get; set; }
        public char? Curr { get; set; }
        public string PayType { get; set; }
        public string Branch { get; set; }
        public string Location { get; set; }
        public string CC { get; set; }
        public string Department { get; set; }
        public string Company { get; set; }
        public int? Prd { get; set; }
        public string Yr { get; set; }
        public decimal? OTHrs { get; set; }
        public decimal? Wdays { get; set; }
        public string Sponsor { get; set; }
        public string PersonalNo { get; set; }
        public string BankName { get; set; }
        public string AccountNo { get; set; }
        public char WorkNo { get; set; }
        public string Type { get; set; }
        public decimal? Hdays { get; set; }
    }
}
