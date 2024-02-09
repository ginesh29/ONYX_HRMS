using Onyx.Models.StoredProcedure;
using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class UserModel
    {
        public string Cd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "User Cd")]
        public string Code { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Abbreviation")]
        public string Abbr { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Login Id")]
        public string LoginId { get; set; }
        public string UserGrp { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Password")]
        public string UPwd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Confirm Password")]
        public string CUPwd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Username")]
        public string Username { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Expiry Date")]
        public DateTime? ExpiryDt { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string UserGrpCd { get; set; }
        public string ViewAllEmp { get; set; }
        [Display(Name = "User Branch")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public List<string> UserBranchCd { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Cd) ? "U" : "I";
            }
        }
        public IEnumerable<GetMenuWithPermissions_Result> Menus { get; set; }
        public string MenuIds { get; set; }
        public IEnumerable<string> Permissions { get; set; }
        public bool Active { get; set; }
    }
}
