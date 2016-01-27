using System;
//using System.Text;

namespace _11
{
    class Program
    {
        static bool Equals(int[] s,int[] b )
        {
           for(int i=0;i<10;i++)
           {
               if (s[i] == b[i])
               {
                   continue;
               }
               else
               {
                   return false;
                   break;
               }
           }
           return true;
        }
        static void Main(string[] args)
        {
            bool failed = true;
            int [] a = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
            int s = int.Parse(Console.ReadLine());
            int temp = s, count = 0; ;
            while (s > 0)
	        {
		        int ost = s % 10;
		        a[ost] = a[ost] + 1;
		        s = s / 10;
		        count++;
	        }
            int len = 1;
            for (int i = 0; i < count; i++)
                len *= 10;
            for(int i=temp+1;i<len; i++)
            {
                int[] b={0,0,0,0,0,0,0,0,0,0};
                temp = i;
		        while (temp > 0)
		        {
			        int ost = temp % 10;
			        b[ost] = b[ost] + 1;
			        temp = temp / 10;
		        }
		        if (Equals(a,b))
		        {
			        Console.WriteLine(i);
                    failed = false;
                    break;
		        }
            }
            if(failed)
             Console.WriteLine("-1");
        }
    }
}
