using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
{
    public class Employee_Find_Result
    {
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "Emp. Code")]
        public string Cd { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]

        [Display(Name = "Salutation")]
        public string Salute { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        [Display(Name = "First Name")]
        public string Fname { get; set; }
        [Display(Name = "Middle Name")]
        public string Mname { get; set; }
        [Display(Name = "Last Name")]
        public string Lname { get; set; }
        [Display(Name = "Gender")]
        public string Sex { get; set; }
        public string CoCd { get; set; }
        [Display(Name = "Branch")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string Div { get; set; }
        public string CC { get; set; }
        [Display(Name = "Department")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string Dept { get; set; }
        [Display(Name = "Location")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string LocCd { get; set; }
        [Display(Name = "Place of Birth")]
        public string POB { get; set; }
        [Display(Name = "Nationality")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string Nat { get; set; }
        [Display(Name = "Religion")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string Relg { get; set; }
        [Display(Name = "Marital Status")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string Marital { get; set; }
        [Display(Name = "Designation")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string Desg { get; set; }
        [Display(Name = "Date of Birth")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? Dob { get; set; }
        [Display(Name = "Date of Joining")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? Doj { get; set; }
        [Display(Name = "Reporting To")]
        public string RepTo { get; set; }
        [Display(Name = "Father Name")]
        public string Father { get; set; }
        [Display(Name = "Mother Name")]
        public string Mother { get; set; }
        [Display(Name = "Spouse Name")]
        public string Spouse { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? Probation { get; set; }
        [Display(Name = "Confirmation")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public DateTime? Confrm { get; set; }
        public DateTime? Leaving { get; set; }
        [Display(Name = "Basic Currency")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string BasicCurr { get; set; }
        public decimal? Basic { get; set; }
        [Display(Name = "Payment Currency")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string CurrCd { get; set; }
        public string FareEligible { get; set; }
        public bool FareEligibleValue { get; set; }
        [Display(Name = "No. of Tickets")]
        public decimal? NoTickets { get; set; }
        [Display(Name = "Travel Sector")]
        public string TravSect { get; set; }
        [Display(Name = "Travel Class")]
        public string TravClass { get; set; }
        [Display(Name = "Home Base")]
        public string HomeBase { get; set; }
        [Display(Name = "Payment Mode")]
        public string PayMode { get; set; }
        [Display(Name = "Payment Frequency")]
        public string PayFreq { get; set; }
        [Display(Name = "Payment Bank")]
        public string BankCd { get; set; }
        [Display(Name = "Leave Salary Days/Year")]
        public decimal? LvDays { get; set; }
        public decimal? LvEntitled { get; set; }
        public decimal? LvUsed { get; set; }
        public decimal? LvBal { get; set; }
        public string GlPostCd { get; set; }
        public string Status { get; set; }
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string Sponsor { get; set; }
        [Display(Name = "Image")]
        public string Imagefile { get; set; }
        [Display(Name = "Signature")]
        public string ImageSign { get; set; }
        public IFormFile AvatarFile { get; set; }
        public IFormFile SignatureFile { get; set; }
        public string EntryBy { get; set; }
        public DateTime? EntryDt { get; set; }
        public string EditBy { get; set; }
        public DateTime? EditDt { get; set; }
        public string Grade { get; set; }
        public string OTEligible { get; set; }
        public DateTime? LvDueDt { get; set; }
        [Display(Name = "Leave Period")]
        public decimal? LvPrd { get; set; }
        public string TradeCd { get; set; }
        [Display(Name = "Emp. Type")]
        public string EmpTyp { get; set; }
        [Display(Name = "Emp. Password")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string Pwd { get; set; }
        [Compare("Pwd", ErrorMessage = CommonMessage.CONFIRMPASSWORDNOTMATCHED)]
        [Display(Name = "Confirm Password")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDVALIDATION)]
        public string ConfirmPassword { get; set; }
        public string ApprCd { get; set; }
        public string SkillClass { get; set; }
        public string MoreInfo { get; set; }
        [Display(Name = "Linked To")]
        [Required(ErrorMessage = ValidationMessage.REQUIREDSELECTVALIDATION)]
        public string UserCd { get; set; }
        public string ShiftCd { get; set; }
        [Display(Name = "Calculation Basis")]
        public string CalcBasis { get; set; }
        public string GT { get; set; }
        [Display(Name = "Graduity")]
        public bool GTValue { get; set; }
        public string LS { get; set; }
        public bool LSValue { get; set; }
        public string LT { get; set; }
        public bool LTValue { get; set; }
        public string Active { get; set; }
        public bool ActiveValue { get; set; }
        [Display(Name = "Person Id")]
        public string Personal_No { get; set; }
        [Display(Name = "Passport Loc./Rack No#")]
        public string PassportLocation { get; set; }
        public string FormatedDOB { get; set; }
        public string FormatedDOJ { get; set; }
        public string FormatedProbation { get; set; }
        public string FormatedConfirmation { get; set; }
        public string FormatedLeaving { get; set; }
        public string FormatedEntryDt { get; set; }
        public string FormatedEditDt { get; set; }
        public string FormatedLvDueDt { get; set; }
        public decimal LvOb { get; set; }
        [Display(Name = "Leave Days/Year")]
        public decimal LvMax { get; set; }
        public string Code { get; set; }
        public string Mode
        {
            get
            {
                return !string.IsNullOrEmpty(Code) ? "U" : "I";
            }
        }
    }
}