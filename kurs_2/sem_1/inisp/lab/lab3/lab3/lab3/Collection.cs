using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab3
{
   public class Collection
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

        public class coupe:IDisposable, IComparable<coupe>
        {
            public int number;
            public int number_passenger;
            public int Number
            {
                get
                {
                    return number;
                }
                set
                {
                    number = value;
                }
            }
            public int Number_passenger
            {
                get
                {
                    return number_passenger;
                }
                set
                {
                    number_passenger = value;
                }
            }
            public bool disposed;

            public coupe(int number_coupe, int number_passenger)
            {
                Number = number_coupe;
                Number_passenger = number_passenger;
            }

            public override bool Equals(object obj)
            {
                if(obj is coupe)
                {
                    return Equals((coupe)obj);
                }
                return false;
            }
            public bool Equals(coupe other)
            {
                if(this.number == other.number)
                    return true;
                return false;
            }
            public override int GetHashCode()
            {
                return base.GetHashCode();
            }
            public int CompareTo(coupe your)
            {
                if(this.number.Equals(your))
                    return 0;
                else
                    if(this.number > your.number)
                        return 1;
                    else
                        return -1;

            }
            public void Dispose()
            {
                Dispose(true);
                GC.SuppressFinalize(this);
            }
            protected virtual void Dispose(bool disposing)
            {
                if(!this.disposed)
                {
                    if(disposing)
                    {
                        this.Dispose();
                    }
                    disposed = true;
                }
            }



            ~coupe()
            {
                Dispose(false);
            }
        }

        public class carriage:turn<coupe>
        {
            public int number;
            public int number_coupes;

            public int Number
            {
                get
                {
                    return number;
                }
                set
                {
                    number = value;
                }
            }
            public int Number_coupes
            {
                get
                {
                    return number_coupes;
                }
                set
                {
                    number_coupes = value;
                }
            }

            public carriage(int number, int number_coupes)
            {
                Number = number;
                Number_coupes = number_coupes;
            }

            public coupe[] Findcoupe(int find_number)
            {
                if(find_number <= this.number_coupes)
                    return this.Where(x => (x.Number == find_number)).ToArray();
                else
                    throw new ArgumentNullException();
            }
        }

        public class train:turn<carriage>
        {
            public int number;
            public int number_carriages;

            public int Number
            {
                get
                {
                    return number;
                }
                set
                {
                    number = value;
                }
            }
            public int Number_carriages
            {
                get
                {
                    return number_carriages;
                }
                set
                {
                    number_carriages = value;
                }
            }

            public train(int number, int number_carriages)
            {
                Number = number;
                Number_carriages = number_carriages;
            }

            public carriage[] Findcarrige(int find_number)
            {
                if(find_number <= this.number_carriages)
                    return this.Where(x => (x.Number == find_number)).ToArray();
                else
                    throw new ArgumentNullException();
            }
        }
    }
}


