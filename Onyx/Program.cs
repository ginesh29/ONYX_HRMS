using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Mvc.Razor;
using Onyx.BackgroundTask;
using Onyx.Data;
using Onyx.Middleware;
using Onyx.Services;
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
builder.Services.AddSingleton<TokenService>();
builder.Services.AddSingleton<ReportService>();
builder.Services.AddSingleton<EmailService>();
builder.Services.AddControllersWithViews()
            .AddViewLocalization(LanguageViewLocationExpanderFormat.Suffix)
            .AddDataAnnotationsLocalization();

builder.Services.Configure<RequestLocalizationOptions>(options =>
{
    var supportedCultures = new List<CultureInfo>
        {
            new CultureInfo("en-GB"),
            new CultureInfo("ar"),
            new CultureInfo("fa")
        };

    options.DefaultRequestCulture = new RequestCulture("en-GB");
    options.SupportedCultures = supportedCultures;
    options.SupportedUICultures = supportedCultures;

    options.RequestCultureProviders = new List<IRequestCultureProvider>
        {
            new QueryStringRequestCultureProvider(),
            new CookieRequestCultureProvider()
        };
});
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie();

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
app.Run();