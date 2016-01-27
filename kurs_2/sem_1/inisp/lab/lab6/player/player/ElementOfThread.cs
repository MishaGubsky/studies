using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace player
{
    public class ElementOfThread
    {
        static Thread thread;
        static record record;
        public ElementOfThread(Thread _thread, record _record)
        {
            thread = _thread;
            record = _record;
        }
        public Thread GetThread()
        {
            return thread;
        }
        public record GetName()
        {
            return record;
        }
    }
}
