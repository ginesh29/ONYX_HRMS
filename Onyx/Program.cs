using Microsoft.AspNetCore.Authentication.Cookies;
using Onyx.BackgroundTask;
using Onyx.Data;
using Onyx.Services;

var builder = WebApplication.CreateBuilder(args);


builder.Services.AddSingleton<AppDbContext>();
builder.Services.AddHttpContextAccessor();
builder.Services.AddSingleton<CommonService>();
builder.Services.AddSingleton<AuthService>();
builder.Services.AddSingleton<UserService>();
builder.Services.AddSingleton<EmployeeService>();
builder.Services.AddSingleton<SettingService>();
builder.Services.AddSingleton<OrganisationService>();
builder.Services.AddSingleton<TransactionService>();
builder.Services.AddSingleton<EmailService>();
builder.Services.AddHostedService<QueuedHostedService>();
builder.Services.AddSingleton<IBackgroundTaskQueue, BackgroundTaskQueue>();
builder.Services.AddControllersWithViews();
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie();

var app = builder.Build();
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}
app.UseDeveloperExceptionPage();
app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
app.Run();