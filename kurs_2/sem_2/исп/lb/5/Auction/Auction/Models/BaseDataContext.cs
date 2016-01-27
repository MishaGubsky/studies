using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace Auction.Models
{
    public class BaseDataContext:DbContext
    {
         public DbSet<Lot> Lots { get; set; }
         public DbSet<Perchase> Perchases { get; set; }
         public DbSet<User> Users { get; set; } 

    }
}