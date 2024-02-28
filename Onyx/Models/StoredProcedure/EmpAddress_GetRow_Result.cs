namespace Onyx.Models.StoredProcedure
{
    public class EmpAddress_GetRow_Result
    {
        public string EmployeeCode { get; set; }
        public string EmployeeName { get; set; }
        public string Address_Type { get; set; }
        public string AddTyp { get; set; }
        public string Contact { get; set; }
        public string AddressLine1 { get; set; }
        public string AddressLine2 { get; set; }
        public string AddressLine3 { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string CountryCd { get; set; }
        public string Phone { get; set; }
        public string Mobile { get; set; }
        public string Fax { get; set; }
        public string Email { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDate { get; set; }
        public string EditedBy { get; set; }
        public DateTime? EditDate { get; set; }
    }
}
