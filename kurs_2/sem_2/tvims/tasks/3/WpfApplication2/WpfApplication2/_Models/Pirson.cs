using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApplication2._Models
{
    class Pirson
    {
        public const double y_a = -1.0 / 5, y_b = -1;
        public double[] alphaHi2 = { 0.01, 0.025, 0.05, 0.95, 0.975, 0.99 };
        public double[] hi2 = { 37.6, 31.2, 31.4, 10.9, 9.59, 8.26 };
        public double[] Empericalhi2 = new double[3];

        public double _Pirson(double[] v, Distribution _fun)
        {
            int N = v.Length, _n = (int)((N > 100) ? 4 * Math.Log(N) : Math.Sqrt(N));

            int w = N / _n;
            double _p = 1.0 / w;
            double _EmpericalHi2 = 0;
            double Ai = y_b, Bi;

            for (int i = 0; i < _n; i++)
            {
                Bi = (double)(v[(int)(w * i)] + v[(int)(w * i) + 1]) / 2;
                double pi = _fun.Function(Bi) - _fun.Function(Ai);
                _EmpericalHi2 += Math.Pow((_p - pi), 2) / pi;
                Ai = Bi;
            }
            _EmpericalHi2 *= N;

            int j = hi2.Length - 1;
            while ((j != -1) && (hi2[j] < _EmpericalHi2))
                j--;
            if (j == -1)
                return 0;
            else
                return alphaHi2[j];
        }
    }
}
