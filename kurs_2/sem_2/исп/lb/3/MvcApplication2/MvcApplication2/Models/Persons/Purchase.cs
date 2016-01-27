using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MvcApplication2.Models.Persons
{
    public class Purchase
    {
        public int PurchaseId
        {
            get;
            set;
        }
        // имя и фамилия покупателя
        public int PersonId
        {
            get;
            set;
        }
        // адрес покупателя
        public string Address
        {
            get;
            set;
        }
        // ID книги
        public string Subject
        {
            get;
            set;
        }

        public int Id
        {
            get;
            set;
        }
        // дата покупки
        public DateTime Date
        {
            get;
            set;
        }
    }
}