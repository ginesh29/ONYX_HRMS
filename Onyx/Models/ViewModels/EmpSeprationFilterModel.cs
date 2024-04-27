using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpSeprationFilterModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string EmpCd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? SeprationDate { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string SeprationType { get; set; }
    }
}
