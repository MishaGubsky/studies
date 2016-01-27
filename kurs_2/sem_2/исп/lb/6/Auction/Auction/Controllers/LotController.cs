using Auction.Filters;
using Auction.Models;
using Auction.Models.Authentication;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Validation;
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
        [Authorize (Roles="admin")]
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
        [Authorize(Roles = "1")]
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
        [Authorize(Roles = "1")]
        public ActionResult EditLot(Lot _lot)
        {
            using (var db = new BaseDataContext())
            {
                db.Entry(_lot).State = EntityState.Modified;
                try
                {

                    db.SaveChanges();

                    return RedirectToRoute(new { controller = "List", action = "ViewList" });
                }
                catch (DbEntityValidationException ex)
                {
                    foreach (DbEntityValidationResult validationError in ex.EntityValidationErrors)
                    {
                        Response.Write("Object: " + validationError.Entry.Entity.ToString());

                        foreach (DbValidationError err in validationError.ValidationErrors)
                        {
                            Response.Write("                                        ");
                            Response.Write(err.ErrorMessage + "");
                        }
                    }

                };
                return View();
            }
            
        }
        public ActionResult GetLot(int id)
        {
            using (var db = new BaseDataContext())
            {
                Lot lot = db.Lots.FirstOrDefault(b => b.Id == id);
                if (lot == null)
                    return HttpNotFound();
                return View(lot);
            };
        
        }
        int _id;

        [HttpGet]
        public ActionResult Raise(int id)
        {
            ViewBag.Id= id;
            return View();
        }
        [HttpPost]
        public ActionResult Raise(string price, int id)
        {
            using (var db = new BaseDataContext())
            {
                int newPrice = int.Parse(price);
                Lot lot = db.Lots.FirstOrDefault(b => b.Id == id);
                if (lot == null)
                    return HttpNotFound();
                if (lot.Price < newPrice)
                {
                    Perchase _perchase = db.Perchases.FirstOrDefault(b => b.LotId == lot.Id);
                    if(_perchase!=null)
                    {
                        _perchase.UserId = int.Parse(Request.Cookies["UserId"].Value);
                        db.Entry(_perchase).State = EntityState.Modified;
                    }else
                    {
                        _perchase = new Perchase();
                        _perchase.LotId = lot.Id;
                        _perchase.UserId = int.Parse(Request.Cookies["UserId"].Value);
                        db.Perchases.Add(_perchase);
                    }
                    db.SaveChanges();

                    lot.Price = int.Parse(price);
                    db.Entry(lot).State = EntityState.Modified;
                    try
                    {
                        db.SaveChanges();
                        return RedirectToRoute(new { controller = "List", action = "ViewList" });
                    }
                    catch (DbEntityValidationException ex)
                    {
                        foreach (DbEntityValidationResult validationError in ex.EntityValidationErrors)
                        {
                            Response.Write("Object: " + validationError.Entry.Entity.ToString());

                            foreach (DbValidationError err in validationError.ValidationErrors)
                            {
                                Response.Write("                                        ");
                                Response.Write(err.ErrorMessage + "");
                            }
                        }

                    };
                }
                Response.Write("Цена слишком мала!");
                return View();

                
            }
                //return RedirectToRoute(new { controller = "List", action = "ViewList" });
        }

    }
}
