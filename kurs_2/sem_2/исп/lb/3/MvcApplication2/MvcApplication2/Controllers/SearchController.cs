using MvcApplication2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MvcApplication2.Controllers
{
    public class SearchController : Controller
    {
        //
        // GET: /Search/
        private bool Compare(string a, string b)
        {
            int j = 0;
                for (int i= 0; i < a.Length; i++)
                {
                    if (a[i] == b[j])
                    {
                        j++;
                    }
                    else
                    {
                        j = 0;
                    }
                }
            if (j == b.Length)
                return true;
            else
            {
                return false;
            }

        }

        [HttpPost]
        public ActionResult Search(Search SM)
        {
            foreach(var i in Repository.dbBooks.Books)
            {
                if((Compare(i.Name,SM.SearchText)) || (Compare(i.Author,SM.SearchText)))
                    return View( i);
            }

            foreach(var i in Repository.dbTechnics.Technique)
            {
                if((Compare(i.Name, SM.SearchText)) || (Compare(i.Year, SM.SearchText)))
                    return View(i);
            }
            ViewBag.Search = false;
            return View();
        }
        [HttpGet]
        public ActionResult Search()
        {
            ViewBag.Search = null;
            return View();
        }


    }
}
