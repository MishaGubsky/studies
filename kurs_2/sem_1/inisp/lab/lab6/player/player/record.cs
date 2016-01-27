using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace player
{
    public class record
    {
        public TimeSpan duration;//время песни
        public string name;                                
        public string artist;
        public string about;
        public record(string _artist,string _name,TimeSpan _duration)
        {
            duration = _duration;
            name = _name;
            artist = _artist;
            about= "no information avaliable";
        }
        public record(string _artist, string _name, TimeSpan _duration, string _about)
        {
            duration = _duration;
            name = _name;
            artist = _artist;
            about= _about;
        }
       
        public void WriteToConsole()
        {
            Console.WriteLine("::" + duration.Minutes.ToString() + ':' 
                + duration.Seconds.ToString() + "::" + artist + " - " + name + "::");
        }
        public void WriteToConsoleAndWait()
        {
            System.Diagnostics.Stopwatch stopWatch=new System.Diagnostics.Stopwatch();
            int p = (int)duration.TotalSeconds+1;
            var cl = new ConsoleWriter();
            int youoffset = YouNumberInQueue();
            while(p!=-1)
            {
                Console.SetCursorPosition(0,youoffset+cl.GetCountStringsFromConsole());
                Console.WriteLine("::" + ((int)((duration.TotalSeconds - p) / 60)).ToString() + ":" + ((duration.TotalSeconds - p) % 60).ToString()
                    + "::" + duration.Minutes.ToString() + ':' + duration.Seconds.ToString()
                    + "::" + artist + " - " + name + "::" + "playing now");    
                Thread.Sleep(990);  
                stopWatch.Stop();
                p--;
            }
            var cl1 = new WorkWithThreads();
            cl1.AbortRecord(this);
                    Console.SetCursorPosition(0, youoffset + cl.GetCountStringsFromConsole());

                    string s="::" + ((int)((duration.TotalSeconds - p) / 60)).ToString() + ":" + ((duration.TotalSeconds - p) % 60).ToString()
                            + "::" + duration.Minutes.ToString() + ':' + duration.Seconds.ToString()
                            + "::" + artist + " - " + name + "::" + "playing now";
                    string news = "";
                    for(int i = 0;i <= s.Length;i++)
                    {
                        news = news + ' ';
                    }
                    Console.WriteLine(news);
           Console.SetCursorPosition(0, cl.GetCountStringsFromConsole()-2);                                                                                                                       
        }

        private int YouNumberInQueue()
        {
                    var t = new ConsoleWriter();
                    int c = 0;
                    var clas = new WorkWithThreads();
                    if(clas.GetExectionThreads() != null)
                    {
                        ElementOfThread p=null;
                        foreach(var temp in clas.GetExectionThreads())
                        {
                            if(temp.GetName() == this)
                            {
                                p = temp;
                                c--;
                            }
                            c++;
                        }
                        return c;
                    } else
                        return -1; 
        }
        public void WriteToConsole(TimeSpan time)
        {
            Console.WriteLine("::" + artist + " - " + name + "::"
                +time.Minutes.ToString()+':'+time.Seconds.ToString());
        }
        public void WriteAbout()
        {
            Console.WriteLine(about);
        }
    }
}
