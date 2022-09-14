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
    public class SettingController : Controller
    {
        [UserAuth]
        public ActionResult Index()
        {
            DataTable dt = clsData.getDataTable("sp_Config_Select");
            ViewBag.dtInfo = dt;
            return View();
        }

        public string UpdateInfo(string Name, string Address, string Phone, string Wifi)
        {
            return clsData.executeCommand("sp_Config_Update", Name, Address, Phone, Wifi);
        }
    }
}