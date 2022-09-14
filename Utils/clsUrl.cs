using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace QLBH_IRON.Utils
{
    public class clsUrl
    {
        public static string Convert(string strInput)
        {
            StringBuilder result = new StringBuilder("");
            string[] VietnameseSigns = new string[]
                {
                "aAeEoOuUiIdDyY",
                "áàạảãâấầậẩẫăắằặẳẵ",
                "ÁÀẠẢÃÂẤẦẬẨẪĂẮẰẶẲẴ",
                "éèẹẻẽêếềệểễ",
                "ÉÈẸẺẼÊẾỀỆỂỄ",
                "óòọỏõôốồộổỗơớờợởỡ",
                "ÓÒỌỎÕÔỐỒỘỔỖƠỚỜỢỞỠ",
                "úùụủũưứừựửữ",
                "ÚÙỤỦŨƯỨỪỰỬỮ",
                "íìịỉĩ",
                "ÍÌỊỈĨ",
                "đ",
                "Đ",
                "ýỳỵỷỹ",
                "ÝỲỴỶỸ"
                };

            for (int i = 1; i < VietnameseSigns.Length; i++) //Bỏ dấu tiếng việt
            {
                for (int j = 0; j < VietnameseSigns[i].Length; j++)
                {
                    strInput = strInput.Replace(VietnameseSigns[i][j], VietnameseSigns[0][i - 1]);
                }
            }

            for (int i = 0; i < strInput.Length; i++) //Thay ký tự đặc biệt bằng dấu -
            {
                if (!char.IsLetter(strInput[i]) && !char.IsDigit(strInput[i]))
                {
                    if (result.ToString() != string.Empty)
                    {
                        if (result[result.Length - 1].ToString() != "-")
                        {
                            result.Append("-");
                        }
                    }
                }
                else
                {
                    result.Append(strInput[i]);
                }
            }

            if (result.ToString() != string.Empty) //Loại bỏ ký tự - cuối chuỗi
            {
                int l = result.Length;
                if (result[l - 1].ToString() == "-")
                {
                    result.Remove(l - 1, 1);
                }
            }

            return result.ToString().ToLower();
        }
    }
}