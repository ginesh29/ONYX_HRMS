namespace Onyx.Models.StoredProcedure
{
    public class GetMenuWithPermissions_Result
    {
        public string AppCd { get; set; }
        public int MenuId { get; set; }
        public int Prnt { get; set; }
        public string Caption { get; set; }
        public int MenuOrder { get; set; }
        public string Typ { get; set; }
        public string Frm { get; set; }
        public string Visible { get; set; }
        public List<GetMenuWithPermissions_Result> Children { get; set; } = new List<GetMenuWithPermissions_Result>();
    }
}
