using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpCalendarModel
    {
        public int? SrNo { get; set; }
        [Display(Name = "Employee")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string EmpCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? Date { get; set; }
        public bool Holiday { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Title { get; set; }
        [Display(Name = "Narration")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Narr { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
    }
}
