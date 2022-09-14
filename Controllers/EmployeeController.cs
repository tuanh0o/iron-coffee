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
    public class EmployeeController : Controller
    {
        [UserAuth]
        public ActionResult Index()
        {
            return View();
            DataTable dtRole = clsData.getDataTable("sp_Role_Select");
            ViewBag.dtRole = dtRole;
        }

        [ChildActionOnly]
        public PartialViewResult AddEmployeePartial()
        {
            return PartialView();
        }

        [ChildActionOnly]
        public PartialViewResult EditEmployeePartial()
        {
            return PartialView();
        }

        [HttpGet]
        public string SelectTable(string Search, int OrderBy, int PageIndex)
        {
            return clsData.getJson("sp_User_Select_Table", Search, OrderBy, PageIndex, clsGlobal.DefaultRows);
        }

        [HttpGet]
        public string SelectPage(string Search)
        {
            return clsData.getJson("sp_User_Select_Page", Search, clsGlobal.DefaultRows);
        }

        [HttpPost]
        public string SelectId(string userId)
        {
            return clsData.getJson("sp_User_SelectId", userId);
        }

        [HttpPost]
        public string Edit(string id, string name, string phone, string email)
        {
            return clsData.executeCommand("sp_User_Update", id, "", name, "", 0);
        }

        [HttpPost]
        public string Add(string name, string phone, string email, string account, string password)
        {
            string msgCode = "Thêm nhân viên thất bại, xin vui lòng thử lại";
            string securityStamp = clsRandomString.GetBase62(100);
            string passwordHash = clsSHA256.ComputeSha256Hash(securityStamp + password);

            DataTable dtMsg = clsData.getDataTable("sp_User_Insert", name, account, "", securityStamp, passwordHash, "", 0);
            foreach (DataRow item in dtMsg.Rows)
            {
                msgCode = item["MsgCode"].ToString();
            }
            return msgCode;
        }

        [HttpPost]
        public string ResetPassword(string employeeId, string password)
        {
            string newSecurityStamp = clsRandomString.GetBase62(100);
            string newPasswordHash = clsSHA256.ComputeSha256Hash(string.Concat(newSecurityStamp, password));
            return clsData.executeCommand("sp_User_Reset_Password", employeeId, newSecurityStamp, newPasswordHash);
        }

        [HttpPost]
        public string Delete(string id)
        {
            return clsData.executeCommand("sp_User_Delete", id, clsGlobal.EmployeeId);
        }

        [HttpPost]
        public string SelectRole(string employeeId)
        {
            return clsData.getJson("sp_Role_Select_By_EmployeeId", employeeId);
        }

        [HttpPost]
        public string SetRole(string employeeId, string arrRole)
        {
            return clsData.executeCommand("sp_User_Role_Insert", employeeId, arrRole);
        }
    }
}