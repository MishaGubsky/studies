using System;
using System.Text;
namespace _3
{
    class Program
    {
        static void Main(string[] args)
        {
            string s = Console.ReadLine();
            string snew = "";
            string st = "";
            for(int i=0; i<s.Length;i++)
            {
                if(s[i]!=' ')
                {
                    st = st + s[i];
                }
                else
                {
                    snew = ' ' + st + snew;
                    st = "";
                }
            }
            snew = st + snew;
            Console.WriteLine(snew);
            Console.ReadLine();
        }
    }
}
