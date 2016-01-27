using System;

namespace sharp
{
    class Program
    {
        static void Main(string[] args)
        {
            int year = int.Parse(Console.ReadLine());
            if((year%4==0)&&(year%100!=0))
            {
                Console.WriteLine("YES");
            }else if(year%400==0)
            {
                Console.WriteLine("YES");
            }else
                Console.WriteLine("NO");
        }
    }
}
