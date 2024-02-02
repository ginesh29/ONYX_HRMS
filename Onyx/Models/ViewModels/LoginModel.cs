using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class LoginModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string LoginId { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Password { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Company")]
        public string CoCd { get; set; }
        public UserTypeEnum UserType { get; set; }
        public bool RememberMe { get; set; }
        public string Browser { get; set; }
    }
}
