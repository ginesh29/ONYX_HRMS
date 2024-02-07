using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
{
    public class WorkingHourModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Code { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Description { get; set; }
        public DateTime FromDt { get; set; }
        public DateTime ToDt { get; set; }
        public string FormattedFromDate { get; set; }
        public string FormattedToDate { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Duty Hours")]
        public decimal? DutyHrs { get; set; }        
        public string Religion { get; set; }
        public string HolTypDesc { get; set; }
        [Display(Name = "Religion")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string RelgTypCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Day Type")]
        public string HolTypCd { get; set; }
        public string EntryBy { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Code) ? "U" : "I";
            }
        }
    }
}
