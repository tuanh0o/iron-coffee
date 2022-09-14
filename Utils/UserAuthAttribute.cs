using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QLBH_IRON.Utils
{
    public class UserAuthAttribute : AuthorizeAttribute
    {
        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            if (HttpContext.Current.Session["USER_ID"] != null)
            {
            }
            else
            {
                filterContext.Result = new RedirectResult("/");
            }
        }
    }
}