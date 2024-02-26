using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
{
    public class EmpExperienceModel
    {
        public string EmpCd { get; set; }
        public string EmployeeName { get; set; }
        public decimal Srno { get; set; }
        [Display(Name ="Company Name")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string CompanyName { get; set; }
        [Display(Name = "Company Reference")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string CompanyReference { get; set; }
        public string Designation { get; set; }
        [Display(Name = "Designation")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string Desg { get; set; }
        public string StartingDate { get; set; }
        public string EndingDate { get; set; }
        [Display(Name = "Date Range")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string DateRange { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Country")]
        public string CountryCd { get; set; }
        public string Country { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Narration { get; set; }
        public string EntryBy { get; set; }
    }
}
