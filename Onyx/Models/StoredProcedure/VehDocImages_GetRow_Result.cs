namespace Onyx.Models.StoredProcedure
{
    public class VehDocImages_GetRow_Result
    {
        public string Code { get; set; }
        public string VehicleName { get; set; }
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
