using MvcApplication2.Models.Technics;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace MvcApplication2.Models.Technics
{
    public class TechniqueDbInitializer:DropCreateDatabaseAlways<TechniqueContext>
    {
        protected override void Seed(TechniqueContext db)
        {
            db.Technique.Add(new Technique
            {
                 Name = "Стиральная Машина", Year = "2012", Price = 220
            });
            db.Technique.Add(new Technique
            {
                Name = "Мобильный телефон", Year = "2013", Price = 80
            });
            db.Technique.Add(new Technique
            {
                Name = "Пароварка", Year = "2014", Price = 150
            });

            base.Seed(db);
        }
    }
}