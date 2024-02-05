using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class BranchModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Cd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Des { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string SDes { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string BU_Cd { get; set; }
        public string BU_SDes { get; set; }
        public string CoCd { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Cd) ? "U" : "I";
            }
        }
    }
}
