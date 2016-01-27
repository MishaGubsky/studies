using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Globalization;

namespace lab1
{
    class Number:IFormattable, IComparable<int>, IEquatable<int>
    {

        static void Main(string[] args)
        {
            Number p=new Number(2,5);
            Number m=new Number(3,5);
            int result = p.CompareTo(m);
            Console.WriteLine("{0}",result);
            Console.Read();
        }

        private int a;
        private int b;

        public Number(int n, int m)
        {
            a = n;
            b = (m > 0) ? m : 1;
        }
        //Числитель
        public int A
        {
            get
            {
                return a;
            }
            set
            {
                b = value;
            }
        }
        
        //Знаменатель
        public int B
        {
            get
            {
                return b;
            }
            set
            {
                if(value > 0)
                    b = value;
                else
                    throw new Exception("Не корректное условие");
            }
        }

        //НОД

        public static int gcd(int a, int b)
        {
            if(a == b)
                return a;
            else
            {
                if(a > b)
                    return gcd(a - b, b);
                else
                    return gcd(a, b - a);
            }
        }

        //operations

        public static Number operator +(Number a, Number b)
        {
            Number result = new Number(1, 1);

            result.B = a.B * b.B;
            result.A = a.A * b.B + a.B * b.A;
            int nod = gcd(result.A, result.B);
            result.A /= nod;
            result.B /= nod;
            return result;
        }

        public static Number operator -(Number a, Number b)
        {
            Number result = new Number(1, 1);

            result.B = a.B * b.B;
            result.A = a.A * b.B - a.B * b.A;
            int nod = gcd(result.A, result.B);
            result.A /= nod;
            result.B /= nod;
            return result;
        }

        public static Number operator *(Number a, Number b)
        {
            Number result = new Number(1, 1);

            result.B = a.B * b.B;
            result.A = a.A * b.A;
            int nod = gcd(result.A, result.B);
            result.A /= nod;
            result.B /= nod;
            return result;
        }

        public static Number operator /(Number a, Number b)
        {
            Number result = new Number(1, 1);

            result.B = a.B * b.A;
            result.A = a.A * b.B;
            int nod = gcd(result.A, result.B);
            result.A /= nod;
            result.B /= nod;
            return result;
        }

        public static bool operator >(Number a, Number b)
        {
            if(a.A * b.B > b.A * a.B)
                return true;
            else
                return false;
        }

        public static bool operator <(Number a, Number b)
        {
            if(a.A * b.B < b.A * a.B)
                return true;
            else
                return false;
        }

        public static bool operator >=(Number a, Number b)
        {
            if(a.A * b.B >= b.A * a.B)
                return true;
            else
                return false;
        }

        public static bool operator <=(Number a, Number b)
        {
            if(a.A * b.B <= b.A * a.B)
                return true;
            else
                return false;
        }

        public static bool operator ==(Number a, Number b)
        {
            return a.Equals(b);
        }

        public static bool operator !=(Number a, Number b)
        {
            return !a.Equals(b);
        }



        public override bool Equals(object obj)
        {
            if(obj is Number)
            {
                return Equals((Number)obj);
            }
            return false;
        }

        public bool Equals(Number other)
        {
            if(this.a * other.b == this.b * other.a)
                return true;
            return false;
        }

        public int CompareTo(Number other)
        {
            if((object)other == null)
                return 1;
            if(Equals(this, other))
                return 0;
            if(this.a * other.b > this.b * other.a)
                return 1;
            return -1;
        }

        public override string ToString()
        {
            return this.ToString("M", CultureInfo.CurrentCulture);
        }

        public string ToString(string format)
        {
            return this.ToString(format, CultureInfo.CurrentCulture);
        }

        public Number Parse(string s)
        {
            string s1, s2;
            Number result = new Number(1, 1);
            bool minus = false;
            if(s[0] == '-')
                minus = true;
            int n = 0, m = 0, g = 0;
            char simbol = '0';
            for(int i = 0;i < s.Length;i++)
            {
                if(!(s[i] >= '0') || !(s[i] <= '9'))               //проверка на лишние символы
                {
                    if(!((s[i] == '/') || (s[i] == ',') || (s[i] == '-')))
                        return null;
                }
            }
            for(int i = 0;i < s.Length;i++)        //нахождение позиции ключегого символа
            {
                if((s[i] == '/') || (s[i] == ','))
                {
                    g = i;
                    simbol = s[i];
                    break;
                }
            }
            s1 = s.Substring(0, g);
            s2 = s.Substring(g + 1, s.Length - g - 1);
            n = int.Parse(s1);
            m = int.Parse(s2);
            int nod = gcd(Math.Abs(n), m);
            this.A = n / nod;
            this.B = m / nod;
            if (minus)
                this.A *= -1;
            return this;


        }


        public override int GetHashCode()
        {
            return base.GetHashCode();
        }






        public string ToString(string format, IFormatProvider provider)
        {
            if(String.IsNullOrEmpty(format))
                format = "M";
            if(provider == null)
                provider = CultureInfo.CurrentCulture;
            double numberdouble = (double)A / B;

            switch(format.ToUpperInvariant())
            {
                case "M":
                return (String.Format("{0}/{1}", a, b));
                case "D":
                return (String.Format("{0:0.0000}", numberdouble));
                default:
                throw new FormatException(String.Format("Формат не известен"));
            }

        }

        public int CompareTo(int other)
        {
            throw new NotImplementedException();
        }

        public bool Equals(int other)
        {
            throw new NotImplementedException();
        }
    } 
 

}
