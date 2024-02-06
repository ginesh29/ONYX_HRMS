using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
{
    public class CodeModel
    {
        public string CodeGrpSDes { get; set; }
        public decimal? AddOn_Fields { get; set; }
        public string Type { get; set; }
        public string TypeName { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Abbriviation { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Short Desc.")]
        public string ShortDes { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Description { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string Editby { get; set; }
        public DateTime? EditDt { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Code { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Code) ? "U" : "I";
            }
        }
    }
}
