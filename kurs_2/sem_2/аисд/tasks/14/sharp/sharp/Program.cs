using System;

namespace sharp
{
    class Program
    {
        static void Main(string[] args)
        {
            string n = Console.ReadLine();
            if ((n.Length == 1) || (n[n.Length - 1] == '0'))
                Console.WriteLine("NO");
            else
                Console.WriteLine(n[n.Length-1]);
        }
    }
}
