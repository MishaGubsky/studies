using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace player
{
    public class ConsoleWriter
    {
        static int CountStringsFromConsole;

        public int GetCountStringsFromConsole()
        {
            return CountStringsFromConsole;
        }




        private int Menu()                          
        {
            Console.SetCursorPosition(0, 0);
            CountStringsFromConsole = 7;
            ConsoleCLear();
            string str = "0) Press to quit.\n" +
                         "1) Press to view list of playing records\n" +
                         "2) Press to view playlist\n" +
                         "3) Press to open playlist\n" +
                         "4) Press to save playlist.";                                      
           Console.WriteLine(str);
            try
            {
                int sel=int.Parse(Console.ReadLine());
                return sel;
            }catch
            {
                return  FormatException();
            }
        }
        private int FormatException()
        {
            throw new NotImplementedException();
        }
        public void ProcessingMenu()
        {
            int sel = -1;
            while(sel!=0)
            {
                sel = Menu();
                switch (sel)
                {
                    case 4:
                    Console.Clear();
                    CountStringsFromConsole = 4;
                    if(WorkWithXml.ListOfAllComposition != null)
                    {
                        WorkWithXml.WriteToXml();
                        Console.WriteLine("PlayList is saved successfull\nPress any key to back");
                    } else
                        Console.WriteLine("PlayList is empty\nPress any key to back");
                        Console.ReadLine();
                    break;
                    case 3:
                        Console.Clear();
                        CountStringsFromConsole = 4;
                        WorkWithXml.ReadFromXml();
                        Console.WriteLine("PlayList is opened successfull\nPress any key to back");
                        Console.ReadLine();
                        break;
                    case 2:
                        ProcessingMenuPlayList(WorkWithXml.GetQueue());
                        break;
                    case 1:
                        var cl = new WorkWithThreads();
                        ProcessingMenuPlayList(cl.GetExectionThreads());
                        break; 
                    case 0:                    
                        break;
                    
                }
            }
        }
  /// press 2
        private int MenuPlayList(List<record> list)
        {
            Console.SetCursorPosition(0, 0);
            
            ConsoleCLear();
            if(list != null)
            {   
                CountStringsFromConsole = list.Count()+4;
                Console.WriteLine("0. Back");
                ViewList(list);

                Console.WriteLine("select record or Back");
                try
                {
                    int sel = int.Parse(Console.ReadLine());
                    return sel;
                } catch
                {
                    throw new NotImplementedException();
                }
            } else
            {
                return 0;
            }
        }
        private void ViewList(List<record> list)
        {           
            int cur = 0;
            if(list!=null)    
            foreach(var next in list)
                {
                    cur++;
                    Console.Write(cur.ToString() + ". ");
                    next.WriteToConsole();
                }
           
        }
        public void ProcessingMenuPlayList(List<record> list)
        {
            int sel = -1;
            while(sel != 0)
            {
                
                    sel = MenuPlayList(list);
                    if((sel != 0)&&(list!=null))
                    {
                        int ch = sel;
                        ch--;
                        if(list != null)
                        {
                            record r = null;
                            foreach(var next in list)
                            {
                                if(ch < 1)
                                {
                                    r = next;
                                    break;
                                }
                                ch--;
                            }
                            ProcessingMenuRecord(r);
                        }
                    } else if(list == null)
                        {
                            Console.WriteLine("PlayList is empty\nPress any key to back");
                            Console.ReadLine();
                        }
                } 
                
            }

    






  /// press 1
        private int MenuPlayList(List<ElementOfThread> list)
        {
            Console.SetCursorPosition(0, 0);
            ConsoleCLear();
            if(list != null)
            {      
                CountStringsFromConsole = list.Count + 4;
                Console.WriteLine("0. Back");
                ViewList(list);

                Console.WriteLine("select record or Back");
                try
                {
                    int sel = int.Parse(Console.ReadLine());
                    return sel;
                } catch
                {
                    throw new NotImplementedException();
                }
            } else
            {
                return 0;
            }
        }
        private void ViewList(List<ElementOfThread> list)
        {
            int cur = 0;
            if(list != null)
                foreach(var next in list)
                {
                    cur++;
                    Console.Write(cur.ToString() + ". ");
                    next.GetName().WriteToConsole();
                }
            
        }
        public void ProcessingMenuPlayList(List<ElementOfThread> list)
        {
            int sel = -1;
            while(sel != 0)
            {
                
                    sel = MenuPlayList(list);
                    if(sel != 0)
                    {
                        int ch = sel;
                        ch--;
                        if(list != null)
                        {
                            ElementOfThread r=null;
                            foreach(var next in list)
                            {
                                if(ch < 1)
                                {
                                    r = next;
                                    break;
                                }
                                ch--;
                            }
                            ProcessingMenuRecord(r.GetName());
                        }
                    } else if(list == null)
                    {
                        Console.WriteLine("PlayList is empty\nPress any key to back");
                        Console.ReadLine();
                    }
                } 
                
            }






        private int MenuRecord(record r)    /////////////////
        {
            Console.SetCursorPosition(0, 0);
            CountStringsFromConsole = 7;
            ConsoleCLear();
            r.WriteToConsole();
            string str = "0) Press to back.\n" +
                         "1) Press to play record.\n" +
                         "2) Press to stop record.\n" +
                         "3) Press to view record's information";

            Console.WriteLine(str);
            try
            {
                int sel = int.Parse(Console.ReadLine());
                return sel;
            } catch
            {
                return FormatException();
            }
        }
        public ElementOfThread SearchThread(record rec)
        {
            
            var clas = new WorkWithThreads();
            if(clas.GetExectionThreads() != null)
            { 
                ElementOfThread t=null;
                foreach(var temp in clas.GetExectionThreads())
                {
                    if(temp.GetName() == rec)
                        t = temp;   
                }
                if(t == null)
                    return null;
                else
                    return t;
            } else
            {
                return null;
            }

        }
        public void ProcessingMenuRecord(record r)
        {
            Console.SetCursorPosition(0, 0);
            if(r == null)
            {
                Console.Clear();
                Console.WriteLine("none record doesn't play\nPress any key to back");
                Console.ReadLine();
            } else
            {
                int sel = -1;
                while(sel != 0)
                {
                    sel = MenuRecord(r);
                    Console.Clear();
                    Console.SetCursorPosition(0, 0);
                    switch(sel)
                    {   
                        case 0:
                            break;
                        case 1:
                            var th =SearchThread(r);
                            if(th == null)
                            {
                                var cl = new WorkWithThreads();                                 
                                ConsoleCLear();
                                
                                cl.AddPlaingRecord(r);
                                Console.SetCursorPosition(0, 0);
                                Console.WriteLine("Your record is started successfull\nPress any key to back");
                                Console.ReadLine();
                            } else
                            {
                                Console.WriteLine("this record is plying now");
                                Console.WriteLine("Press any key to back");
                                Console.ReadLine();
                            }
                            sel = 0;
                            break;
                        case 2:
                            try
                            {
                                var thr =SearchThread(r);
                                var cl = new WorkWithThreads();
                                cl.AbortRecord(r);
                                Console.SetCursorPosition(0, 0);
                                Console.WriteLine("Your record is stoped successfull");
                            } catch
                            {
                                Console.SetCursorPosition(0, 0);
                                Console.WriteLine("Your record doesn't playing now");
                            }
                            Console.WriteLine("Press any key to back");
                            Console.ReadLine();
                            sel = 0;
                            break;
                        case 3:
                            r.WriteToConsole();
                            r.WriteAbout();
                            Console.WriteLine("Press any key to back");
                            Console.ReadLine();
                            break;
                        
                    }
                }
            }
        }



        public void ConsoleCLear()
        {
            Console.Clear();
        }
    }
}
