using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using QLBH_IRON.DAL;
using QLBH_IRON.Models;
using QLBH_IRON.Utils;

namespace QLBH_IRON.Controllers
{
    public class LoginController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Login(LoginModel model)
        {
            int code = 0;
            string msg = "";
            string securityStamp = "";
            if (!ModelState.IsValid)
            {
                return Json(new
                {
                    Code = 0,
                    Msg = "Tài khoản và mật khẩu ít nhất 3 ký tự",
                });
            }
            if (model.UserName.Trim() == "")
            {
                code = 2;
                msg = "Vui lòng nhập tài khoản";
            }
            else if (model.Password.Trim() == "")
            {
                code = 3;
                msg = "Vui lòng nhập mật khẩu";
            }
            DataTable dt = clsData.getDataTable("sp_User_Select_Stamp", model.UserName);
            if (dt.Rows.Count != 0)
            {
                securityStamp = dt.Rows[0]["Stamp"].ToString();
            }

            string pwdSHA = clsSHA256.ComputeSha256Hash(securityStamp + model.Password);
            try
            {
                DataSet dsResult = clsData.getDataSet("sp_UserLogin", model.UserName, pwdSHA);
                DataTable dtAccount = dsResult.Tables[0];
                if (dtAccount.Rows.Count != 0)
                {
                    Session.Timeout = 30;
                    Session["USER_ID"] = dtAccount.Rows[0]["UserId"].ToString();
                    Session["USER_ACCOUNT"] = model.UserName;
                    Session["USER_FULLNAME"] = dtAccount.Rows[0]["UserFullName"].ToString();
                    byte systemRight = Convert.ToByte(dtAccount.Rows[0]["IsAdmin"]);
                    Session["IS_ADMIN"] = systemRight == 1 ? true : false;
                    code = 1;
                    msg = "Đăng nhập thành công";
                }
                else
                {
                    code = 4;
                    msg = "Đăng nhập thất bại";
                }
            }
            catch (Exception ex)
            {
                code = 5;
                msg = ex.Message;
            }

            return Json(new
            {
                Code = code,
                Msg = msg
            });
        }

        public ActionResult LogOut()
        {
            Session["USER_ID"] = null;
            Session["USER_ACCOUNT"] = null;
            Session["USER_FULLNAME"] = null;
            Session["IS_ADMIN"] = null;
            Session["USER_ROLE"] = null;
            return Redirect("/");
        }

        [HttpPost]
        public void Live()
        {
            Session["Live"] = "X";
        }
    }
}