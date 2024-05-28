using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class TokenSettingModel
    {
        [Display(Name = "Service")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string ServiceName { get; set; }
        [Display(Name = "Counter")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string CounterName { get; set; }
        [Display(Name = "Voice Over Sound")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string VoiceName { get; set; }
    }
}
