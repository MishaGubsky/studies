using Auction.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Auction.Controllers
{
    public class AdminController : Controller
    {
        // GET: Admin
        public ActionResult Index()
        {
            return View();
        }
        [HttpGet]
        public ActionResult ViewListPerchases()
        {
            using (var db = new BaseDataContext())
            {
                IEnumerable<Perchase> Perchases = db.Perchases.ToArray(); 
                ViewBag.Perchases = Perchases;
            }
            return View();
        }

        [HttpGet]
        public ActionResult ViewListUsers()
        {
             using (var db = new BaseDataContext())
            {
                IEnumerable<User> Users = db.Users.ToArray();
                ViewBag.Users = Users;
            }
            return View();
        }

        [HttpGet]
        public ActionResult DeletePerchase(int id)
        {
            using (var db = new BaseDataContext())
            {
                Perchase l = db.Perchases.Find(id);
                if (l == null)
                {
                    return HttpNotFound();
                }
                return View(l);
            }

        }
        [HttpPost, ActionName("DeletePerchase")]
        public void DeleteConfirmed(int id)
        {
            using (var db = new BaseDataContext())
            {
                Perchase l = db.Perchases.Find(id);
                if (l != null)
                {
                    db.Perchases.Remove(l);
                    db.SaveChanges();
                }
            }
            Response.Redirect("~/Admin/ViewListPerchases");
            //return RedirectToRoute(new { controller = "Admin", action = "ViewList" });
        }


        public ActionResult GetUser(int id)
        {
            using (var db = new BaseDataContext())
            {
                User us = db.Users.FirstOrDefault(b => b.Id == id);
                if (us == null)
                    return HttpNotFound();
                return View(us);
            };

        }


        [HttpGet]
        public ActionResult DeleteUser(int id)
        {
            using (var db = new BaseDataContext())
            {
                User l = db.Users.Find(id);
                if (l == null)
                {
                    return HttpNotFound();
                }
                return View(l);
            }
        }
        [HttpPost, ActionName("DeleteUser")]
        public void DeleteConfirmed1(int id)
        {
            using (var db = new BaseDataContext())
            {
                User l = db.Users.Find(id);
                if (l != null)
                {
                    db.Users.Remove(l);
                    db.SaveChanges();
                }
            }
            Response.Redirect("~/Admin/ViewListUsers");
            //return RedirectToRoute(new { controller = "Admin", action = "ViewList" });
        }
    }
}