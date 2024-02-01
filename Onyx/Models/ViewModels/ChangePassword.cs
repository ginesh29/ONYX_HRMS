using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class ChangePassword
    {
        public string Username { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Old Password")]
        public string OldPassword { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "New Password")]
        public string NewPassword { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Compare("NewPassword", ErrorMessage = CommonMessage.CONFIRMPASSWORDNOTMATCHED)]
        [Display(Name = "Confirm Password")]
        public string ConfirmPassword { get; set; }
    }
}
