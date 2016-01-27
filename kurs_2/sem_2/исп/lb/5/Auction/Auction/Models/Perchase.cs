using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Auction.Models
{
    public class Perchase
    {
        public int Id { get; set; }
        public int LotId { get; set; }
        public int UserId { get; set; }
    }
}