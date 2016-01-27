using Auction.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace Auction.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    public class WebApiController : ApiController
    {
        public IEnumerable<Perchase> GetAllPerchases()
        {
            using (var db = new BaseDataContext())
            {
                IEnumerable<Perchase> Perchases = db.Perchases.ToArray();
                return Perchases;
            }
        }

        public Perchase GetPerchase(int id)
        {
            using (var db = new BaseDataContext())
            {
                return db.Perchases.FirstOrDefault(b => b.Id == id);
            }
        }

        /*public User GetUser(int id)
        {
            using (var db = new BaseDataContext())
            {
                return db.Users.FirstOrDefault(b => b.Id == id);
            }
        }

        public Lot GetLot(int id)
        {
            using (var db = new BaseDataContext())
            {
                return db.Lots.FirstOrDefault(b => b.Id == id);
            }
        }*/

        public void DeletePerchase(int id)
        {
            using (var db = new BaseDataContext())
            {
                var p = db.Perchases.First(b => b.Id == id);
                db.Perchases.Remove(p);
                db.SaveChanges();
            }
        }
    }
}
