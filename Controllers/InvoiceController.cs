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
    public class InvoiceController : Controller
    {
        [UserAuth]
        public ActionResult Index()
        {
            return View();
        }

        public PartialViewResult ViewDetail(Guid InvoiceId)
        {
            DataSet ds = clsData.getDataSet("sp_Invoice_Select_Id", InvoiceId);
            ViewBag.Invoice = ds.Tables[0];
            ViewBag.Product = ds.Tables[1];
            return PartialView();
        }



        [HttpGet]
        public string SelectTable(string Ngay, int OrderBy, int PageIndex)
        {
            return clsData.getJson("sp_Invoice_Select_Table", Ngay, OrderBy, PageIndex, clsGlobal.DefaultRows);
        }

        [HttpGet]
        public string SelectPage(string Ngay)
        {
            return clsData.getJson("sp_Invoice_Select_Page", Ngay, clsGlobal.DefaultRows);
        }

        [HttpPost]
        public string DeleteInvoice(Guid InvoiceId)
        {
            return clsData.executeCommand("sp_Invoice_Delete", InvoiceId, clsGlobal.EmployeeId);
        }
    }
}