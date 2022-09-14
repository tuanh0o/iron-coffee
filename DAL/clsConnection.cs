using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace QLBH_IRON.DAL
{
    public class clsConnection
    {
        private static string getConnectionString()
        {
            string server = ConfigurationManager.AppSettings["server"];
            string database = ConfigurationManager.AppSettings["database"];
            string user = ConfigurationManager.AppSettings["user"];
            string pwd = ConfigurationManager.AppSettings["pwd"];
            SqlConnectionStringBuilder strCon = new SqlConnectionStringBuilder();
            strCon.DataSource = server;
            strCon.InitialCatalog = database;
            strCon.UserID = user;
            strCon.Password = pwd;
            return strCon.ConnectionString;
        }

        public static int excuteQuery(string spName, params object[] param)
        {
            SqlConnection sqlCn = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            try
            {
                sqlCn.ConnectionString = getConnectionString();
                if (sqlCn.State != ConnectionState.Open) { sqlCn.Open(); }
                cmd.Connection = sqlCn;
                cmd.CommandText = spName;
                cmd.CommandType = CommandType.StoredProcedure;
                if (param.Count() != 0)
                {
                    cmd.Parameters.Clear();
                    cmd.Parameters.AddRange(getParameter(spName, param));
                }
                return cmd.ExecuteNonQuery();
            }
            catch (Exception ex) { throw ex; }
            finally
            {
                if (sqlCn.State != ConnectionState.Closed) { sqlCn.Close(); }
                cmd.Dispose();
            }
        }

        public static void fillDataTable(ref DataTable dtTable, string spName, params object[] param)
        {
            SqlConnection sqlCn = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            try
            {
                sqlCn.ConnectionString = getConnectionString();
                if (sqlCn.State != ConnectionState.Open) { sqlCn.Open(); }
                cmd.Connection = sqlCn;
                cmd.CommandText = spName;
                cmd.CommandType = CommandType.StoredProcedure;
                if (param.Count() != 0)
                {
                    cmd.Parameters.Clear();
                    cmd.Parameters.AddRange(getParameter(spName, param));
                }
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                da.Fill(dtTable);
            }
            catch (Exception ex) { throw ex; }
            finally
            {
                if (sqlCn.State != ConnectionState.Closed) { sqlCn.Close(); }
                cmd.Dispose();
            }
        }

        public static DataTable getDataTable(string spName, params object[] param)
        {
            SqlConnection sqlCn = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            DataTable dt = new DataTable();
            try
            {
                sqlCn.ConnectionString = getConnectionString();
                if (sqlCn.State != ConnectionState.Open) { sqlCn.Open(); }
                cmd.Connection = sqlCn;
                cmd.CommandText = spName;
                cmd.CommandType = CommandType.StoredProcedure;
                if (param.Count() != 0)
                {
                    cmd.Parameters.Clear();
                    cmd.Parameters.AddRange(getParameter(spName, param));
                }
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                da.Fill(dt);
                return dt;
            }
            catch (Exception ex) { throw ex; }
            finally
            {
                if (sqlCn.State != ConnectionState.Closed) { sqlCn.Close(); }
                cmd.Dispose();
            }
        }

        public static DataSet getDataSet(string spName, params object[] param)
        {
            SqlConnection sqlCn = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            DataSet ds = new DataSet();
            try
            {
                sqlCn.ConnectionString = getConnectionString();
                if (sqlCn.State != ConnectionState.Open) { sqlCn.Open(); }
                cmd.Connection = sqlCn;
                cmd.CommandText = spName;
                cmd.CommandType = CommandType.StoredProcedure;
                if (param.Count() != 0)
                {
                    cmd.Parameters.Clear();
                    cmd.Parameters.AddRange(getParameter(spName, param));
                }
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                da.Fill(ds);
                return ds;
            }
            catch (Exception ex) { throw ex; }
            finally
            {
                if (sqlCn.State != ConnectionState.Closed) { sqlCn.Close(); }
                cmd.Dispose();
            }
        }

        public static SqlDataReader getDataReader(string spName, params object[] param)
        {
            SqlConnection sqlCn = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            SqlDataReader reader = null;
            try
            {
                sqlCn.ConnectionString = getConnectionString();
                if (sqlCn.State != ConnectionState.Open) { sqlCn.Open(); }
                cmd.Connection = sqlCn;
                cmd.CommandText = spName;
                cmd.CommandType = CommandType.StoredProcedure;
                if (param.Count() != 0)
                {
                    cmd.Parameters.Clear();
                    cmd.Parameters.AddRange(getParameter(spName, param));
                }
                reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                return reader;
            }
            catch (Exception ex) { throw ex; }
            finally
            {
                //if (sqlCn.State != ConnectionState.Closed) { sqlCn.Close(); }
                cmd.Dispose();
            }
        }

        private static SqlParameter[] getParameter(string spName, params object[] param)
        {
            SqlConnection sqlCn = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            DataTable dt = new DataTable();
            string sql = "SELECT PARAMETER_NAME FROM INFORMATION_SCHEMA.PARAMETERS WHERE SPECIFIC_NAME = @SPNAME";
            try
            {
                sqlCn.ConnectionString = getConnectionString();
                if (sqlCn.State != ConnectionState.Open) { sqlCn.Open(); }
                cmd.Connection = sqlCn;
                cmd.CommandText = sql;
                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue("@SPNAME", spName);
                cmd.CommandType = CommandType.Text;
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                da.Fill(dt);
                SqlParameter[] par = new SqlParameter[dt.Rows.Count];
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    par[i] = new SqlParameter(dt.Rows[i][0].ToString(), param[i]);
                }
                return par;
            }
            catch (Exception ex) { throw ex; }
            finally
            {
                if (sqlCn.State != ConnectionState.Closed) { sqlCn.Close(); }
                cmd.Dispose();
            }
        }
    }
}