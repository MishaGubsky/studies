using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Auction.Models;

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
            }
            return View("ViewList");
        }
    }
}