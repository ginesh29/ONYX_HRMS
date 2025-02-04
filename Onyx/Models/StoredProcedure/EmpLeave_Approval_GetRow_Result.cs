﻿namespace Onyx.Models.StoredProcedure
{
    public class EmpLeave_Approval_GetRow_Result
    {
        public string TransNo { get; set; }
        public DateTime? TransDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmpCd { get; set; }
        public string Emp { get; set; }
        public string LvTyp { get; set; }
        public int? LvTaken { get; set; }
        public DateTime? DocDt { get; set; }
        public string FormatedDocDt { get; set; }
        public string Substitute { get; set; }
        public DateTime? LvFrom { get; set; }
        public string FormatedFromDt { get; set; }
        public DateTime? LvTo { get; set; }
        public string FormatedToDt { get; set; }
        public string LvInter { get; set; }
        public DateTime? WP_FromDt { get; set; }
        public string FormatedWP_FromDt { get; set; }
        public DateTime? WP_ToDt { get; set; }
        public string FormatedWp_ToDt { get; set; }
        public DateTime? WOP_FromDt { get; set; }
        public string FormatedWOP_FromDt { get; set; }
        public DateTime? WOP_ToDt { get; set; }
        public string FormatedWOP_ToDt { get; set; }
        public string ApprBy { get; set; }
        public DateTime? ApprDt { get; set; }
        public string FormatedApprDt { get; set; }
        public decimal? ApprDays { get; set; }
        public string Branch { get; set; }
        public string Desg { get; set; }
        public string Reason { get; set; }
        public int Current_Approval_Level { get; set; }
        public string Current_Approval { get; set; }
        public string ImagePath { get; set; }
        public string Div { get; set; }
        public string Dept { get; set; }
        public string DeptCd { get; set; }
    }
}
