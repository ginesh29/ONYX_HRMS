using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
{
    public class AirFareModel
    {
        public string Cd { get; set; }
        public string Sector { get; set; }
        public string TravelClass { get; set; }
        public int SrNo { get; set; }
        public string FormattedFromDate { get; set; }
        public string FormattedToDate { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Short Desc.")]
        public string SDes { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Date Range")]
        public string DateRange { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Description { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public decimal? Fare { get; set; }
        public string Entryby { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Travel Sector")]
        public string SectCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Travel Class")]
        public string ClassCd { get; set; }
        public string EntryBy { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Cd) ? "U" : "I";
            }
        }
    }
}
