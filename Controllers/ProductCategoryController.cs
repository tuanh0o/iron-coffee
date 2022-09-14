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
    public class ProductCategoryController : Controller
    {
        [ChildActionOnly]
        public PartialViewResult ModalAdd()
        {
            return PartialView();
        }

        [ChildActionOnly]
        public PartialViewResult ModalEdit()
        {
            return PartialView();
        }

        [HttpGet]
        public string Select()
        {
            return clsData.getJson("sp_ProductCategory_Select");
        }

        [HttpGet]
        public string SelectId(Guid ProductCategoryId)
        {
            return clsData.getJson("sp_ProductCategory_SelectId", ProductCategoryId);
        }

        [HttpPost]
        public string Insert(string Name, string Note)
        {
            DataTable dtMsg = clsData.getDataTable("sp_ProductCategory_Insert", Name, Note, clsGlobal.EmployeeId);
            return dtMsg.Rows[0]["MsgCode"].ToString();
        }

        [HttpPost]
        public string Update(Guid ProductCategoryId, string Name, string Note)
        {
            DataTable dtMsg = clsData.getDataTable("sp_ProductCategory_Update", ProductCategoryId, Name, Note, clsGlobal.EmployeeId);
            return dtMsg.Rows[0]["MsgCode"].ToString();
        }

        [HttpPost]
        public string Delete(Guid ProductCategoryId)
        {
            return clsData.executeCommand("sp_ProductCategory_Delete", ProductCategoryId, clsGlobal.EmployeeId);
        }
    }
}