using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApplication1.Models
{
    class Interval<T> : IEquatable<Interval<T>>
    {
        public T Start { get; private set; }
        public T End { get; private set; }

        public Interval(T start, T end)
        {
            Start = start;
            End = end;
        }

        public bool Equals(Interval<T> other)
        {
            var comparer = EqualityComparer<T>.Default;
            return comparer.Equals(this.Start, other.Start) && 
                   comparer.Equals(this.Start, this.End);
        }

        public override string ToString()
        {
            return string.Format("[{0:0.000000}; {1:0.0000000}]", Start, End);
        }
    }


    static class Quantilies
    {
        public static Dictionary<Tuple<int, double>, double> StudentQuantile
        {
            get
            {
                return new Dictionary<Tuple<int, double>, double>()
                {
                    { new Tuple<int, double>(19, 0.01), 2.860934606 },
                    { new Tuple<int, double>(19, 0.05), 2.093024054 },
                    { new Tuple<int, double>(19, 0.1), 1.729132812 },
                    { new Tuple<int, double>(19, 0.2), 1.327728209 },
                    { new Tuple<int, double>(19, 0.5), 0.68762146 },

                    { new Tuple<int, double>(29, 0.01), 2.756385904 },
                    { new Tuple<int, double>(29, 0.05), 2.045229642 },
                    { new Tuple<int, double>(29, 0.1), 1.699127027 },
                    { new Tuple<int, double>(29, 0.2), 1.311433647 },
                    { new Tuple<int, double>(29, 0.5), 0.683043861 },

                    { new Tuple<int, double>(49, 0.01), 2.679951974 },
                    { new Tuple<int, double>(49, 0.05), 2.009575237 },
                    { new Tuple<int, double>(49, 0.1), 1.676550893 },
                    { new Tuple<int, double>(49, 0.2), 1.299068785 },
                    { new Tuple<int, double>(49, 0.5), 0.679529645 },

                    { new Tuple<int, double>(69, 0.01), 2.648976774 },
                    { new Tuple<int, double>(69, 0.05), 1.994945415 },
                    { new Tuple<int, double>(69, 0.1), 1.667238549 },
                    { new Tuple<int, double>(69, 0.2), 1.293941609 },
                    { new Tuple<int, double>(69, 0.5), 0.678062008 }, 

                    { new Tuple<int, double>(99, 0.01), 2.626405457 },
                    { new Tuple<int, double>(99, 0.05), 1.984216952 },
                    { new Tuple<int, double>(99, 0.1), 1.660391156 },
                    { new Tuple<int, double>(99, 0.2), 1.290161442 },
                    { new Tuple<int, double>(99, 0.5), 0.676975986 },

                    { new Tuple<int, double>(149, 0.01), 2.609227907 },
                    { new Tuple<int, double>(149, 0.05), 1.976013178 },
                    { new Tuple<int, double>(149, 0.1), 1.655144534 },
                    { new Tuple<int, double>(149, 0.2), 1.287259135 },
                    { new Tuple<int, double>(149, 0.5), 0.676139872 },
                };
            }
        }

        public static Dictionary<double, double> NormalQuantile
        {
            get
            {
                return new Dictionary<double, double>()
                {
                    { 0.01, 2.80 },
                    { 0.05, 2.24 },
                    { 0.1, 1.96 },
                    { 0.2, 1.65 },
                    { 0.5, 1.15 },
                };
            }
        }

        public static double HiApproximation(double alpha, int n)
        {
            double[] a = { 1.0000886, 0.4713941, 0.0001348028, -0.008553069, 0.00312558, -0.0008426812, 0.00009780499 };
            double[] b = { -0.2237368, 0.02607083, 0.01128186, -0.01153761, 0.005169654, 0.00253001, -0.001450117 };
            double[] c = { -0.01513904, -0.008986007, 0.02277679, -0.01323293, -0.006950356, 0.001060438, 0.001565326 };

            double d = 0;
            if (alpha >= 0.5 && alpha <= 0.999)
                d = 2.0637 * Math.Pow(Math.Log(1 / (1 - alpha)) - 0.16, 0.4247) - 1.5774;
            else
                d = -2.0637 * Math.Pow(Math.Log(1 / (alpha)) - 0.16, 0.4247) + 1.5774;

            double hi = 0;
            for (int i = 0; i < 7; i++)
                hi += Math.Pow(n, -i / 2.0) * Math.Pow(d, i) * (a[i] + b[i] / n + c[i] / (n * n));
            return hi * hi * hi * n;
        }

    }


    abstract class DistributionParameter
    {
        public string Name { get; protected set; }
        public abstract double PointEstimation(double[] x);
        public abstract Interval<double> IntervalEstimation(double[] x, double alpha);
        public abstract Interval<double> IntervalEstimation(double[] x, double alpha, double param);
    }


    class ExpectedValue : DistributionParameter
    {
        public ExpectedValue()
        {
            this.Name = "МO";
        }

        public override double PointEstimation(double[] x)
        {
            return x.Sum() / x.Length;
        }

        public override Interval<double> IntervalEstimation(double[] x, double alpha)
        {
            int n = x.Length;
            double m = PointEstimation(x);
            double d = (new Variance()).PointEstimation(x);

            double u = Quantilies.StudentQuantile[new Tuple<int, double>(n - 1, Math.Round(alpha, 3))];
            double eps = u * Math.Sqrt(d / n);
            return new Interval<double>(m - eps, m + eps);
        }

        public override Interval<double> IntervalEstimation(double[] x, double alpha, double d)
        {
            int n = x.Length;
            double m = PointEstimation(x);
            
            double u = (n > 20) ? Quantilies.NormalQuantile[Math.Round(alpha, 3)] :
                                  Quantilies.StudentQuantile[new Tuple<int, double>(n - 1, Math.Round(alpha, 3))];
            double eps = u * Math.Sqrt(d / n);
            return new Interval<double>(m - eps, m + eps);
        }
    }

    class Variance : DistributionParameter
    {
        public Variance()
        {
            this.Name = "дисперсии";
        }

        public override double PointEstimation(double[] x)
        {
            double m = (new ExpectedValue()).PointEstimation(x);
            return x.Select(v => (v - m) * (v - m)).Sum() / (x.Length - 1);
        }

        public double PointEstimation(double[] x, double m)
        {
            return x.Select(v => (v - m) * (v - m)).Sum() / (x.Length);
        }

        public override Interval<double> IntervalEstimation(double[] x, double alpha)
        {
            int n = x.Length;
            double v = this.PointEstimation(x);

            double a = (n - 1) * v / Quantilies.HiApproximation(1 - alpha / 2, n - 1);
            double b = (n - 1) * v / Quantilies.HiApproximation(alpha / 2, n - 1);
            return new Interval<double>(a, b);
        }

        public override Interval<double> IntervalEstimation(double[] x, double alpha, double m)
        {
            int n = x.Length;
            double v = this.PointEstimation(x, m);
            double a = n * v / Quantilies.HiApproximation(1 - alpha / 2, n);
            double b = n * v / Quantilies.HiApproximation(alpha / 2, n);
            return new Interval<double>(a, b);
        }
    }
}
