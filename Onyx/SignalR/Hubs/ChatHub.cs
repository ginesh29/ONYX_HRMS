using Microsoft.AspNetCore.SignalR;

namespace Onyx.SignalR.Hubs
{
    public class ChatHub : Hub
    {
        public async Task SendTokenCall(string message, string voiceName)
        {
            await Clients.All.SendAsync("ReceiveTokenCall", message, voiceName);
        }
        public async Task SendRefreshCall()
        {
            await Clients.All.SendAsync("ReceiveRefreshCall");
        }
        public async Task SendTokenAddCall()
        {
            await Clients.All.SendAsync("ReceiveTokenAddCall");
        }
    }
}
