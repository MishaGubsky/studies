using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Auction.Models
{
    public class User
    {
        public int PerchaserId { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public int LotId { get; set; }

        public string Login { get; set; }
        public string Pass { get; set; }
    }
}