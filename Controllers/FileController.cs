using QLBH_IRON.DAL;
using QLBH_IRON.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QLBH_IRON.Controllers
{
    public class FileController : Controller
    {
        public string UploadImage(HttpPostedFileBase file)
        {
            string FileName = file.FileName;
            int fileSize = file.ContentLength;
            int maxAvatarSize = 1048576;
            if (fileSize > maxAvatarSize)
            {
                return "Vui lòng chọn ảnh có kích thước nhỏ hơn";
            }
            string fileExtension = Path.GetExtension(FileName);
            Guid id = Guid.NewGuid();
            string year = DateTime.Now.Year.ToString();
            string month = DateTime.Now.Month.ToString();
            string pathFolder = $"{HttpContext.Server.MapPath("~/Images/Product")}\\{year}\\{month}";
            if (!Directory.Exists(pathFolder))
            {
                Directory.CreateDirectory(pathFolder);
            }
            string path = $"{pathFolder}\\{id + fileExtension}";
            file.SaveAs(path);
            string returnPath = $"/Images/Product/{year}/{month}/{id}{fileExtension}";
            return returnPath;
        }

        public string UploadLogo(HttpPostedFileBase file)
        {
            Guid id = Guid.NewGuid();
            string pathFolder = $"{HttpContext.Server.MapPath("~/Images/Logo")}";
            if (!Directory.Exists(pathFolder))
            {
                Directory.CreateDirectory(pathFolder);
            }
            string FileName = file.FileName;
            string fileExtension = Path.GetExtension(FileName);
            string path = $"{pathFolder}\\{id + fileExtension}";
            string returnPath = "/Images/Logo/" + id + fileExtension;
            try
            {
                file.SaveAs(path);
                DataTable dtResult = clsData.getDataTable("sp_Logo_Update", returnPath);
                return returnPath;
            }
            catch (Exception)
            {
                return "";
            }
        }
    }
}