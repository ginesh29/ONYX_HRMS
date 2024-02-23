namespace Onyx
{
    public class FileHelper()
    {
        public async Task<string> UploadFile(IFormFile file, string folderName,string CoCd)
        {
            var ext = Path.GetExtension(file.FileName);
            var newFileName = $"{Guid.NewGuid()}{ext}";
            var folderPath = Path.Combine(Directory.GetCurrentDirectory(), $"wwwroot/uploads/{CoCd}", folderName);
            bool exists = Directory.Exists(folderPath);
            if (!exists)
                Directory.CreateDirectory(folderPath);
            var filePath = $"{folderPath}/{newFileName}";
            if (File.Exists(filePath))
                File.Delete(filePath);
            using (var stream = new FileStream(filePath, FileMode.Create))
                await file.CopyToAsync(stream);
            return newFileName;
        }
        public void RemoveFile(string filename, string folderName)
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), $"wwwroot/uploads/{folderName}", filename);
            if (File.Exists(filePath))
                File.Delete(filePath);
        }
    }
}
