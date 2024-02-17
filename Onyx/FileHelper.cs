namespace Onyx
{
    public class FileHelper()
    {
        public async Task<string> UploadFile(IFormFile file, string folderName)
        {
            var ext = Path.GetExtension(file.FileName);
            var newFileName = $"{Guid.NewGuid()}{ext}";
            var folderPath = Path.Combine(Directory.GetCurrentDirectory(), $"wwwroot/uploads", folderName);
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
    }
}
