namespace Onyx.Middleware
{
    public class CookieExpirationMiddleware(RequestDelegate next)
    {
        private readonly RequestDelegate _next = next;
        public async Task Invoke(HttpContext context)
        {
            if (!context.User.Identity.IsAuthenticated)
            {
                var a = DateTime.Now;
            }
            await _next(context);
        }
    }
}
