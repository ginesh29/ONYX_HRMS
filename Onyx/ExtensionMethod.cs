using System.Text;
using System.Text.Json;

namespace Onyx
{
    public static class ExtensionMethod
    {
        public static dynamic StringToJsonObject<T>(this object jsonString)
        {
            return JsonSerializer.Deserialize<T>(jsonString.ToString());
        }
        public static string JsonObjectToString(this object jsonObject)
        {
            return jsonObject is not null ? JsonSerializer.Serialize(jsonObject) : string.Empty;
        }
        public static bool Between(this int num, int lower, int upper, bool inclusive = true)
        {
            return inclusive
                ? lower <= num && num <= upper
                : lower < num && num < upper;
        }
        public static bool Between(this double num, int lower, int upper, bool inclusive = true)
        {
            return inclusive
                ? lower <= num && num <= upper
                : lower < num && num < upper;
        }
        public static bool Between(this long num, int lower, int upper, bool inclusive = true)
        {
            return inclusive
                ? lower <= num && num <= upper
                : lower < num && num < upper;
        }
        public static bool BetweenDate(this DateTime date, DateTime start, DateTime end)
        {
            return start <= date && date <= end;
        }
        public static bool IsBetweenTime(this DateTime date, TimeSpan start, TimeSpan end)
        {
            var time = date.TimeOfDay;
            return start <= time && time <= end;
        }
        public static int NagativeToZero(this int value)
        {
            return value > 0 ? value : 0;
        }
        public static double NagativeToZero(this double value)
        {
            return value > 0 ? value : 0;
        }
        public static long NagativeToZero(this long value)
        {
            return value > 0 ? value : 0;
        }
        public static Guid ToGuid(this string stringValue)
        {
            return stringValue != null ? new Guid(stringValue) : Guid.Empty;
        }
        public static string ToCurrency(this int amount)
        {
            int multiplier = amount > 0 ? 1 : -1;
            string prefix = amount < 0 ? "-" : string.Empty;
            return $"{prefix}{string.Format("{0:C0}", amount * multiplier)}";
        }
        public static string FormatNagativeAmount(this int amount)
        {
            string sign = amount > 0 ? "" : "-";
            string result = string.Format("{0:C0}", amount);
            if (amount < 0)
                result = $"{sign}{string.Format("{0:C0}", Math.Abs(amount))}";
            return result;
        }
        public static string BoolToYesNo(this bool value)
        {
            if (value)
                return "Yes";
            else
                return "No";
        }
        public static string Encrypt(this string password)
        {
            string encryptedstring;
            byte[] data;
            data = Encoding.ASCII.GetBytes(password);
            encryptedstring = Convert.ToBase64String(data);
            return encryptedstring;
        }
        public static string Decrypt(this string hash)
        {
            byte[] data;
            string decryptedstring;
            data = Convert.FromBase64String(hash);
            decryptedstring = Encoding.ASCII.GetString(data);
            return decryptedstring;
        }
        public static string ConvertToSlug(this string text)
        {
            string lowercaseText = text.ToLower();
            string withoutAmpersand = lowercaseText.Replace("&", "");
            string slug = withoutAmpersand.Replace(" ", "-");
            return slug;
        }
        public static bool FileExist(this string filename, string foldername, string CoCd)
        {
            var path = Path.Combine(Directory.GetCurrentDirectory(), $"wwwroot/uploads/{CoCd}/{foldername}/{filename}");
            return File.Exists(path);
        }
        public static string GetDateRange(DateTime? start, DateTime? end, string format = CommonSetting.USDateFormat)
        {
            return $"{Convert.ToDateTime(start).ToString(format).Replace("-", "/")} - {Convert.ToDateTime(end).ToString(format).Replace("-", "/")}";
        }
    }
}