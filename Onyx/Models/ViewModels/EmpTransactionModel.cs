namespace Onyx.Models.ViewModels
{
    public class EmpTransactionModel
    {
        public dynamic Header { get; set; }
        public List<dynamic> ReportData { get; set; }
        public Dictionary<string, decimal> Totals { get; set; }
    }
}
