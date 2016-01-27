using Auction.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Auction.Controllers
{
    public class AccountController : Controller
    {
        // GET: Account
        public ActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public void Login(string username, string password)
        {
            using (var db = new BaseDataContext())
            {
                User us = db.Users.FirstOrDefault(b => b.Login == username);
                if (us.Pass == password)
                {
                    Response.Cookies["UserId"].Value = Convert.ToString(us.Id);
                    Response.Cookies["UserId"].Expires = DateTime.Now.AddDays(1);
                    Response.Cookies["UserName"].Value = Convert.ToString(us.Name);
                    Response.Cookies["UserName"].Expires = DateTime.Now.AddDays(1);
                    Response.Cookies["UserRole"].Value = Convert.ToString(us.Role);
                    Response.Cookies["UserRole"].Expires = DateTime.Now.AddDays(1);
                    
                    ViewBag.UserAuth = true;
                    if (us.Role == 1)
                    {
                        ViewBag.Admin = true;
                        Response.Redirect("/");
                    }
                    else
                    {
                        ViewBag.Admin = false;
                        Response.Redirect("/");
                    }
                }
                else
                {
                    ModelState.AddModelError("", "Некорректное имя пользователя или пароль");
                }
            }
        }
        public ActionResult Registration()
        {
            return View();
        }
        [HttpPost]
        public void Registration(User us)
        {
            using (var db = new BaseDataContext())
            {
                var Log = db.Users.FirstOrDefault(b => b.Login == us.Login);
                if (Log == null)
                {
                    ViewBag.UserAuth = true;
                    us.Role = 0;
                    db.Users.Add(us);
                    db.SaveChanges();
                    Response.Cookies["UserId"].Value = Convert.ToString(us.Id);
                    Response.Cookies["UserId"].Expires = DateTime.Now.AddDays(1);
                    Response.Cookies["UserName"].Value = Convert.ToString(us.Name);
                    Response.Cookies["UserName"].Expires = DateTime.Now.AddDays(1);
                    Response.Cookies["UserRole"].Value = Convert.ToString(us.Role);
                    Response.Cookies["UserRole"].Expires = DateTime.Now.AddDays(1);
                    Response.Redirect("/");
                }else
                {
                    ModelState.AddModelError("", "Логин уже занят");
                    //return View();
                }
            }
            
        }
        public void LogOut()
        {
            if(Request.Cookies["UserId"]!=null)
            {
                Response.Cookies["UserId"].Expires = DateTime.Now.AddDays(-1);
            }
            if (Request.Cookies["UserName"] != null)
            {
                Response.Cookies["UserName"].Expires = DateTime.Now.AddDays(-1);
            }
            if (Request.Cookies["UserRole"] != null)
            {
                Response.Cookies["UserRole"].Expires = DateTime.Now.AddDays(-1);
            }
            Response.Redirect("/");
        }

    }
}