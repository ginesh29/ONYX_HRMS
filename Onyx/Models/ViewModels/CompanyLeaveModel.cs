using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
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
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Approval Level")]
        public decimal? ApprLvl { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string CoCd { get; set; }
        public string LvCd { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Max. Leave")]
        public int LvMax { get; set; }
        public bool Accrued { get; set; }
        public bool EnCash { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Min. Encash Days")]
        public int EnCashMinLmt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Pay Factor")]
        public decimal PayFact { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Max. Accrual")]
        public int AccrLmt { get; set; }
        public bool ServicePrd { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Code) ? "U" : "I";
            }
        }
    }
}
