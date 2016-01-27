using MvcApplication2.Models.Persons;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace MvcApplication2.Models.Books
{
    public class BookContext:DbContext
    {
        public DbSet<Book> Books
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