using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Data;
using System.Data.SqlClient;
using QLBH_IRON.Utils;

namespace QLBH_IRON.DAL
{
    public class clsData
    {
        public static string getJson(string spName, params object[] param)
        {
            try
            {
                return clsJson.DataTableToJSONWithJavaScriptSerializer(clsConnection.getDataTable(spName, param));
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public static string executeCommand(string spName, params object[] param)
        {
            try
            {
                clsConnection.excuteQuery(spName, param);
                return "1";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public static DataTable getDataTable(string spName, params object[] param)
        {
            return clsConnection.getDataTable(spName, param);
        }

        public static void fillDataTable(ref DataTable dtTable, string spName, params object[] param)
        {
            clsConnection.fillDataTable(ref dtTable, spName, param);
        }

        public static DataSet getDataSet(string spName, params object[] param)
        {
            return clsConnection.getDataSet(spName, param);
        }

    }
}