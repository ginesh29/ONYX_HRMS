using System.ComponentModel.DataAnnotations;

namespace Onyx.Models
{
    public class LoginModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Username { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Password { get; set; }
        public string UserId
        {
            get
            {
                var sp = Username.Split('@', '$');
                if (sp.Length > 0)
                    return sp[0];
                return string.Empty;
            }
        }
        public string CoAbbr
        {
            get
            {
                var sp = Username.Split('@', '$');
                if (sp.Length > 1)
                    return sp[1];
                return string.Empty;
            }
        }
        public bool RememberMe { get; set; }
    }
}
