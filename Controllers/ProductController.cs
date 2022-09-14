using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using QLBH_IRON.DAL;
using QLBH_IRON.Utils;
using System.Data;

namespace QLBH_IRON.Controllers
{
    public class ProductController : Controller
    {
        [UserAuth]
        public ActionResult Index()
        {
            DataTable dtCategory = clsData.getDataTable("sp_ProductCategory_Select");
            ViewBag.dtCategory = dtCategory;
            return View();
        }

        [ChildActionOnly]
        public PartialViewResult AddPartial()
        {
            return PartialView();
        }

        [ChildActionOnly]
        public PartialViewResult EditPartial()
        {
            return PartialView();
        }

        #region ----------------------------FUNCTIONS

        [HttpPost]
        public string Insert(Guid ProductCategoryId, string ProductImage,  string ProductCode, string ProductName, string ProductPrice)
        {
            DataTable dtMsg = clsData.getDataTable("sp_Product_Insert", ProductCategoryId, ProductImage, ProductCode, ProductName, ProductPrice, clsGlobal.EmployeeId);
            return dtMsg.Rows[0]["MsgCode"].ToString();
        }

        [HttpGet]
        public string SelectTable(string CategoryId, string Search, int OrderBy, int PageIndex)
        {
            return clsData.getJson("sp_Product_Select_Table", CategoryId, Search, OrderBy, PageIndex, clsGlobal.DefaultRows);
        }

        [HttpGet]
        public string SelectPage(string CategoryId, string Search)
        {
            return clsData.getJson("sp_Product_Select_Page", CategoryId, Search, clsGlobal.DefaultRows);
        }

        [HttpGet]
        public string SelectId(Guid ProductId)
        {
            return clsData.getJson("sp_Product_Select_Id", ProductId);
        }

        [HttpPost]
        public string Update(Guid ProductId, Guid ProductCategoryId, string ProductImage, string ProductName, string ProductPrice)
        {
            return clsData.executeCommand("sp_Product_Update", ProductId, ProductCategoryId, ProductImage, ProductName, ProductPrice, clsGlobal.EmployeeId);
        }

        [HttpPost]
        public string Delete(Guid ProductId)
        {
            return clsData.executeCommand("sp_Product_Delete", ProductId, clsGlobal.EmployeeId);
        }

        #endregion
    }
}