using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class NotificationModel
    {
        public string CoCd { get; set; }
        [Display(Name = "Type")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string ProcessId { get; set; }
        [Display(Name = "Doc. Type")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string DocTyp { get; set; }
        public string DocTypDes { get; set; }
        public int SrNo { get; set; }
        public string Type { get; set; }
        [Display(Name = "No Of Days")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public int NoOfDays { get; set; }
        public string BeforeOrAfter { get; set; }
        [Display(Name = "Message Body")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string MessageBody { get; set; }
        public string EmailIds { get; set; }
    }
}
