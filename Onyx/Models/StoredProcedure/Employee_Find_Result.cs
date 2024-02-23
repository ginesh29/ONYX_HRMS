using System.ComponentModel.DataAnnotations;

namespace Onyx.Models.StoredProcedure
{
    public class Employee_Find_Result
    {
        public string Cd { get; set; }
        public string Salute { get; set; }
        public string Fname { get; set; }
        public string Mname { get; set; }
        public string Lname { get; set; }
        public string Sex { get; set; }
        public string CoCd { get; set; }
        public string Div { get; set; }
        public string CC { get; set; }
        public string Dept { get; set; }
        public string LocCd { get; set; }
        public string POB { get; set; }
        public string Nat { get; set; }
        public string Relg { get; set; }
        public string Marital { get; set; }
        public string Desg { get; set; }
        public DateTime? Dob { get; set; }
        public DateTime? Doj { get; set; }
        public string EmpCat1 { get; set; }
        public string EmpCat2 { get; set; }
        public string EmpCat3 { get; set; }
        public string RepTo { get; set; }
        public string Father { get; set; }
        public string Mother { get; set; }
        public string Spouse { get; set; }
        public DateTime? Probation { get; set; }
        public DateTime? Confrm { get; set; }
        public DateTime? Leaving { get; set; }
        public string BasicCurr { get; set; }
        public decimal? Basic { get; set; }
        public string CurrCd { get; set; }
        public string FareEligible { get; set; }
        public decimal? NoTickets { get; set; }
        public string TravSect { get; set; }
        public string TravClass { get; set; }
        public string HomeBase { get; set; }
        public string PayMode { get; set; }
        public string PayFreq { get; set; }
        public string BankCd { get; set; }
        public decimal? LvDays { get; set; }
        public decimal? LvEntitled { get; set; }
        public decimal? LvUsed { get; set; }
        public decimal? LvBal { get; set; }
        public string GlPostCd { get; set; }
        public string Status { get; set; }
        public string Sponsor { get; set; }
        public string Imagefile { get; set; }
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
        public decimal? LvPrd { get; set; }
        public string TradeCd { get; set; }
        public string EmpTyp { get; set; }
        public string Pwd { get; set; }
        [Compare("Pwd", ErrorMessage = CommonMessage.CONFIRMPASSWORDNOTMATCHED)]
        [Display(Name = "Confirm Password")]
        public string ConfirmPassword { get; set; }
        public string ApprCd { get; set; }
        public string SkillClass { get; set; }
        public string MoreInfo { get; set; }
        public string UserCd { get; set; }
        public string ShiftCd { get; set; }
        public string CalcBasis { get; set; }
        public string GT { get; set; }
        public string LS { get; set; }
        public string LT { get; set; }
        public string Active { get; set; }
        public string Personal_No { get; set; }
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
        public decimal LvMax { get; set; }
    }
}