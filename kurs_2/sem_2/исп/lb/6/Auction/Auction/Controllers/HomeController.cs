using Auction.Filters;
using Auction.Models.Authentication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Auction.Controllers
{
    public class HomeController : Controller
    {
        //
        // GET: /Home/
        public ActionResult Index()
        {
            ViewBag.UserSignIn = false;
            if (Request.Cookies["UserId"] != null)
            {
                ViewBag.UserSignIn = true;
            }
            ViewBag.Admin = false;
            try
            {
                if (Request.Cookies["UserRole"].Value == "1")
                {
                    ViewBag.Admin = true;
                }
            }
            catch
            {
                ViewBag.Admin = false;
            }
            return View();
        }
 
     /*   public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";
 
            return View();
        }
 
        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";
 
            return View();     */

    }
}
