using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab3
{
    public class turn<N>:IEnumerable<N>, IDisposable
    {
        public class element
        {
            private N member;
            private element next;

            public element(N _member)
            {
                member = _member;
                this.next = null;
            }

            public element Next
            {
                get
                {
                    return next;
                }
                set
                {
                    next = value;
                }
            }
            public N Member
            {
                get
                {
                    return member;
                }
                set
                {
                    member = value;
                }
            }
        }

        public element first;
        public element last;
        public int count;


        public turn()
        {
            first = null;
            last = null;
            count = 0;
        }

        public int Count
        {
            get
            {
                return count;
            }
            set
            {
                count = value;
            }
        }

        public IEnumerator<N> GetEnumerator()
        {
            for(int i = 0;i < count;i++)
                yield return this[i];
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return (IEnumerator)GetEnumerator();
        }

        public void add(N item)
        {
            element help = new element(item);
            if(count == 0)
            {

                first = last = help;
            } else
            {
                last.Next = help;
                last = last.Next;
            }
            count++;
        }
        public void remove(N item)
        {
            if(count > 1)
            {
                element temp = first;
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
                if((first.Member.Equals(item)) && (count == 1))
                {
                    first = last = null;
                    count = 0;
                }
            }
        }
        public int IndexOf(N item)
        {
            element temp = first;
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
            get
            {
                if(index < count)
                {
                    element temp_member = first;
                    for(int i = 0;i < index;i++)
                        temp_member = temp_member.Next;
                    return temp_member.Member;
                } else
                    throw new ArgumentException();
            }
        }

        public void removeall()
        {
            element temp = first;
            element help;
            while(temp != null)
            {
                help = temp;
                temp = temp.Next;
                remove(help.Member);
            }

        }

        void IDisposable.Dispose()
        {
            removeall();
        }
    }

}
