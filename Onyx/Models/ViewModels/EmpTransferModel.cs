using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
{
    public class EmpTransferModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Employee")]
        public string EmpCd { get; set; }
        public string Fname { get; set; }
        public decimal SrNo { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Transfer Date")]
        public DateTime? TransferDt { get; set; }
        public string FormatedTransferDt { get; set; }
        public string DeptFrDes { get; set; }
        public string DeptToDes { get; set; }
        [Display(Name = "Department From")]
        public string DeptFrom { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Department To")]
        public string DeptTo { get; set; }
        public string LocFrDes { get; set; }
        public string LocToDes { get; set; }
        [Display(Name = "Location From")]
        public string LocFrom { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Location To")]
        public string LocTo { get; set; }
        public string BrFrDes { get; set; }
        public string BrToDes { get; set; }
        [Display(Name = "Branch From")]
        public string BrFrom { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Branch To")]
        public string BrTo { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string CompFrDes { get; set; }
        public string CompToDes { get; set; }
        public string CompTo { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string Narration { get; set; }
        public string Cd { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Cd) ? "U" : "I";
            }
        }
    }
}
