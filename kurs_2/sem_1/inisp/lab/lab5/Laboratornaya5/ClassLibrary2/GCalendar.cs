using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MyPlugin;

namespace GregorianCalendar
{
    [Name("GregorianCalendar")]
    
    public class GCalendar: Plugin
    {
        public string CalculateDay(int day, int month, int year)
        {
            int a = (14 - month) / 12;
            int y = year - a;
            int m = month + 12 * a - 2;
            int dayofweek = (7000 + (day + y + (int)y / 4 - (int)y / 100 + (int)y / 400 + (int)31 * m / 12)) % 7;

            return GDayOfWeek(dayofweek);
        }

        private string GDayOfWeek(int day)
        {
            switch(day)
            {
                case 0:
                return "sunday";
                case 1:
                return "monday";
                case 2:
                return "tuesday";
                case 3:
                return "wednesday";
                case 4:
                return "thursday";
                case 5:
                return "friday";
                case 6:
                return "saturday";
                default:
                return "error";
            }
        }
    }
}