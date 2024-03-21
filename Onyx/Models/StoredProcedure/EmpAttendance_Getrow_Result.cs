namespace Onyx.Models.StoredProcedure
{
    public class EmpAttendance_Getrow_Result
    {
        public int Cd { get; set; }
        public string EmpName { get; set; }
        public int Period { get; set; }
        public int W_days { get; set; }
        public int P_HDays { get; set; }
        public int Up_HDays { get; set; }
        public int NHrs { get; set; }
        public int CHrs { get; set; }
        public int W_OT { get; set; }
        public int O_OT { get; set; }
        public int H_OT { get; set; }
        public int C_OT { get; set; }
        public double Payable { get; set; }
        public double LoanDed { get; set; }
    }
}
