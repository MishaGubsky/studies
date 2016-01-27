using System;

namespace sharp
{
    class Program
    {
        
        static bool OneLetter(string s)
        {
            for(int i=1; i<s.Length;i++)
            {
                if (s[i] != s[0])
                    return false;
            }
            return true;
        }
        private static bool IsPn(string s)
        {
            int l = 0, r = s.Length-1, m = (l + r) / 2;
            while(l<=m+1)
            {
                if (s[l] != s[r])
                    return false;
                l++;
                r--;
            }
            return true;
        }
        static void Main(string[] args)
        {
            string s = Console.ReadLine();
            if (OneLetter(s))
                Console.WriteLine("-1");
            else
            {
                if (IsPn(s))
                    Console.WriteLine(s.Length - 1);
                else
                    Console.WriteLine(s.Length);
            }
        }
    }
}
