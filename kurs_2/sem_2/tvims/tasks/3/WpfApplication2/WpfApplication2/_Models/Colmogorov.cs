using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApplication2._Models
{
    class Colmogorov
    {
        public const double y_a = -1.0 / 5, y_b = -1;
        public double _Colmogorov(double[] v,  Distribution _fun)
        {
            int N = v.Length;



            double[] F = new double[N];
            for (int i = 0; i < N; i++)
            {
                int w = 0;
                for (int j = 0; j < N; j++)
                    if (v[i] == v[j]) w++;

                F[i] = (double)w / N;
                if (i > 0) F[i] += F[i - 1];
            }



            double max=Math.Abs(_fun.Function(v[0])-F[0]), Bi;


            int k = 0;
            for (int i = 1; i < N; i++)
            {
                if (Math.Abs(_fun.Function(v[i]) - F[i])>max)
                {
                    max = Math.Abs(_fun.Function(v[i]) - F[i]);
                    //k = i;
                }
            }


            if (max < 0.248)
                return 0.95;
            else if (max < 0.2972)
                return 0.99;
            else
                return 0;
            




            
        }
    }
}
