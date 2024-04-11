namespace Onyx.Models.StoredProcedure.Report
{
    public class Getrepo_Emptransfers_Result
    {
        public string empcd { get; set; }
        public string Name { get; set; }
        public DateTime TransferDt { get; set; }
        public string BrFrom { get; set; }
        public string BrFrom_cd { get; set; }
        public string BrTo { get; set; }
        public string BrTo_cd { get; set; }
        public string DeptFrom { get; set; }
        public string DeptTo { get; set; }
        public string LocFrom { get; set; }
        public string LocTo { get; set; }
        public string Coname { get; set; }
    }
}
