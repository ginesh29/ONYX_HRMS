namespace Onyx.Models.StoredProcedure.Report
{
    public class Employee_LeaveHistory_GetRow_Result
    {
        public string Code { get; set; }
        public string Name { get; set; }
        public double? LvSalYr { get; set; }
        public double? LvTicYr { get; set; }
        public int LeaveOp { get; set; }
        public double Leave { get; set; }
        public double LeaveTaken { get; set; }
        public double LvSalDaysOp { get; set; }
        public double LvSalDays { get; set; }
        public double LvSalDaysTaken { get; set; }
        public double LvSalary { get; set; }
        public double LvSalaryOp { get; set; }
        public double LvSalaryTaken { get; set; }
        public double LvTicket { get; set; }
        public double LvTicketOp { get; set; }
        public double LvTicketTaken { get; set; }
        public double Cumlvnopay { get; set; }
        public double GratDaysOp { get; set; }
        public double GratDays { get; set; }
        public double GratDaysTaken { get; set; }
        public double GratAmtOp { get; set; }
        public double GratAmt { get; set; }
        public double GratAmtTaken { get; set; }
        public double TmfAmount { get; set; }
    }
}
