using MailKit.Net.Smtp;
using MimeKit;
using Onyx.BackgroundTask;
using Onyx.Models.ViewModels;

namespace Onyx.Services
{
    public class EmailService(IBackgroundTaskQueue queue)
    {
        private readonly IBackgroundTaskQueue _queue = queue;
        public void SendEmail(EmailRecipientModel recipient, string subject, string htmlBody)
        {
            try
            {
                _queue.QueueBackgroundWorkItem(async (token) =>
                {
                    var message = new MimeMessage();
                    message.From.Add(new MailboxAddress("Onyx Email Notification", "ginesh29@gmail.com"));
                    using var client = new SmtpClient();
                    message.To.Add(new MailboxAddress(recipient.RecipientName, recipient.RecipientEmail));
                    message.Subject = subject;
                    List<System.Net.Mail.LinkedResource> linkedResources = [];
                    var bodyBuilder = new BodyBuilder
                    {
                        HtmlBody = htmlBody
                    };
                    var header_logo = bodyBuilder.LinkedResources.Add(Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/images/brand_logo.png"));
                    header_logo.ContentId = "HeaderLogo";
                    if (linkedResources != null)
                        foreach (var linkedResource in linkedResources)
                            bodyBuilder.LinkedResources.Add(linkedResource.ContentId);
                    message.Body = bodyBuilder.ToMessageBody();
                    await client.ConnectAsync("smtp.gmail.com", 587, false);
                    await client.AuthenticateAsync("ginesh29@gmail.com", "agta ufih lejq taaa");
                    await client.SendAsync(message);
                    await client.DisconnectAsync(true);
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
        }
    }
}
