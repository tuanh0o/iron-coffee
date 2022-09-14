using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using QLBH_IRON.DAL;
using QLBH_IRON.Utils;
using Newtonsoft.Json;
using System.Data;

namespace QLBH_IRON.Controllers
{
    public class SaleController : Controller
    {
        [UserAuth]
        public ActionResult Index()
        {
            DataSet ds = clsData.getDataSet("sp_Invoice_Select_Waiting_To_Pay");
            ViewBag.dtInvoiceWaiting = ds.Tables[0];
            ViewBag.dtInvoiceDetailWaiting = ds.Tables[1];
            return View();
        }

        [ChildActionOnly]
        public PartialViewResult SaleInvoicePartial()
        {
            DataTable dtInfo = clsData.getDataTable("sp_Config_Select");
            ViewBag.dtInfo = dtInfo;
            return PartialView();
        }

        [ChildActionOnly]
        public PartialViewResult ReportSalePartial()
        {
            return PartialView();
        }

        [ChildActionOnly]
        public PartialViewResult RevenuesPartial()
        {
            return PartialView();
        }

        [ChildActionOnly]
        public PartialViewResult PrintWaitingInvoice()
        {
            return PartialView();
        }

        //--------------------------------------------------------FUNCTIONS
        [HttpPost]
        public string ProductSelect(string Search)
        {
            return clsData.getJson("sp_Product_Select_Dropdown_Sale", Search);
        }

        [HttpPost]
        public string InvoicePayment(string CustomerId, string TotalPrice, string SaleValue, string SaleType, string OtherFeeValue,
            string OtherFeeDescription, string InvoiceValue, string InvoiceNote, string DtInvoice)
        {
            DataTable dt = JsonConvert.DeserializeObject<DataTable>(DtInvoice);
            return clsData.getJson("sp_Invoice_Insert_Payment", CustomerId, TotalPrice, SaleValue, SaleType, OtherFeeValue,
                OtherFeeDescription, InvoiceValue, InvoiceNote, clsGlobal.EmployeeId, dt);
        }

        [HttpPost]
        public string InvoiceWaiting(string CustomerId, string TotalPrice, string SaleValue, string SaleType, string OtherFeeValue,
            string OtherFeeDescription, string InvoiceValue, string InvoiceNote, string DtInvoice)
        {
            DataTable dt = JsonConvert.DeserializeObject<DataTable>(DtInvoice);
            return clsData.getJson("sp_Invoice_Insert_Waiting_To_Pay", CustomerId, TotalPrice, SaleValue, SaleType, OtherFeeValue,
                OtherFeeDescription, InvoiceValue, InvoiceNote, clsGlobal.EmployeeId, dt);
        }

        [HttpGet]
        public JsonResult SelectId(Guid InvoiceId)
        {
            DataSet ds = clsData.getDataSet("sp_Invoice_Select_Id", InvoiceId);
            return Json(new
            {
                Invoice = clsJson.DataTableToJSONWithJavaScriptSerializer(ds.Tables[0]),
                Product = clsJson.DataTableToJSONWithJavaScriptSerializer(ds.Tables[1])
            }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public string InvoiceRePayment(Guid InvoiceId, string CustomerId, string TotalPrice, string SaleValue, string SaleType, string OtherFeeValue,
            string OtherFeeDescription, string InvoiceValue, string InvoiceNote, string DtInvoice)
        {
            DataTable dt = JsonConvert.DeserializeObject<DataTable>(DtInvoice);
            return clsData.getJson("sp_Invoice_Insert_Payment_Re", InvoiceId, CustomerId, TotalPrice, SaleValue, SaleType, OtherFeeValue,
                OtherFeeDescription, InvoiceValue, InvoiceNote, clsGlobal.EmployeeId, dt);
        }

        [HttpPost]
        public string InvoiceReWaiting(Guid InvoiceId, string CustomerId, string TotalPrice, string SaleValue, string SaleType, string OtherFeeValue,
            string OtherFeeDescription, string InvoiceValue, string InvoiceNote, string DtInvoice)
        {
            DataTable dt = JsonConvert.DeserializeObject<DataTable>(DtInvoice);
            return clsData.getJson("sp_Invoice_Insert_Waiting_To_Pay_Re", InvoiceId, CustomerId, TotalPrice, SaleValue, SaleType, OtherFeeValue,
                OtherFeeDescription, InvoiceValue, InvoiceNote, clsGlobal.EmployeeId, dt);
        }

        [HttpGet]
        public string SelectReport() {
            return clsData.getJson("sp_Invoice_Select_Report");
        }
    }
}