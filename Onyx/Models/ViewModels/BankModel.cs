using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class BankModel
    {
        public string Cd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Bank")]
        public string BankCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Branch")]
        public string BranchCd { get; set; }
        public string Bank { get; set; }
        public string Branch { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Swift Code")]
        public string Swift { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Address 1")]
        public string Address1 { get; set; }
        [Display(Name = "Address 2")]
        public string Address2 { get; set; }
        [Display(Name = "Address 2")]
        public string Address3 { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Contact { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Phone { get; set; }
        public string Fax { get; set; }
        [EmailAddress(ErrorMessage = ValidationMessage.ENTERVALID)]
        public string Email { get; set; }
        [Url(ErrorMessage = ValidationMessage.ENTERVALID)]
        [Display(Name = "Site Url")]
        public string URL { get; set; }
        public string Filter { get; set; }
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
