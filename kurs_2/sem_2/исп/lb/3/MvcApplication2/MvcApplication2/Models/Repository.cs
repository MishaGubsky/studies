using MvcApplication2.Models.Technics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MvcApplication2.Models.Books;

namespace MvcApplication2.Models
{
    public class Repository
    {
        public static Repository Base;
        public static BookContext dbBooks;
        public static TechniqueContext dbTechnics;

        private static void Initialization() 
        {            
            dbBooks = new BookContext();
            dbTechnics = new TechniqueContext();
        }
        static Repository()
        {          
           Initialization();   
        }
    }
}