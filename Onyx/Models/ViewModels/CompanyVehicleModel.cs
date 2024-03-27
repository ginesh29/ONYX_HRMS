using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class CompanyVehicleModel
    {
        public string Code { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Cd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Description { get; set; }
        [Display(Name = "Short Desc.")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string SDes { get; set; }
        public string Branch { get; set; }
        public string Location { get; set; }
        public string Brand { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Puchase Date")]
        public DateTime? PurDt { get; set; }
        public string FormatedPurDt { get; set; }
        [Display(Name = "Original Price")]
        public decimal? OrgPrice { get; set; }
        public string Owner { get; set; }
        public string Driver { get; set; }
        [Display(Name = "Engine No")]
        public string EngineNo { get; set; }
        [Display(Name = "Chassis No")]
        public string ChassisNo { get; set; }
        [Display(Name = "Plate Color")]
        public string PlateColor { get; set; }
        [Display(Name = "Reg. No")]
        public string RegnNo { get; set; }
        [Display(Name = "Reg. Date")]
        public DateTime? RegnFrmDt { get; set; }
        public string FormatedRegnFrmDt { get; set; }
        [Display(Name = "Reg. Expiry Date")]
        public DateTime? RegnExpDt { get; set; }
        public string FormatedRegnExpDt { get; set; }
        [Display(Name = "Emirate")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string State { get; set; }
        [Display(Name = "Petrol Card No")]
        public string PetrolCard { get; set; }
        [Display(Name = "Petrol Card Amount")]
        public decimal? PetrolCardAmt { get; set; }
        [Display(Name = "Insurance Co.")]
        public string InsCo { get; set; }
        [Display(Name = "Insurance Policy No")]
        public string InsPolicyNo { get; set; }
        [Display(Name = "Insurance Amount")]
        public decimal? InsAmt { get; set; }
        [Display(Name = "Insurance Premium")]
        public decimal? InsPrem { get; set; }
        [Display(Name = "Insurance From Date")]
        public DateTime? InsFrmDt { get; set; }
        public string FormatedInsFrmDt { get; set; }
        [Display(Name = "Insurance Expiry Date")]
        public DateTime? InsExpDt { get; set; }
        public string FormatedInsExpDt { get; set; }
        [Display(Name = "Narration")]
        public string Narr { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDate { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDate { get; set; }
        [Display(Name = "Branch")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string BranchCd { get; set; }
        [Display(Name = "Location")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string LocationCd { get; set; }
        [Display(Name = "Model Year")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string ModelCd { get; set; }
        [Display(Name = "Owner")]
        public string OwnerCd { get; set; }
        [Display(Name = "Driver")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string DriverCd { get; set; }
        [Display(Name = "Plate Color")]
        public string PlateColorCd { get; set; }
        [Display(Name = "Emirate")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string StateCd { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Code) ? "U" : "I";
            }
        }
    }
}
