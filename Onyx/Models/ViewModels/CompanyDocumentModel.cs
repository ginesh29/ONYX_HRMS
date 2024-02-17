using Onyx.Models.StoredProcedure;

namespace Onyx.Models.ViewModels
{
    public class CompanyDocumentModel
    {
        public string Cd { get; set; }
        public string DocTypSDes { get; set; }
        public string DivSDes { get; set; }
        public string DocNo { get; set; }
        public DateTime? IssueDt { get; set; }
        public string FormatedIssueDt { get; set; }
        public string IssuePlace { get; set; }
        public DateTime? ExpDt { get; set; }
        public string FormatedExpDt { get; set; }
        public string RefNo { get; set; }
        public DateTime? RefDt { get; set; }
        public string FormatedRefDt { get; set; }
        public string Narr { get; set; }
        public string DocTypCd { get; set; }
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
