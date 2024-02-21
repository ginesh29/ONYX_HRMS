
using System.Net;
using System.Net.Mail;

namespace Onyx.Services
{
    public class EmailService
    {
        public async Task SendEmailAsync(IEnumerable<string> toEmails, string subject, string body)
        {
            try
            {
                var message = new MailMessage
                {
                    From = new MailAddress("ginesh29@gmail.com", "Onyx")
                };
                foreach (var toEmail in toEmails)
                    message.To.Add(toEmail);
                message.Subject = subject;
                message.Body = body;
                message.IsBodyHtml = true;
                using var client = new SmtpClient("smtp.gmail.com", 587);
                client.EnableSsl = true;
                client.UseDefaultCredentials = false;
                client.Credentials = new NetworkCredential("ginesh29@gmail.com", "agta ufih lejq taaa");
                await client.SendMailAsync(message);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                throw;
            }
        }
    }
}
