namespace Onyx.Models.StoredProcedure
{
    public class EmpQualificationModel
    {
        public string EmpCd { get; set; }
        public string EmployeeName { get; set; }
        public int SrNo { get; set; }
        public string QualCd { get; set; }
        public string Qualification { get; set; }
        public string University { get; set; }
        public string CountryCd { get; set; }
        public string Country { get; set; }
        public string PassingYear { get; set; }
        public string MarksGrade { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
    }
}
