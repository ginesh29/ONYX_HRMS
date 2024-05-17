using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class CompanyModel
    {
        [Display(Name = "Company Code")]
        public string CoCd { get; set; }
        [Display(Name = "Company Name")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string CoName { get; set; }
        [Display(Name = "Address 1")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Add1 { get; set; }
        [Display(Name = "Address 2")]
        public string Add2 { get; set; }
        [Display(Name = "Address 3")]
        public string Add3 { get; set; }
        public string Phone { get; set; }
        public string Fax { get; set; }
        public string Email { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Logo { get; set; }
        [Display(Name = "Logo")]
        public IFormFile LogoFile { get; set; }
        [Range(0, 4, ErrorMessage = "{0} must be between 0 and 4")]
        public int AmtDecs { get; set; }
        public int QtyDecs { get; set; }
        public string BaseCurr { get; set; }
        public string RptCurr { get; set; }
        public DateTime? FinBeginDt { get; set; }
        public string FormatedFinBeginDt { get; set; }
        public DateTime? FinEndDt { get; set; }
        public string FormatedFinEndDt { get; set; }
        public int? Prd { get; set; }
        public int? Year { get; set; }
        public string DayDate { get; set; }
        public string LoginBg { get; set; }
        [Display(Name = "Login Background")]
        public IFormFile LoginBgFile { get; set; }
    }
}
