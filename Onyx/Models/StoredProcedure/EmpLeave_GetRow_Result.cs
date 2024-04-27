namespace Onyx.Models.StoredProcedure
{
    public class EmpLeave_GetRow_Result
    {
        public string TransNo { get; set; }
        public DateTime? TransDt { get; set; }
        public string EmployeeCode { get; set; }
        public string EmployeeName { get; set; }
        public string LeaveType { get; set; }
        public DateTime? FromDt { get; set; }
        public string FormatedFromDt { get; set; }
        public DateTime ToDt { get; set; }
        public string FormatedToDt { get; set; }
        public decimal? LvTaken { get; set; }
        public string DocRef { get; set; }
        public DateTime? docDt { get; set; }
        public string SubtituteCode { get; set; }
        public string SubstituteName { get; set; }
        public string Reason { get; set; }
        public string Narr { get; set; }
        public string LvApprBy { get; set; }
        public string LvStatus { get; set; }
        public string Typ { get; set; }
        public int? Joiningdays { get; set; }
        public int? Returningdays { get; set; }
        public int NoOfDays { get; set; }
    }
}
