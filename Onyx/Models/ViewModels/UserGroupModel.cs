using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class UserGroupModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Branch Cd")]
        public string Cd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Description")]
        public string Des { get; set; }
        public int? BackDays { get; set; }
        public string ViewAllEmp { get; set; }
        public bool IsViewAllEmp { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Cd) ? "U" : "I";
            }
        }
    }
}
