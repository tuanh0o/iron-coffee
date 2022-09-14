using QLBH_IRON.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QLBH_IRON.Controllers
{
    public class ReportController : Controller
    {
        [UserAuth]
        public ActionResult SaleOnDay()
        {
            return View();
        }




    }
}