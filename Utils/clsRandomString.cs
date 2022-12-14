using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Text;

namespace QLBH_IRON.Utils
{
    public class clsRandomString
    {
        private static char[] _base62chars =
        "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        .ToCharArray();

        private static Random _random = new Random();

        public static string GetBase62(int length)
        {
            var sb = new StringBuilder(length);

            for (int i = 0; i < length; i++)
                sb.Append(_base62chars[_random.Next(62)]);

            return sb.ToString();
        }
    }
}