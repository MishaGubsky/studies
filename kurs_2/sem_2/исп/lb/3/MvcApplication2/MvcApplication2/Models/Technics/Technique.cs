using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MvcApplication2.Models.Technics
{
    public class Technique
    {    
        public int Id
        {
            get;
            set;
        }
        public string Name
        {
            get;
            set;
        }
        public string Year
        {
            get;
            set;
        }
        public int Price
        {
            get;
            set;
        }
    }
}