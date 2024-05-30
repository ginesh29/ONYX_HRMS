namespace Onyx.Models.ViewModels
{
    public class CounterModel
    {
        public string Cd { get; set; }
        public string Name { get; set; }
        public string ImageFile { get; set; }
        public bool Active { get; set; }
        public IEnumerable<IFormFile> DocFiles { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
    }
}
