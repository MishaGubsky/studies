using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MyPlugin;

namespace ClassLibrary3
{
    [Name("UlianCalendar")]
    public class UCalendar:Plugin
    {
        public string CalculateDay(int day, int month, int year)
        {
            int a = (14 - month) / 12;
            int y = year+4800 - a;
            int m = month + 12 * a - 3;
            int dayofweek = (day + 365 * y + (int)y / 4 - (int)y / 100 + (int)y / 400 + (153 * m + 2) / 5 - 32045) % 7;

            return UDayOfWeek(dayofweek);
        }

        private string UDayOfWeek(int day)
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