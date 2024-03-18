namespace Onyx.Models.StoredProcedure
{
    public class Employee_LeaveHistory_Detail
    {
        public Employee_LeaveDetail EmpLeaveDetail { get; set; }
        public IEnumerable<PreviousLeaveHistory> PreviousLeaveHistory { get; set; }
        public IEnumerable<IncomeDetails> IncomeDetails { get; set; }
        public OutstandingDetail OutstandingDetail { get; set; }
        public LeaveApprovalDetails LeaveApprovalDetails { get; set; }
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
        public string Bank { get; set; }
        public double LeaveDays { get; set; }
        public string Status { get; set; }
        public DateTime FormatedDoj { get; set; }
        public DateTime LastRejoinDt { get; set; }
        public double Leave { get; set; }
        public double LeaveTaken { get; set; }
        public double LvSalYr { get; set; }
        public double LvTicYr { get; set; }
        public double TotalDays { get; set; }
        public double LeaveOp { get; set; }
        public double LeaveSalary { get; set; }
        public double LeaveTakenDays { get; set; }
        public double LvSalDaysOp { get; set; }
        public double LvSalDays { get; set; }
        public double LvSalDaysTaken { get; set; }
        public double LvSalary { get; set; }
        public double LvSalaryOp { get; set; }
        public double LvSalaryTaken { get; set; }
        public double LvTicket { get; set; }
        public double LvTicketOp { get; set; }
        public double LvTicketTaken { get; set; }
        public DateTime FormatedWPFromDt { get; set; }
        public DateTime FormatedWPToDt { get; set; }
        public DateTime FormatedWOPFromDt { get; set; }
        public DateTime FormatedWOPToDt { get; set; }
        public double Cumlvnopay { get; set; }
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
        public string Approver { get; set; }
        public DateTime ApprovalDate { get; set; }
        public int ApprovalLevel { get; set; }
    }
}

