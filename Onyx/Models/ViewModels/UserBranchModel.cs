namespace Onyx.Models.StoredProcedure
{
    public class UserBranchModel
    {
        public string Cd { get; set; }
        public string Des { get; set; }
        public string SDes { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string BU_Cd { get; set; }
        public string BU_SDes { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Cd) ? "U" : "I";
            }
        }
    }
}
