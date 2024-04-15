namespace Onyx.Models.StoredProcedure.Report
{
    public class GetRepo_EmpLeave_Result
    {
        public string TransNo { get; set; }
        public DateTime TransDt { get; set; }
        public string LvTyp { get; set; }
        public string Caption { get; set; }
        public string Remarks { get; set; }
        public string LeaveType { get; set; }
        public string LastApprName { get; set; }
        public DateTime FormatedLvApprDt { get; set; }
        public DateTime FormatedJoinDt { get; set; }
        public string EmpCd { get; set; }
        public string Employee { get; set; }
        public string Branch { get; set; }
        public string Location { get; set; }
        public string CC { get; set; }
        public string Dept { get; set; }
        public string CancelBy { get; set; }
        public string CancelByName { get; set; }
        public DateTime CancelDt { get; set; }
        public string CancelRemarks { get; set; }
        public string ConfirmBy { get; set; }
        public string ConfirmByName { get; set; }
        public DateTime ConfirmDt { get; set; }
        public string ConfirmRemarks { get; set; }
        public string ReviseBy { get; set; }
        public string ReviseByName { get; set; }
        public DateTime ReviseDt { get; set; }
        public string ReviseRemarks { get; set; }
        public DateTime FromDt { get; set; }
        public DateTime ToDt { get; set; }
        public string DocRef { get; set; }
        public DateTime DocDt { get; set; }
        public string LvStatus { get; set; }
        public string LvInter { get; set; }
        public DateTime FormatedWP_FromDt { get; set; }
        public DateTime FormatedWP_ToDt { get; set; }
        public DateTime FormatedWOP_FromDt { get; set; }
        public DateTime FormatedWOP_ToDt { get; set; }
        public string Reason { get; set; }
        public string Narr { get; set; }
        public string CoName { get; set; }
        public int Count { get; set; }
        public DateTime JoinDt { get; set; }
        public string SysTransNo { get; set; }
        public decimal Lvsalary { get; set; }
        public decimal Lvfare { get; set; }
        public string GT { get; set; }
        public string LS { get; set; }
        public string LT { get; set; }
        public int Days { get; set; }
        public DateTime LvFromDt { get; set; }
        public DateTime LvToDt { get; set; }
    }
}
