namespace Onyx.Models.StoredProcedure
{
    public class EmpLeave_View_GetRow_Result
    {
        public string TransNo { get; set; }
        public DateTime? AppDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmpCd { get; set; }
        public string Emp { get; set; }
        public string LvTyp { get; set; }
        public int? LvTaken { get; set; }
        public DateTime? DocDt { get; set; }
        public string FormatedDocDt { get; set; }
        public string Substitute { get; set; }
        public DateTime? FromDt { get; set; }
        public string FormatedFromDt { get; set; }
        public string DateRange { get; set; }
        public DateTime? ToDt { get; set; }
        public string FormatedToDt { get; set; }
        public string LvInter { get; set; }
        public DateTime? WpFrom { get; set; }
        public string FormatedWP_FromDt { get; set; }
        public DateTime? WpTo { get; set; }
        public string FormatedWp_ToDt { get; set; }
        public DateTime? WopFrom { get; set; }
        public string FormatedWOP_FromDt { get; set; }
        public DateTime? WopTo { get; set; }
        public string FormatedWOP_ToDt { get; set; }
        public string ApprBy { get; set; }
        public DateTime? ApprDt { get; set; }
        public string FormatedApprDt { get; set; }
        public int? ApprDays { get; set; }
        public string Branch { get; set; }
        public string Div { get; set; }
        public string Designation { get; set; }
    }
}
