using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace QLBH_IRON.Models
{
    public class LoginModel
    {
        [MinLength(3)]
        [MaxLength(70)]
        public string UserName { get; set; }

        [MinLength(3)]
        [MaxLength(70)]
        public string Password { get; set; }
    }
}