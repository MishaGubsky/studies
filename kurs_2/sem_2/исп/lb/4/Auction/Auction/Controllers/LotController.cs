using Auction.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Auction.Controllers
{
    public class LotController : Controller
    {
        //
        // GET: /Lot/

        [HttpGet]
        public ActionResult AddLot()
        {
            return View();
        }
        [HttpPost]
        public ActionResult AddLot(Lot _lot)
        {
            using (var db = new BaseDataContext())
            {
                if (_lot.ExpirationDateTime == null)
                {
                    DateTime dt = DateTime.Today;
                    dt.AddDays(5);
                    _lot.ExpirationDateTime = dt;
                }               
                db.Lots.Add(_lot);
                db.SaveChanges();
            }
            return RedirectToRoute(new {controller="List",action="ViewList" });//!!!!!!!!!!!!!!!!
        }
        /// <summary>
        /// ///////////////////////////////////////////////////
        /// </summary>
        /// <param name="id"></param>
        /// <returns
        /// ></returns>
        [HttpGet]
        public ActionResult DeleteLot(int id)
        {
            using (var db = new BaseDataContext())
            {
                Lot l = db.Lots.Find(id);
                if (l == null)
                {
                    return HttpNotFound();
                } 
                return View(l);
            }
           
        }
        [HttpPost, ActionName("DeleteLot")]
        public ActionResult DeleteConfirmed(int id)
        {
            using (var db = new BaseDataContext())
            {
                Lot l = db.Lots.Find(id);
                if (l != null)
                {
                    db.Lots.Remove(l);
                    db.SaveChanges();
                }
            }

            return RedirectToRoute(new { controller = "List", action = "ViewList" });
        }

        [HttpGet]
        public ActionResult EditLot(int? id)
        {
            if (id == null)
            {
                return HttpNotFound();
            }
            using (var db = new BaseDataContext())
            {
                Lot _lot = db.Lots.Find(id);
                if (_lot != null)
                {
                    return View(_lot);
                }
            }
            return HttpNotFound();
        }
        [HttpPost]
        public ActionResult EditLot(Lot _lot)
        {
            using (var db = new BaseDataContext())
            {
                db.Entry(_lot).State = EntityState.Modified;
                db.SaveChanges();
            }
            return RedirectToRoute(new { controller = "List", action = "ViewList" });
            
        }
        public ActionResult GetLot(int id)
        {
            using (var db = new BaseDataContext())
            {
                //IEnumerable<Lot> _Lots = db.Lots.ToArray();
                Lot lot = db.Lots.FirstOrDefault(b => b.Id == id);
                if (lot == null)
                    return HttpNotFound();
                return View(lot);
            };
        }
    }
}
