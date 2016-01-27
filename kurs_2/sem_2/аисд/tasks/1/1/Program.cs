using System;

namespace _1
{
    class Program
    {
        static int merge_sort(int[] A, int l, int r)
        {
            int k = 0;
            if (l == r)
                return k;
            int m = (l + r)/2;
            k += merge_sort(A, l, m);
            k += merge_sort(A, m + 1, r);
            k += merge(A, l, m, r);
            return k;
        }

        static int merge(int[] A, int l, int m, int r)
        {
            int k = 0;
            int[] buffer = new int[r - l + 1];
            int pos1 = l;
            int pos2 = m + 1;
            int posB = 0;

            while (pos1 <= m && pos2 <= r)
            {
                if (A[pos1] <= A[pos2])
                {
                    buffer[posB] = A[pos1++];
                    posB++;
                }
                else
                {
                    buffer[posB++] = A[pos2++];
                    k += m - pos1 + 1;
                }
            }
            while (pos2 <= r)
                buffer[posB++] = A[pos2++];
            while (pos1 <= m)
                buffer[posB++] = A[pos1++];

            for (posB = 0; posB < r - l + 1; posB++)
            {
                A[l + posB] = buffer[posB];
            }
            return k;
        }


        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());
            int[] A = new int[n];
            string s = Console.ReadLine()+' ';
            int i=0,j=0;
            while(i<s.Length)
            {
                string num = "";
                while ((i<s.Length)&&(s[i] != ' '))
                {
                    num = num + s[i];
                    i++;
                }
                A[j] = int.Parse(num);
                j++; i++;
            }
            Console.WriteLine(merge_sort(A, 0, n - 1));
        }
    }
}
