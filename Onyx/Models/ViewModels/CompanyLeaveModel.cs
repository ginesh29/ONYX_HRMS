using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class CompanyLeaveModel
    {
        public string Code { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Cd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Short Desc.")]
        public string SDes { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Description { get; set; }
        [Display(Name = "Approval Level")]
        public decimal? ApprLvl { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string CoCd { get; set; }
        public string LvCd { get; set; }
        [Display(Name = "Max. Leave")]
        public int LvMax { get; set; }
        public bool Accrued { get; set; }
        public bool EnCash { get; set; }
        [Display(Name = "Min. Encash Days")]
        public int EnCashMinLmt { get; set; }
        [Display(Name = "Pay Factor")]
        public decimal? PayFact { get; set; }
        [Display(Name = "Max. Accrual")]
        public int AccrLmt { get; set; }
        public bool ServicePrd { get; set; }
        public bool Active { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Code) ? "U" : "I";
            }
        }
    }
}
