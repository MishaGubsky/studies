using System;
namespace sharp
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());
            long[] a = new long[n];
            for (int i = 0; i < n; i++ )
            {
                a[i] = long.Parse(Console.ReadLine());
            }
            bool x = false, y = false, z = false, xy = false, xz = false, yz = false, xyz = false;
            for(int i=0;i<n;i++)
            {
                switch(a[i])
                {
                    case 1021:
                        x = true;
                        break;
                    case 1031:
                        y = true;
                        break;
                    case 1033:
                        z = true;
                        break;
                    case 1021*1031:
                        xy = true;
                        break;
                    case 1021*1033:
                        xz = true;
                        break;
                    case 1031*1033:
                        yz = true;
                        break;
                    case 1021*1031*1033:
                        xyz = true;
                        break;
                    default:
                        break;
                }
            }
            if ((x && y && z) || (x && yz) || (y && xz) || (z && xy) || xyz)
                Console.WriteLine("YES");
            else
                Console.WriteLine("NO");
        }
    }
}
