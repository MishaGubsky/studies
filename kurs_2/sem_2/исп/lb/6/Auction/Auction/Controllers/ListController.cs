using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Auction.Models;
using Auction.Filters;
using Auction.Models.Authentication;

namespace Auction.Controllers
{
    public class ListController : Controller
    {
        public ActionResult Add()
        {
            return RedirectToRoute(new {controller="Lot", action="AddLot" });
        }
        [HttpGet]
        public ActionResult ViewList()
        {
            using (var dbBooks = new BaseDataContext())
            {
                IEnumerable<Lot> Lots = dbBooks.Lots.ToArray();
                ViewBag.Lots = Lots;
                
                        ViewBag.Admin = false;
                try
                {
                    if (Request.Cookies["UserRole"].Value == "1")
                        ViewBag.Admin = true;
                }catch                 { }
            }
            return View("ViewList");
        }
    }
}