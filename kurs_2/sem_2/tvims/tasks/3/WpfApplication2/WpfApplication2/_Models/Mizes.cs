using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApplication2._Models
{
    class Mizes
    {
        public const double y_a = -1.0 / 5, y_b = -1;
        public double _Mizes(double[] v, Distribution _fun)
        {
            int N = v.Length;
            double[] F = new double[N];
            double Coef=0;
            for (int i = 0; i < N; i++)
            {
                Coef+=Math.Pow(((i-0.5)/N)-_fun.Function(v[i]),2);
            }   

            Coef+=1.0/(12*N);


            if (Coef < 0.3473)
                return 0.1;
            else if (Coef < 0.4614)
                return 0.95;
            else if (Coef < 0.7435)
                return 0.99;
            else if (Coef < 0.8694)
                return 0.995;
            else if (Coef < 1.1679)
                return 0.999;
            else
                return 0;
        }
    }
}
