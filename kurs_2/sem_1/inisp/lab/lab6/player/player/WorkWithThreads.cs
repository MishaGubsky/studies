using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace player
{
    public class WorkWithThreads
    {


        static List<ElementOfThread> PlayingRecords;
 //       public static TimeSpan PassTime;
        public void CreateNewQueue()
        {
            PlayingRecords = new List<ElementOfThread>();
        }
        public List<ElementOfThread> GetExectionThreads()
        {
            return PlayingRecords;
        }



        public void AddPlaingRecord(record rec)
        {
            Thread ExThread = new Thread(rec.WriteToConsoleAndWait);
            ElementOfThread element = new ElementOfThread(ExThread, rec);
            if(PlayingRecords == null)
                CreateNewQueue();
            PlayingRecords.Add(element);
            ExThread.Start();
        }
        public void AbortAllThread()
        {
            foreach(var thr in PlayingRecords)
            {
                thr.GetThread().Abort();
            }
            PlayingRecords.Clear();
        }


        public void AbortRecord(record r)
        {
                    var cl = new ConsoleWriter();
                    ElementOfThread element = cl.SearchThread(r);
                    PlayingRecords.Remove(element);
                    if(PlayingRecords.Count == 0)
                        PlayingRecords.Clear();
        }
    }
}
