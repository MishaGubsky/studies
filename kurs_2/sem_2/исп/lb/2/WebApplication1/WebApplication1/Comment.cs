using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace WebApplication1
{
    public class Comment
    {
        public string StrComment        {get; set;}
        public string NameUser
        {
            get;
            set;
        }
    }
}