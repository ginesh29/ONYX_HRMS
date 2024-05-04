namespace Onyx.Models.ViewModels
{
    public class LoggedInUserModel
    {
        public string UserOrEmployee { get; set; }
        public string UserCd { get; set; }
        public string CoAbbr { get; set; }
        public string Username { get; set; }
        public string UserAbbr { get; set; }
        public int UserType { get; set; }
        public string CompanyCd { get; set; }
        public string Browser { get; set; }
        public string ActivityId { get; set; }
    }
}
