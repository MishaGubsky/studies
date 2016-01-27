using MvcApplication2.Models.Persons;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MvcApplication2.Models;
using MvcApplication2.Models.Books;

namespace MvcApplication2.Controllers
{
    public class BooksController : Controller
    {
        //
        // GET: /Items/
        public BookContext dbBooks=new BookContext();

        [HttpGet]
        public ActionResult Buy(int id)
        {
            ViewBag.BookId = id;
            return View();
        }

        [HttpPost]
        public string Buy(Purchase purchase)
        {
            purchase.Date = DateTime.Now;
            purchase.Subject = "Books";
            // добавляем информацию о покупке в базу данных
            Repository.dbBooks.Purchases.Add(purchase);
            // сохраняем в бд все изменения
            Repository.dbBooks.SaveChanges();
            return "Спасибо, за покупку!";
        }

        [HttpPost]
        public ActionResult Create(Book book)
        {
            Repository.dbBooks.Entry(book).State = EntityState.Added;
            Repository.dbBooks.SaveChanges();

            return RedirectToAction("Index");
        }



        /*[HttpPost]
        public ActionResult EditBook(Book book)
        {
            Repository.dbBooks.Books.Add(book).Stat = EntityState.Modified;
            db.SaveChanges();
            return RedirectToAction("Index");
        } 

        [HttpPost]
        public ActionResult AddBook(Book book)
        {
            Repository.dbBooks.Books.Entry(book).State = EntityState.Modified;
            Repository.dbBooks.Books.SaveChanges();
            return RedirectToAction("Index");
        }     */

        [HttpPost]
        public ActionResult Books(Book _book)
        {
            // получаем из бд все объекты Book
            Repository.dbBooks.Books.Add(_book);
            // передаем все полученный объекты в динамическое свойство Books в ViewBag
            ViewBag.Books = _book;

            return View();
        }



        public ActionResult Books()    
        {
            // получаем из бд все объекты Book

            IEnumerable<Book> books = Repository.dbBooks.Books;
            // передаем все полученный объекты в динамическое свойство Books в ViewBag
            ViewBag.Books = books;

            return View();
        }

    }
}
