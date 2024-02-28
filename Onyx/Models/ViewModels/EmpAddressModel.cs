using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
{
    public class EmpAddressModel
    {
        public string EmployeeCode { get; set; }
        public string EmployeeName { get; set; }
        public string Address_Type { get; set; }
        [Display(Name ="Address Type")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string AddTyp { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Contact { get; set; }
        [Display(Name = "Address Line 1")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string AddressLine1 { get; set; }
        [Display(Name = "Address Line 2")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string AddressLine2 { get; set; }
        [Display(Name = "Address Line 3")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string AddressLine3 { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string City { get; set; }
        public string Country { get; set; }
        [Display(Name = "Country")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string CountryCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Phone { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Mobile { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Fax { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Email { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDate { get; set; }
        public string EditedBy { get; set; }
        public DateTime? EditDate { get; set; }
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
