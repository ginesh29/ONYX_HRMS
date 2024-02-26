using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
{
    public class EmpQualificationModel
    {
        public string EmpCd { get; set; }
        public string EmployeeName { get; set; }
        public int SrNo { get; set; }
        [Display(Name = "Qualification")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string QualCd { get; set; }
        public string Qualification { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string University { get; set; }
        [Display(Name = "Country")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string CountryCd { get; set; }
        public string Country { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Passing Year")]
        public string PassingYear { get; set; }
        [Display(Name = "Marks/Grade")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string MarksGrade { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
    }
}
