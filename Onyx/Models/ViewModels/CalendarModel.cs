namespace Onyx.Models.ViewModels
{
    public class CalendarModel
    {
        public string Id { get; set; }
        public string Title { get; set; }
        public string Start { get; set; }
        public string End { get; set; }
        public string BackgroundColor { get; set; }
        public string BorderColor { get; set; }
        public bool Holyday { get; set; }
        public bool AllDay { get; set; }
    }
}
