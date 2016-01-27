using System;

namespace sharp
{
    class Program
    {
        static double Calculate(int n)
        {
            if (n > 365)
                return 100;
            double res = 1;
            for (int i = 1; i <n+1; i++)
                res =res* (1.0 - ((i - 1.0)/ 365.0));
            return (1-res)*100;
        }

        static void Main(string[] args)
        {
            bool go=true;
            int n = 0;
            //Queue<int> a = new Queue<int>();
            while(go)
            {
                try
                {
                    n = int.Parse(Console.ReadLine());
                }
                catch
                { go = false;}

                if(go)
                {
                    double answer = Calculate(n);
                    Console.WriteLine(answer);
                }
            }
        }
    }
}
