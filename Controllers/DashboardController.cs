using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using QLBH_IRON.DAL;
using QLBH_IRON.Utils;

namespace QLBH_IRON.Controllers
{
    public class DashboardController : Controller
    {
        [UserAuth]
        public ActionResult Index()
        {
            DataTable dt = clsData.getDataTable("sp_Dashboard_Select_Count_Top");
            ViewBag.dtCount = dt;

            return View();
        }

        public PartialViewResult ViewInvoicePartial(Guid InvoiceId)
        {
            DataSet ds = clsData.getDataSet("sp_Invoice_Select_Id", InvoiceId);
            ViewBag.dtInvoice = ds.Tables[0];
            ViewBag.dtProduct = ds.Tables[1];
            return PartialView();
        }


        [HttpGet]
        public string SelectChartQuantity() {
            return clsData.getJson("sp_Dashboard_Select_Chart_Quantity");
        }

        [HttpGet]
        public string SelectChartMoney()
        {
            return clsData.getJson("sp_Dashboard_Select_Chart_Money");
        }

        [HttpGet]
        public string SelectTimeline(string Day)
        {
            return clsData.getJson("sp_Dashboard_Select_Timeline", Day);
        }
    }
}