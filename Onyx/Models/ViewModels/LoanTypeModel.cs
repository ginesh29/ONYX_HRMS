using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class LoanTypeModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Code { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Description { get; set; }
        public string PayTyp { get; set; }
        public string PayComp { get; set; }
        public string DedTyp { get; set; }
        public string DedComp { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Abbriviation { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Short Desc.")]
        public string SDes { get; set; }
        public string ChgsTyp { get; set; }
        [Display(Name = "Charges Type")]
        public string ChgsTypCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Interest %")]
        public decimal? IntPerc { get; set; }
        [Display(Name = "Pay Component")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string PayCd { get; set; }
        [Display(Name = "Ded. Component")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string DedCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string DedTypCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string PayTypCd { get; set; }
        public string EntryBy { get; set; }
        public string Cd { get; set; }
        public bool Active { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Cd) ? "U" : "I";
            }
        }
    }
}
