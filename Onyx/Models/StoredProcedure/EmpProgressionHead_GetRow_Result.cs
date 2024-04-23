namespace Onyx.Models.StoredProcedure
{
    public class EmpProgressionHead_GetRow_Result
    {
        public string TransNo { get; set; }
        public DateTime? TransDt { get; set; }
        public string FormatedTransDt { get; set; }
        public string EmpCode { get; set; }
        public string Name { get; set; }
        public string EmpName { get; set; }
        public string DesigFrom { get; set; }
        public string DesigTo { get; set; }
        public string DesigFromCd { get; set; }
        public string DesigToCd { get; set; }
        public string ApprName { get; set; }
        public string ApprBy { get; set; }
        public string ApprDt { get; set; }
        public string FormatedApprDt { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public string StatusCd { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string EP_Typ { get; set; }
        public string EP_TypeCd { get; set; }
        public decimal? Current_Approval_Level { get; set; }
        public string Current_Approval { get; set; }
        public EmpProgressionDetail_GetRow_Result Detail { get; set; }
    }
}
