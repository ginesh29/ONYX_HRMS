namespace Onyx.Models.StoredProcedure
{
    public class EmpTransfers_GetRow_Result
    {
        public string EmpCd { get; set; }
        public string Fname { get; set; }
        public decimal SrNo { get; set; }
        public DateTime? TransferDt { get; set; }
        public string FormatedTransferDt { get; set; }
        public string DeptFrDes { get; set; }
        public string DeptToDes { get; set; }
        public string DeptFrom { get; set; }
        public string DeptTo { get; set; }
        public string LocFrDes { get; set; }
        public string LocToDes { get; set; }
        public string LocFrom { get; set; }
        public string LocTo { get; set; }
        public string BrFrDes { get; set; }
        public string BrToDes { get; set; }
        public string BrFrom { get; set; }
        public string BrTo { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string CompFrDes { get; set; }
        public string CompToDes { get; set; }
        public string CompTo { get; set; }
        public string Narration { get; set; }
    }
}
