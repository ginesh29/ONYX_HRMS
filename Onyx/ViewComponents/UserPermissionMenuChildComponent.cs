using Microsoft.AspNetCore.Mvc;
using Onyx.Models.StoredProcedure;

namespace Onyx.ViewComponents
{
    public class UserPermissionMenuChildViewComponent : ViewComponent
    {
        public IViewComponentResult Invoke(IEnumerable<GetMenuWithPermissions_Result> items)
        {
            return View(items);
        }
    }
}