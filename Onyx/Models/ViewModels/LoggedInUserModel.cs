namespace Onyx.Models.ViewModels
{
    public class LoggedInUserModel
    {
        public string UserCd { get; set; }
        public string LoginId { get; set; }
        public string Username { get; set; }
        public int UserType { get; set; }
        public string CompanyCd { get; set; }
        public string CompanyAbbr { get; set; }
        public string EmployeeCd { get; set;}
        public string Browser { get; set; }
    }
}
