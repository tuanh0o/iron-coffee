using QLBH_IRON.DAL;
using QLBH_IRON.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QLBH_IRON.Controllers
{
    public class WarehouseController : Controller
    {
        [UserAuth]
        public ActionResult Index()
        {
            return View();
        }

        [ChildActionOnly]
        public PartialViewResult AddWarePartial()
        {
            return PartialView();
        }

        [ChildActionOnly]
        public PartialViewResult EditWarePartial()
        {
            return PartialView();
        }

        [ChildActionOnly]
        public PartialViewResult AddWareLogPartial()
        {
            return PartialView();
        }

        #region ----------------------------FUNCTIONS

        [HttpPost]
        public string Insert(string WareCode, string WareName, string Unit, int PriceIn, int PriceSale, int InStock, int InStockRcm, string Supplier, string Note)
        {
            DataTable dtMsg = clsData.getDataTable("sp_Warehouse_Insert", WareCode, WareName, Unit, PriceIn, PriceSale, InStock, InStockRcm, Supplier, Note, clsGlobal.EmployeeId);
            return dtMsg.Rows[0]["MsgCode"].ToString();
        }

        [HttpGet]
        public string SelectTable(string Search, string OrderBy, int PageIndex)
        {
            return clsData.getJson("sp_Warehouse_Select_Table", Search, OrderBy, PageIndex, clsGlobal.DefaultRows);
        }

        [HttpGet]
        public string SelectPage(string Search)
        {
            return clsData.getJson("sp_Warehouse_Select_Page", Search, clsGlobal.DefaultRows);
        }

        [HttpGet]
        public string SelectId(Guid WareId)
        {
            return clsData.getJson("sp_Warehouse_Select_Id", WareId);
        }
        
        [HttpGet]
        public string SelectUnit()
        {
            return clsData.getJson("sp_Unit_Select");
        }


        [HttpGet]
        public string SelectSupplier()
        {
            return clsData.getJson("sp_Supplier_Select");
        }

        [HttpPost]
        public string Update(Guid WareId, string WareName, Guid UnitId, int PriceIn, int PriceSale, int InStock, int InStockRcm, Guid SupplierId,  string Note)
        {
            return clsData.executeCommand("sp_Warehouse_Update", WareId, WareName, UnitId, PriceIn, PriceSale, InStock, InStockRcm, SupplierId, Note, clsGlobal.EmployeeId);
        }

        [HttpPost]
        public string Delete(Guid WareId)
        {
            return clsData.executeCommand("sp_Warehouse_Delete", WareId, clsGlobal.EmployeeId);
        }

        #endregion


    }
}