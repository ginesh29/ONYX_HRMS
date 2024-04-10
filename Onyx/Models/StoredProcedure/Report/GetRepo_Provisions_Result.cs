namespace Onyx.Models.StoredProcedure.Report
{
    public class GetRepo_Provisions_Result
    {
        public string Cd { get; set; }
        public string Name { get; set; }
        public DateTime DOJ { get; set; }
        public string Designation { get; set; }
        public int? DaysWorked { get; set; }
        public double? PrRate { get; set; }
        public string Department { get; set; }
        public string CC { get; set; }
        public string Loc { get; set; }
        public string CoName { get; set; }
        public string Branch { get; set; }
        public double OpDays { get; set; }
        public double OpAmt { get; set; }
        public double GTMAmt { get; set; }
        public double GTMPay { get; set; }
        public double GTMAdj { get; set; }
        public double GTCAmt { get; set; }
        public double GTCPay { get; set; }
        public double GTCAdj { get; set; }
        public double GTMDays { get; set; }
        public double GTMDaysPay { get; set; }
        public double GTMDaysAdj { get; set; }
        public double GTCDays { get; set; }
        public double GTCDaysPay { get; set; }
        public double GTCDaysAdj { get; set; }
        public double AmtDecs { get; set; }
        public int Prd { get; set; }
        public int Year { get; set; }
        public string ProvisionType { get; set; }
    }
}
