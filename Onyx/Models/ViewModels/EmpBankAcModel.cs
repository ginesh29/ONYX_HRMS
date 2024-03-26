using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpBankAcModel
    {
        [Display(Name = "Employee")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string EmpCd { get; set; }
        public string EmployeeName { get; set; }
        public decimal SrNo { get; set; }
        [Display(Name = "Account Name")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string EmployeeAcName { get; set; }
        public string Bank { get; set; }
        public string Branch { get; set; }
        public string Typ { get; set; }
        [Display(Name = "Account No")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string EmpAc { get; set; }
        public string Currency { get; set; }
        [Display(Name = "Currency")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string CurrCd { get; set; }
        public decimal? Amt { get; set; }
        public string BankGrp { get; set; }
        [Display(Name = "Bank Group")]
        public string BankGrpCd { get; set; }
        [Display(Name = "Bank")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string BankCd { get; set; }
        [Display(Name = "Branch")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string BankBrCd { get; set; }
        [Display(Name = "Route Code")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string RouteCd { get; set; }
        public string EntryBy { get; set; }
    }
}
