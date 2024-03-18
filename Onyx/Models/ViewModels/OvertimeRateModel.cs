using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class OvertimeRateModel
    {
        public string Type { get; set; }
        public int SrNo { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Duty Hrs Upto")]
        public decimal? HrsApply { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public decimal? Rate { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Short Desc.")]
        public string Sdes { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Description")]
        public string Narr { get; set; }
        [Display(Name = "Day Type")]
        public string HolTyp { get; set; }
        public string PayCd { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Type")]
        public string TypCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Day Type")]
        public string HolTypCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Pay Code")]
        public string PayCode { get; set; }
        public string Cd { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Cd) ? "U" : "I";
            }
        }
    }
}
