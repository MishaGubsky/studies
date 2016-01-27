using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApplication1.Models
{
    using OxyPlot;
    using OxyPlot.Axes;
    using OxyPlot.Series;

    class MyStatistics
    {
        public const double a = -6, b = -2, dx = 0.001;
        public const double M = 1.0/2- 1.0/5 - 0.7;
        public const double D = 0.06;

        public double[] GenerateVariationArray(int n)
        {
            Random rand = new Random();

            double[] y = new double[n];
            for (int i = 0; i < n; i++)
            {
                double ksi = rand.NextDouble();
                double x = ksi * (b - a) + a;
                y[i] = 1.0/(x+1);
            }
            return y.OrderBy((e) => e).ToArray();
        }
    }
}
