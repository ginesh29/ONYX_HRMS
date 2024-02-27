using Onyx.Models.StoredProcedure;
using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpDocumentModel
    {
        [Display(Name = "Employee")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string EmpCd { get; set; }
        public string EmpName { get; set; }
        public string DocTypSDes { get; set; }
        [Display(Name = "Doc. No")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string DocNo { get; set; }
        public string OthRefNo { get; set; }
        [Display(Name = "Issue Date")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? IssueDt { get; set; }
        [Display(Name = "Expiry Date")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? ExpDt { get; set; }
        public string FormatedIssueDt { get; set; }
        public string FormatedExpDt { get; set; }
        [Display(Name = "Issue Place")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string IssuePlace { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string FormatedEntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string FormatedEditDt { get; set; }
        public string Filter { get; set; }
        [Display(Name = "Doc. Type")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string DocTypCd { get; set; }
        public decimal SrNo { get; set; }
        public IEnumerable<IFormFile> DocFiles { get; set; }
        public IEnumerable<EmpDocImages_GetRow_Result> DocsPaths { get; set; }
    }
}
