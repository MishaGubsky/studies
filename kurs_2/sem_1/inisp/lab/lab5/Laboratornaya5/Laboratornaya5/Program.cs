using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MyPlugin;

namespace Laboratornaya5
{
    internal class Program
    {


        public static void PrintMenu()
        {
            Console.WriteLine("Hello. This is the personal calculator of date.\n");
            Console.WriteLine("It can convert a date and say what day of week was");
            Console.WriteLine("Enter a number:");
            Console.WriteLine("1.to find day of week by Grigorian calendar");
            Console.WriteLine("2.to find day of week by Ulian calendar");

        }

        public static int GetMenu()
        {
            try
            {
                return int.Parse(Console.ReadLine());
            } catch
            {
                Console.WriteLine("error of input");
                return -1;
            }
        }

        public static DateTime GetDate()
        {
            Console.WriteLine("Enter a date in \" year-month-day\" format");
            try
            {
                return DateTime.Parse(Console.ReadLine());
            } catch
            {
                return FormatException();   
            }
        }

        private static DateTime FormatException()
        {
            throw new NotImplementedException();
        }

        



        private static void Main(string[] args)
        {
            var dir = ConfigurationManager.AppSettings["ModuleDirectory"];
            var LPlugins=new List<Plugin>();
            for(var i = 0; i < System.IO.Directory.GetFiles(dir, "*.dll").Length; i++)
            {
                var f = System.IO.Directory.GetFiles(dir, "*.dll")[i];
                var a = System.Reflection.Assembly.LoadFile(f);
                foreach(var t in a.GetTypes())
                {
                    if(t.IsAbstract || t.IsInterface)
                        continue;
                    if(!typeof(Plugin).IsAssignableFrom(t))
                        continue;
                    var p = (Plugin)Activator.CreateInstance(t);
                    LPlugins.Add(p);
                }
            }
            PrintMenu();
            int menu=GetMenu();
            if( menu!= -1)
            {
                var time= GetDate();
                string s=LPlugins[menu-1].CalculateDay(time.Day,time.Month,time.Year);
                Console.WriteLine("You day is {0}",s);                                                   
            }

            Console.ReadLine();

        }               
    }
}
