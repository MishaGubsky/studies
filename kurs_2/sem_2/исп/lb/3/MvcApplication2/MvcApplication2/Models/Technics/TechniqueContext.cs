using MvcApplication2.Models.Persons;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace MvcApplication2.Models.Technics
{
    public class TechniqueContext:DbContext
    {
        public DbSet<Technique> Technique
        {
            get;
            set;
        }
        public DbSet<Purchase> Purchases
        {
            get;
            set;
        }
    }
}