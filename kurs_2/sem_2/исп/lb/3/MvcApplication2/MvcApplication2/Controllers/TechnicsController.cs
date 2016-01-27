using MvcApplication2.Models;
using MvcApplication2.Models.Persons;
using MvcApplication2.Models.Technics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MvcApplication2.Controllers
{
    public class TechnicsController : Controller
    {
        //
        // GET: /Technique/
        public TechniqueContext dbTechnics=new TechniqueContext();

        [HttpGet]
        public ActionResult Buy(int id)
        {
            ViewBag.TechniqueId = id;
            return View();
        }
        [HttpPost]
        public string Buy(Purchase purchase)
        {
            purchase.Date = DateTime.Now;
            purchase.Subject = "Technics";
            // добавляем информацию о покупке в базу данных
            dbTechnics.Purchases.Add(purchase);
            // сохраняем в бд все изменения
            dbTechnics.SaveChanges();
            return "Спасибо за покупку!";
        }


        public ActionResult Technics()
        {
            IEnumerable<Technique> Technics = dbTechnics.Technique;
            ViewBag.Technics = Technics;

            return View();
        }

    }
}
