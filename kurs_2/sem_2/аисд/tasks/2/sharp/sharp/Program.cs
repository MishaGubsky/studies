using System;

namespace sharp
{
    class Program
    {
        public static long gcd(long a, long b)
        {
            if (b == 0)
                return a;
            else
            {
                return gcd(b, a % b);
            }
        }


        static long Square(long[] X, long[] Y, long N)
        {
            long answer = 0;
            for (long i = 0; i < N; i++)
            {
                answer += (X[i + 1] - X[i]) * (Y[i + 1] + Y[i]);
            }

            return Math.Abs(answer) / 2;
        }

        static long CountDots(long[] X, long[] Y, long N)
        {
            long count = 0;
            for (long i = 0; i < N; i++)
            {
                count += gcd(Math.Abs(X[i + 1] - X[i]), Math.Abs(Y[i + 1] - Y[i]));
            }

            return count;
        }



        static void Main(string[] args)
        {
            long n = long.Parse(Console.ReadLine());
            long[] X = new long[n + 1];
            long[] Y = new long[n + 1];
            for (long i = 0; i < n; i++)
            {
                string s = Console.ReadLine();
                string[] arr = s.Split(new char[] { ' ' });
                X[i] = long.Parse(arr[0]);
                Y[i] = long.Parse(arr[1]);
            }
            X[n] = X[0];
            Y[n] = Y[0];
            long S = Square(X, Y, n);
            long G = CountDots(X, Y, n);

            long B = S - G / 2 + 1;
            Console.WriteLine(B);
            Console.ReadKey();
        }

    }
}
