using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApplication2._Models
{
    abstract class Distribution
        {
            public int S { get; protected set; }
            public string Name { get; protected set; }
            public abstract double Density(double x);
            public abstract double Function(double x);
        }
        class NormalDistributon : Distribution
        {
            public double O { get; private set; }
            public double M { get; private set; }

            public NormalDistributon(double[] v)
            {
                this.S = 2;
                this.Name = "Нормальное распределение";

                this.M = v.Sum() / v.Length;
                this.O = v.Select(x => (x - this.M) * (x - this.M)).Sum() / (v.Length - 1);
                this.O = Math.Sqrt(this.O);
            }

            public override double Density(double x)
            {
                double c = Math.Sqrt(2 * Math.PI);
                return 1 / (O * c) * Math.Exp(-(x - M) * (x - M) / (2 * O * O));
            }

            public override double Function(double x)
            {
                x = (x - M) / O;
                Func<double, double> f = (arg) => { return Math.Exp(-arg * arg / 2); };

                const int n = 1000;
                double h = Math.Abs(x - 0) / n;

                double sum = 0;
                for (int i = 1; i < n; ++i)
                    sum += f(i * h);
                sum = h * ((f(0) + f(x)) / 2 + sum);

                return 0.5 + Math.Sign(x) * sum / Math.Sqrt(2 * Math.PI);
            }
        }


        class ExponentialDistribution : Distribution
        {
            public double L { get; private set; }

            public ExponentialDistribution(double[] v)
            {
                this.S = 1;
                this.Name = "Экспоненциальное распределение";

                this.L = 1 / v.Sum() * v.Length;
            }

            public override double Density(double x)
            {
                return L * Math.Exp(-x * L);
            }

            public override double Function(double x)
            {
                return 1 - Math.Exp(-L * x);
            }
        }


        class UniformDistribution : Distribution
        {
            public double A { get; set; }
            public double B { get; set; }

            public UniformDistribution(double[] v)
            {
                this.S = 2;
                this.Name = "Равномерное распределение";

                this.A = v.Min();
                this.B = v.Max();
            }

            public override double Density(double x)
            {
                return 1 / (B - A);
            }

            public override double Function(double x)
            {
                if (x < A)
                    return 0;
                else if (x > B)
                    return 1;
                else
                    return (x - A) / (B - A);
            }
        }


        class MyDistribution : Distribution
        {
            private const int a = -6, b = -2;

            public MyDistribution()
            {
                this.S = 2;
                this.Name = "Теоретическое распределенние";
            }

            public override double Density(double x)
            {
                if (x < -1)
                    return 0;
                else if (x >= -1 / 5)
                    return 1;
                else
                    return (1.0 / (4 * x * x));
            }

            public override double Function(double x)
            {
                if (x < -1)
                    return 0;
                else if (x >= -1 / 5)
                    return 1;
                else
                    return (1.0 / (4 * Math.Abs(x)) - 0.25);
            }
        }
}
