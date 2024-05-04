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
        public string Company { get; set; }
        public UserTypeEnum UserType { get; set; }
        public string Browser { get; set; }
        public string CoAbbr { get; set; }
    }
}
