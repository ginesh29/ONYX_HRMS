namespace Onyx.Models.StoredProcedure
{
    public class CompDocImages_GetRow_Result
    {
        public string CompanyCode { get; set; }
        public string CompanyName { get; set; }
        public string DivCd { get; set; }
        public string Div { get; set; }
        public string DocumentTypeCd { get; set; }
        public string DocumentType { get; set; }
        public string ImageFile { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDate { get; set; }
        public string EditedBy { get; set; }
        public DateTime? EditDate { get; set; }
        public int SlNo { get; set; }
    }
}
