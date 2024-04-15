using Onyx.Models.StoredProcedure;
using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class VehDocumentModel
    {
        public string Cd { get; set; }
        public int SrNo { get; set; }
        public string VehCd { get; set; }
        public string VehName { get; set; }
        public string DocTypSDes { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Document No")]
        public string DocNo { get; set; }
        public string OthRefNo { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Issue Date")]
        public DateTime? IssueDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Expiry Date")]
        public DateTime? ExpDt { get; set; }
        public string FormatedIssueDt { get; set; }
        public string FormatedExpDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Place Of Issue")]
        public string IssuePlace { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string FormatedEntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string FormatedEditDt { get; set; }
        public string Filter { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Document Type")]
        public string DocTypCd { get; set; }
        public DateTime? TrnDt { get; set; }
        [Display(Name = "Status")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string DocStatus { get; set; }
        public string Narr { get; set; }
        public IEnumerable<IFormFile> VehicleDocFiles { get; set; }
        public IEnumerable<VehDocImages_GetRow_Result> VehicleDocsPaths { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Cd) ? "U" : "I";
            }
        }
    }
}
