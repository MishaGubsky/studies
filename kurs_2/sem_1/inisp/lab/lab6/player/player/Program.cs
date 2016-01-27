using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace player
{
    class Program
    {
        static void Main(string[] args)
        {
            var cl = new WorkWithThreads();
            //cl.PlayingRecords = new Queue<ElementOfThread>();
            /*record rec=new record("Bob Marley","Woman no cry",new TimeSpan(0,0,05));
            record rec1= new record("Evanescence", "Imaginary", new TimeSpan(0, 0, 17));
            record rec2 = new record("Evanescence", "Snow White Queen", new TimeSpan(0, 0, 30));
            WorkWithXml.ListOfAllComposition.Add(rec);
            WorkWithXml.ListOfAllComposition.Add(rec1);
            WorkWithXml.ListOfAllComposition.Add(rec2);
           // WorkWithXml.WriteToXml();*/
            //WorkWithXml.ReadFromXml();
            var cl1 = new ConsoleWriter();
            cl1.ProcessingMenu();
        }
    }
}
