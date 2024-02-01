using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class LoginModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Username { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Password { get; set; }
        public string CoAbbr { get; set; }
        public UserTypeEnum UserType { get; set; }
        public bool RememberMe { get; set; }
    }
}
