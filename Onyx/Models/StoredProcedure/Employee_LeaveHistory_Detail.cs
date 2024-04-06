namespace Onyx.Models.StoredProcedure
{
    public class Employee_LeaveHistory_Detail
    {
        public Employee_LeaveDetail EmpLeaveDetail { get; set; }
        public IEnumerable<PreviousLeaveHistory> PreviousLeaveHistory { get; set; }
        public IEnumerable<IncomeDetails> IncomeDetails { get; set; }
        public OutstandingDetail OutstandingDetail { get; set; }
        public IEnumerable<LeaveApprovalDetails> LeaveApprovalDetails { get; set; }
    }

    public class Employee_LeaveDetail
    {
        public string Name { get; set; }
        public int Code { get; set; }
        public string Company { get; set; }
        public string Branch { get; set; }
        public string Department { get; set; }
        public string Location { get; set; }
        public string Designation { get; set; }
        public string Nationality { get; set; }
        public string Bank { get; set; }
        public double LeaveDays { get; set; }
        public string Status { get; set; }
        public string Sponsor { get; set; }
        public DateTime FormatedDoj { get; set; }
        public DateTime LastRejoinDt { get; set; }
        public int ReqLv { get; set; }
        public int LvSalYr { get; set; }
        public int LvTicYr { get; set; }
        public int TotalDays { get; set; }
        public int LeaveOp { get; set; }
        public decimal Leave { get; set; }
        public int LeaveTaken { get; set; }
        public int LvSalDaysOp { get; set; }
        public decimal LvSalDays { get; set; }
        public int LvSalDaysTaken { get; set; }
        public decimal LvSalary { get; set; }
        public int LvSalaryOp { get; set; }
        public int LvSalaryTaken { get; set; }
        public decimal LvTicket { get; set; }
        public int LvTicketOp { get; set; }
        public int LvTicketTaken { get; set; }
        public DateTime FormatedWPFromDt { get; set; }
        public DateTime FormatedWPToDt { get; set; }
        public DateTime FormatedWOPFromDt { get; set; }
        public DateTime FormatedWOPToDt { get; set; }
        public int Cumlvnopay { get; set; }
    }
    public class PreviousLeaveHistory
    {
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public int WithPay { get; set; }
        public int WithoutPay { get; set; }
        public int Total { get; set; }
    }
    public class IncomeDetails
    {
        public string Type { get; set; }
        public string Des { get; set; }
        public double AmtVal { get; set; }
    }
    public class OutstandingDetail
    {
        public int Outstanding { get; set; }
    }
    public class LeaveApprovalDetails
    {
        public string LvApprBy { get; set; }
        public DateTime ApprDt { get; set; }
        public int ApprovalLevel { get; set; }
    }
}

