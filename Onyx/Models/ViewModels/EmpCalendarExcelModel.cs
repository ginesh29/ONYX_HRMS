using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.ViewModels
{
    public class EmpCalendarExcelModel
    {
        public int? SrNo { get; set; }
        public string EmpCd { get; set; }
        public DateTime Date { get; set; }
        public bool Holiday { get; set; }
        public string Title { get; set; }
        public string Narr { get; set; }
        public bool IsValid { get; set; }
        public string ErrorMessage { get; set; }
    }
}
