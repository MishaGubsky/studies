using System;
namespace sharp
{
    class Program
    {
        static void Main(string[] args)
        {
            string S = Console.ReadLine();
            char[] Chars = S.ToCharArray();

            int N = int.Parse(Console.ReadLine());
            int[] L = new int[S.Length];
            int[] R = new int[S.Length];

            for (int i = 0; i < N; i++)
            {
                string input = Console.ReadLine();
                string[] arr = input.Split(new char[] { ' ' });
                int Li = int.Parse(arr[0]);
                int Ri = int.Parse(arr[1]);

                if (Li > Ri)
                {
                    int temp = Li;
                    Li = Ri;
                    Ri = temp;
                }
                else if (Ri > S.Length)
                    Ri = S.Length;
                else if (Li < 1)
                    Li = 1;

                L[Li - 1] += 1;
                R[Ri- 1] += 1;
            }

            int k = 0;
            for (int i = 0; i < S.Length; i++)
            {
                k += L[i];

                if (k % 2 == 0)
                {
                    Console.Write(Chars[i]);
                }
                else
                {
                    if (char.IsLower(Chars[i]))
                        Console.Write(char.ToUpper(Chars[i]));
                    else
                    {
                        Console.Write(char.ToLower(Chars[i]));
                    }
                }
                k -= R[i];
            }
            Console.ReadLine();
        }
    }
}
