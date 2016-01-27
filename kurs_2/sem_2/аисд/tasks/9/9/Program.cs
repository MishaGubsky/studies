using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _9
{
    class Program
    {
        static void Main(string[] args)
        {
            int n=int.Parse(Console.ReadLine());
            int[] D = int.Parse(Console.ReadLine().Split);
            for (int i = 0; i < n; i++)
                Console.WriteLine(D[i]);
            Console.ReadLine();
        }
    }
}
