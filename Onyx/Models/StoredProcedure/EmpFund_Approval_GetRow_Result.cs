using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace Onyx.Models.StoredProcedure
{
    public class EmpFund_Approval_GetRow_Result
    {
        public string TransNo { get; set; }
        public DateTime? TransDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmpCd { get; set; }
        public string Emp { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public int? Amount { get; set; }
        public decimal? Current_Approval_Level { get; set; }
        public string Current_Approval { get; set; }
        public string Approvals { get; set; }
        public string Typ { get; set; }
        [Display(Name = "Approved Date")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? ApprDate { get; set; }
        public string ApprBy { get; set; }
        public string EntryBy { get; set; }
        public string Status { get; set; }
        public string ImagePath { get; set; }
    }
}
