using Onyx.Models.StoredProcedure;
using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class CompanyProcessApprovalModel
    {
        public string CoCd { get; set; }
        public string CoCdCd { get; set; }
        public string ProcessId { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Type")]
        public string ProcessIdCd { get; set; }
        public string ApplTyp { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Doc. Type")]
        public string ApplTypCd { get; set; }
        public string Branch { get; set; }
        [Display(Name = "Branch")]
        public string BranchCd { get; set; } = "0";
        public string Dept { get; set; } = "0";
        [Display(Name = "Department")]
        public string DeptCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        [Display(Name = "Approval Levels")]
        public List<CompanyProcessApproval_Detail_GetRow_Result> ApprovalLevels { get; set; }
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
