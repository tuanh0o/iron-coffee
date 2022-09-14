using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;

namespace QLBH_IRON.Utils
{
    public class clsGlobal
    {
        public static string EmployeeId
        {
            get
            {
                //return HttpContext.Current.Session["USER_ID"].ToString();
                return "ed61aa86-c7ac-4829-bccf-c721535142ef";
            }
        }

        public static int DefaultRows
        {
            get
            {
                return Convert.ToInt32(ConfigurationManager.AppSettings["DefaultRows"].ToString());
            }
        }

        public static string UserAccount
        {
            get
            {
                return HttpContext.Current.Session["USER_ACCOUNT"].ToString();
            }
        }

        public static string UserFullName
        {
            get
            {
                return HttpContext.Current.Session["USER_FULLNAME"].ToString();
            }
        }

        public static string UserRole
        {
            get
            {
                return HttpContext.Current.Session["USER_ROLE"].ToString();
            }
        }

    }
}