using Onyx.Models.StoredProcedure;
using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class CompanyDocumentModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Cd { get; set; }
        public string DocTypSDes { get; set; }
        public string DivSDes { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name ="Doc. No")]
        public string DocNo { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Issue Date")]
        public DateTime? IssueDt { get; set; }
        public string FormatedIssueDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Issue Place")]
        public string IssuePlace { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Expiry Date")]
        public DateTime? ExpDt { get; set; }
        public string FormatedExpDt { get; set; }
        [Display(Name = "Ref. No")]
        public string RefNo { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Ref. Date")]
        public DateTime? RefDt { get; set; }
        public string FormatedRefDt { get; set; }
        [Display(Name = "Narration")]
        public string Narr { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Doc. Type")]
        public string DocTypCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Branch")]
        public string DivCd { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string FormatedEntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string FormatedEditDt { get; set; }
        public string Filter { get; set; }
        public string Partners { get; set; }
        public IEnumerable<IFormFile> DocFiles { get; set; }
        public IEnumerable<CompDocImages_GetRow_Result> DocsPaths { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Cd) ? "U" : "I";
            }
        }
    }
}
