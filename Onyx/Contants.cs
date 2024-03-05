namespace Onyx
{
    public class CommonSetting
    {
        public const string MAINCOMPANY = "TELAL";
        public const string DEFAULTSELECT = "-- Select --";
        public const string ALLSELECT = "-- All --";
        public const string DateFormat = "MM/dd/yyyy";
    }
    public class SysCode
    {
        public const string ComponentClass = "HEDT";
        public const string DayType = "HOTC2";
        public const string Religion = "HOTC1";
        public const string OtTpe = "HCOTT";

    }
    public class CodeGroup
    {
        public const string Bank = "BANK";
        public const string BankBranch = "BNKBR";
        public const string DocType = "HCDOC";
        public const string Sector = "TSECTTSECT";
        public const string Class = "TCLAS";
        public const string EmpDeployLoc = "HLOC";
        public const string State = "STATE";
        public const string Owner = "OWNER";
        public const string Model = "MODEL";
        public const string Color = "COLOR";
        public const string Driver = "DRIV";
        public const string VehicleDoc = "HVDOC";
        public const string Salutation = "SALUT";
        public const string MaritalStatus = "HMS";
        public const string Religion = "HRELG";
        public const string Sponsor = "ESPON";
    }
    public class CommonMessage
    {
        public const string INSERTED = "Inserted Successfully.";
        public const string UPDATED = "Updated Successfully";
        public const string DELETED = "Deleted Successfully";
        public const string SELECTROW = "Please select a record for Edit or Delete";
        public const string EMPTYGRID = "No data available";
        public const string INVALIDUSER = "Invalid Username or Password";
        public const string NOTHING = "Nothing to Display.";
        public const string LYSERVERUPDATED = "Loyalty Server is updated";
        public const string SELECTONE = "Select one from the list";
        public const string CHKITEMORCUST = "Invalid Redeed Item. Please refer Red.Rules";
        public const string INSUFFICIENTREDPOINTS = "Your Balance point is too low to redeem this item";
        public const string USEREXISTS = "User already exists";
        public const string ITEMNOTFOUND = "Item not found";
        public const string REMOTECONPROBLEM = "Could not connect to Remote Server in order to fetch Item and Group details";
        public const string INVALIDENTRY = "Invalid Data Entry";
        public const string CANNOTUPDATEADMINPASSWORD = "You can not update Admin Password";
        public const string CONFIRMPASSWORDNOTMATCHED = "Confirm Password not match with New Password";
    }
    public class ValidationMessage
    {
        public const string REQUIREDVALIDATION = "Please enter {0}";
        public const string REQUIREDSELECTVALIDATION = "Please select {0}";
        public const string REQUIREDFILEVALIDATION = "Please upload {0}";
        public const string PASSWORDMISMATCHVALIDATION = "{0} mismatch";
        public const string ENTERVALID = "Please enter valid {0}";
    }
}