using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Xml.Serialization;
using System.Collections;

namespace lab3
{
    [Serializable] 
    [DataContract(Name = "coupe")]
    public class coupe:IDisposable, IComparable<coupe>
        {   
            [DataMember(Name= "Numberofcoupe")]
            public int number;
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
            [DataMember(Name= "Number_passanger")]
            public int number_passenger;
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

}


