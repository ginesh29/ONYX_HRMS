using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
{
    public class Employee_GetRow_Result
    {
        public string Cd { get; set; }
        public string Salute { get; set; }
        public string Salutation { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string LastName { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Sex { get; set; }
        public string Company { get; set; }
        public string Branch { get; set; }
        public string BranchCd { get; set; }
        public string CC { get; set; }
        public string Department { get; set; }
        public string DepartmentCd { get; set; }
        public string Location { get; set; }
        public string LocationCd { get; set; }
        public string POB { get; set; }
        public string Nat { get; set; }
        public string Nationality { get; set; }
        public string Relg { get; set; }
        public string Religion { get; set; }
        public string Marital { get; set; }
        public string MaritalStatus { get; set; }
        public string Designation { get; set; }
        public string Desg { get; set; }
        public DateTime? DOB { get; set; }
        public string FormatedDOB { get; set; }
        public DateTime? DOJ { get; set; }
        public string FormatedDOJ { get; set; }
        public string FormatedProbation { get; set; }
        public string FormatedConfrm { get; set; }
        public string Personal_No { get; set; }
        public string ReportingTo { get; set; }
        public string Father { get; set; }
        public string Mother { get; set; }
        public string Spouse { get; set; }
        public DateTime? Probation { get; set; }
        public DateTime? Confirm { get; set; }
        public decimal? Basic { get; set; }
        public string CurrencyCd { get; set; }
        public string Currency { get; set; }
        public decimal? CurrencyExchangeRate { get; set; }
        public bool FareEligible { get; set; }
        public string FareEligiblity { get; set; }
        public decimal? NoOfTickets { get; set; }
        public string TravelSector { get; set; }
        public string TravelClass { get; set; }
        public string HomeBase { get; set; }
        public string PayMode { get; set; }
        public string PayFrequency { get; set; }
        public string Bank { get; set; }
        public decimal? LeaveDays { get; set; }
        public string Status { get; set; }
        public string Sponsor { get; set; }
        public string SponsorCd { get; set; }
        public string ImageFilePath { get; set; }
        public string SignatureFilePath { get; set; }
        public string OTEligible { get; set; }
        public decimal? Leaveperiod { get; set; }
        public string TradeCode { get; set; }
        public string EmpType { get; set; }
        public string ApprCd { get; set; }
        public string BasicCurr { get; set; }
        public string UserId { get; set; }
        public string UserCd { get; set; }
        public string Shift { get; set; }
        public string CalcBasis { get; set; }
        public string GT { get; set; }
        public string LS { get; set; }
        public string LT { get; set; }
        public string Grade { get; set; }
        public string MobNo { get; set; }
        public decimal? Total { get; set; }
        public string Image { get; set; }
        public IFormFile ImageFile { get; set; }
        public string PassportLocation { get; set; }
        public string LvStatus { get; set; }
        public string Active { get; set; }
        public string EntryBy { get; set; }
    }
}
