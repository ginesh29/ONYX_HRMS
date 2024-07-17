using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class LanguageResourceModel
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string English { get; set; }
        public string Arabic { get; set; }
        public string Persian { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(English) ? "U" : "I";
            }
        }
    }
}
