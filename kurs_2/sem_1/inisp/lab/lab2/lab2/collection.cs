using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab2
{ 




    public class turn<N>
    {
        private N member;
        private turn<N> next;
        public turn(N _member)
        {
            member=_member;
            next=null;
        }
        public turn<N> Next
        {
            get{return next;}
            set{next=value;}
        }

        public N Member
        {
            get{return member;}
            set{member=value;}
        }
    }





    class collection<N>:IEnumerable<N>
    {
        public turn<N> first;
        public turn<N> last;
        public int count;

        public collection()
        {
            first = null;
            last= null;
            count=0;
        }

         public int Count
        {
            get{return count;}
            set{count=value;}
        }

        public IEnumerator<N> GetEnumerator()
            {
                for (int i=0; i<count; i++)
                    yield return this[i];
            }

        IEnumerator IEnumerable.GetEnumerator()
        {
                return (IEnumerator)GetEnumerator();
            }

        public void add(N item)
        {
            if(count == 0)
            {
                first.Member = last.Member = item;
                first.Next = last.Next = null;
            } else
            {
                last.Next = new turn<N>(item);
                last = last.Next;
            }
            count++;
        }
        public void remove(N item)
        {
            if(count > 1)
            {
                turn<N> temp = first;
                while(temp.Next != null)
                {
                    if(temp.Next.Member.Equals(item))
                    {
                        temp.Next = temp.Next.Next;
                        count--;
                    }
                }
            } else
            {
                if((first.Member.Equals(item))&&(count==1))
                {
                    first = last = null;
                    count=0;
                }
            }
        }
        public int IndexOf(N item)
        {
            turn<N> temp = first;
            for(int i = 0;i < count;i++)
            {
                if(temp.Member.Equals(item))
                {
                    return i;
                }
                temp = temp.Next;
            }
                return -1;
        }
        public N this[int index]
        {
            get{
                    if (index <count)
                    {
                        turn<N> temp_member=first;
                        for(int i=0; i<index; i++)
                            temp_member=temp_member.Next;
                        return temp_member.Member;
                    }
                    else throw new ArgumentException();
                }
        }

       
    }
}
