using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class TokenModel
    {
        public string TokenNo { get; set; }
        [Display(Name = "Service")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string ServiceCd { get; set; }
        [Display(Name = "Mobile No.")]
        public string MobileNo { get; set; }
        public string Status { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
    }
}
