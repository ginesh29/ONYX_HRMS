namespace Onyx.Models.ViewModels
{
    public class Select2Model
    {
        public IEnumerable<Select2Item> Items { get; set; }
        public int TotalCount { get; set; }
    }
    public class Select2Item
    {
        public string Id { get; set; }
        public string Text { get; set; }
    }
}
