using ElectronNET.API;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Mvc.Razor;
using Onyx.BackgroundTask;
using Onyx.Data;
using Onyx.Middleware;
using Onyx.Services;
using Onyx.SignalR.Hubs;
using Rotativa.AspNetCore;
using System.Globalization;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddMemoryCache();
builder.Services.AddHostedService<QueuedHostedService>();
builder.Services.AddSingleton<IBackgroundTaskQueue, BackgroundTaskQueue>();
builder.Services.AddHttpContextAccessor();
builder.Services.AddSingleton<AppDbContext>();
builder.Services.AddSingleton<DbGatewayService>();
builder.Services.AddSingleton<AuthService>();
builder.Services.AddSingleton<CommonService>();
builder.Services.AddSingleton<LogService>();
builder.Services.AddSingleton<UserService>();
builder.Services.AddSingleton<EmployeeService>();
builder.Services.AddSingleton<SettingService>();
builder.Services.AddSingleton<OrganisationService>();
builder.Services.AddSingleton<TransactionService>();
builder.Services.AddSingleton<QueueService>();
builder.Services.AddSingleton<ReportService>();
builder.Services.AddSingleton<EmailService>();
builder.Services.AddControllersWithViews()
            .AddViewLocalization(LanguageViewLocationExpanderFormat.Suffix)
            .AddDataAnnotationsLocalization();

builder.Services.Configure<FormOptions>(options =>
{
    options.MultipartBodyLengthLimit = 100 * 1024 * 1024;
});
builder.Services.Configure<RequestLocalizationOptions>(options =>
{
    var supportedCultures = new List<CultureInfo>
        {
            new("en-GB"),
            new("ar"),
            new("fa")
        };

    options.DefaultRequestCulture = new RequestCulture("en-GB");
    options.SupportedCultures = supportedCultures;
    options.SupportedUICultures = supportedCultures;
    foreach (var culture in supportedCultures)
        culture.DateTimeFormat.ShortDatePattern = "dd/MM/yyyy";
    options.RequestCultureProviders = [new QueryStringRequestCultureProvider(), new CookieRequestCultureProvider()];
});
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie();
builder.Services.AddSignalR();
builder.WebHost.UseElectron(args);
builder.Services.AddElectron();
var app = builder.Build();
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseMiddleware<ExceptionHandlingMiddleware>();
    app.UseHsts();
}
app.UseDeveloperExceptionPage();
app.UseRotativa();
app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
var supportedCultures = new[] { "en-GB", "ar", "fa" };
var localizationOptions = new RequestLocalizationOptions().SetDefaultCulture("en-GB")
    .AddSupportedCultures(supportedCultures)
    .AddSupportedUICultures(supportedCultures);

app.UseRequestLocalization(localizationOptions);
app.UseMiddleware<CookieExpirationMiddleware>();
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
app.MapHub<ChatHub>("/chathub");
if (HybridSupport.IsElectronActive)
{
    ElectronBootstrap();
}
app.Run();
static async void ElectronBootstrap()
{
    var window = await Electron.WindowManager.CreateWindowAsync();
    window.OnClosed += Electron.App.Quit;
}