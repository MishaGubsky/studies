using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;

using OxyPlot.Series;
using OxyPlot.Axes;

namespace OxyPlot.Models
{
    class AppModel: INotifyPropertyChanged
    {

        public const double a = -1, b = 3, dx = 0.001;

        public int N { get; set; }
        public PlotModel PlotViewModel { get; private set; }
        public double[] VariationArray { get; private set; }
        public LineSeries EmpiricalFunction { get; private set; }
        public FunctionSeries TheoreticalFunction { get; private set; }

        public AppModel()
        {
            this.PlotViewModel = new PlotModel();
            this.PlotViewModel.LegendPlacement = LegendPlacement.Outside;
            this.PlotViewModel.LegendPosition = LegendPosition.BottomLeft;
            this.PlotViewModel.LegendFontSize = 16;
            this.PlotViewModel.LegendFont = "Calibri";
            this.PlotViewModel.Axes.Add(new LinearAxis(AxisPosition.Bottom, 0, 1));
            this.PlotViewModel.Axes.Add(new LinearAxis(AxisPosition.Left, 0, 1));

            N = 400;
            UpdateModel();
        }

        public void UpdateModel()
        {
            GetStatistic();
            this.PlotViewModel.Series.Clear();
            this.PlotViewModel.Series.Add(EmpiricalFunction);
            this.PlotViewModel.Series.Add(TheoreticalFunction);
        }

        public void GetStatistic()
        {
            Random rand = new Random();

            double[] y = new double[N];
            for (int i = 0; i < N; i++)
            {
                double ksi = rand.NextDouble();
                double x = ksi * (b - a) + a;
                y[i] = Math.Abs(Math.Cos(x));
            }

            double[] v = y.OrderBy((x) => x).ToArray();
            double[] F = new double[N];
            for (int i = 0; i < N; i++)
            {
                int w = 0;
                for (int j = 0; j < N; j++)
                    if (v[i] == v[j]) w++;

                F[i] = (double)w / N;
                if (i > 0) F[i] += F[i - 1];
            }

            VariationArray = v;
            EmpiricalFunction = new LineSeries() { Title = "Эмпирическая функция распределения" };
            for (int i = 0; i < N; i++)
            {
                EmpiricalFunction.Points.Add(new DataPoint(v[i], (i > 0) ? F[i - 1] : 0));
                EmpiricalFunction.Points.Add(new DataPoint(v[i], F[i]));
            }

            Func<double, double> tF = (arg) =>
            {
                if (arg < 0)
                    return 0;
                else if (arg >= 1)
                    return 1;
                else if (arg >= 0 && arg < Math.Cos(a))
                    return (-2 * Math.Acos(arg) + Math.PI) / 4;
                else if (arg >= Math.Cos(a) && arg < -Math.Cos(b))
                    return (Math.PI - 3 * Math.Acos(arg) - a) / 4;
                else
                    return (-2 * Math.Acos(arg) - a + b) / 4;
            };
            TheoreticalFunction = new FunctionSeries(tF, 0, 1, dx) { Title = "Теоретическая" };
        }

    }
}
