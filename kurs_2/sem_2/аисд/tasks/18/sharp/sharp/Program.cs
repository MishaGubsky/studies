using System;

namespace sharp
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());
            int[] a=new int[n];
            string[] _a=Console.ReadLine().Split(new char[]{' '});
            for(int i=0;i<_a.Length;i++)
                a[i]=int.Parse(_a[i]);


            long count=0;
            int max = a[0];

            for(int i=0;i<n-1;i++)
            {
                if(a[i+1]>a[i])
                {
                    count += a[i + 1] - a[i];
                    a[i] = a[i + 1];
                    if (a[i + 1] > max)
                        max = a[i + 1];
                }
            }
            count += max - a[n - 1];
            Console.WriteLine(count);
        }
    }
}
