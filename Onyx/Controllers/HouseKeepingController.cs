using Microsoft.AspNetCore.Mvc;

namespace Onyx.Controllers
{
    public class HouseKeepingController : Controller
    {
        public IActionResult MonthEndProcess()
        {
            return View();
        }
    }
}
