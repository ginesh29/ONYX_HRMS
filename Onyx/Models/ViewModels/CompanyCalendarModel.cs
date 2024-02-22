using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class CompanyCalendarModel
    {
        public string Code { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Cd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? Date { get; set; }
        public bool Holiday { get; set; }
        [Display(Name = "Email Message Body")]
        public string MessageBody { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Title { get; set; }
        public string CoCd { get; set; }
        public string CoId { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public List<string> Attendees { get; set; }
        public string EmailIds { get; set; }
        
        [Display(Name = "Email Subject")]
        public string EmailSubject { get; set; }
        public string EntryBy { get; set; }

        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Code) ? "U" : "I";
            }
        }
    }
}
