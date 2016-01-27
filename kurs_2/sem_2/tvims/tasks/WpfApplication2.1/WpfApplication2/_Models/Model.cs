using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OxyPlot;
using OxyPlot.Axes;
using OxyPlot.Series;
using System.ComponentModel;


namespace WpfApplication2.Models
{
    class Model : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        public void SetProperty<T>(ref T field, T value, string property_name)
        {
            field = value;
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(property_name));
            }
        }

        public const double a = -6, b = -2, y_a=-1.0/5, y_b=-1, dx=0.001;

        public int N { get; set; }

        public LineSeries PoligonFunction { get; set; }
        public PlotModel PlotViewModel { get; private set; }
        public PlotModel PlotViewModel_1 { get; private set; }
        public double[] VariationArray { get; private set; }
        public LineSeries Histogram { get; private set; }
        public FunctionSeries TheoreticalFunction { get; private set; }

        public LineSeries VarFunction;
        public LineSeries VariationFunction
        {
            get { return VarFunction; }
            set { SetProperty(ref VarFunction, value, "VariationFunction"); }
        }

        public Model()
        {
            this.PlotViewModel = new PlotModel();
            this.PlotViewModel.LegendPlacement = LegendPlacement.Outside;
            this.PlotViewModel.LegendPosition = LegendPosition.BottomLeft;
            this.PlotViewModel.LegendFontSize = 16;
            this.PlotViewModel.LegendFont = "Calibri";
            this.PlotViewModel.Axes.Add(new LinearAxis(AxisPosition.Bottom, -1, -1.0 / 5));
            this.PlotViewModel.Axes.Add(new LinearAxis(AxisPosition.Left, 0, 6.5));
            
            N = 400;
            UpdateModel();
        }

        public void UpdateModel()
        {
            GetStatistic();
            this.PlotViewModel.Series.Clear();
            this.PlotViewModel.Series.Add(Histogram);

            //this.PlotViewModel.Series.Clear();
            this.PlotViewModel.Series.Add(PoligonFunction);
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
                y[i] = 1 / (x + 1);
            }

            double[] v = y.OrderBy((x) => x).ToArray();
            
            int _n;
            if(N<=100)
                _n=(int)Math.Sqrt(N);
            else
                _n = (int)(4 * Math.Log10(N));

            double h = Math.Abs(y_a - y_b) / _n;

            
            double Bi = Math.Min(y_b, y_a)+h;
            double[] F = new double[N];
            int halfpoint=0, j=0;
            for (int i = 0; i < _n; i++)
            {
                int w = halfpoint/2;
                if (i != _n - 1)
                {
                    halfpoint = 0;
                    while ((v[j] < Bi) && j < N)
                    {
                        w++;
                        j++;
                    }
                    while ((v[j] == Bi) && j < N)
                    {
                        halfpoint++;
                        j++;
                    }
                    w += halfpoint / 2;
                }
                else
                    w += N - j;

                F[i] = (double)w / (N*h);
                Bi += h;
            }

            double Ai = Math.Min(y_b, y_a); 
            Histogram = new LineSeries() { Title = "Статистический ряд"};
            Histogram.Points.Add(new DataPoint(Ai, 0));
            for (int i = 0; i < _n; i++)
            {
                Histogram.Points.Add(new DataPoint(Ai, F[i]));
                Ai += h;
                Histogram.Points.Add(new DataPoint(Ai, F[i]));
            }


            VariationFunction = new LineSeries();
            for (int i = 0; i < N; i++)
            {
                VariationFunction.Points.Add(new DataPoint(v[i], F[i]));
            }

            Ai = Math.Min(y_b, y_a); 
            PoligonFunction = new LineSeries() { Title = "Полигон" };
            PoligonFunction.Points.Add(new DataPoint(Ai, 0));
            for (int i = 0; i < _n - 1; i++)
            {
                PoligonFunction.Points.Add(new DataPoint(Ai+h/2, F[i]));

                Ai += h;
            }

            PoligonFunction.Points.Add(new DataPoint(y_a, F[_n-1]));

            

            Func<double, double> tF = (arg) =>
            {
                if (arg < -1)
                    return 0;
                else if (arg >= -1 / 5)
                    return 1;
                else
                    return (1.0 / (4 *arg*arg));
            };
            TheoreticalFunction = new FunctionSeries(tF, -1, -1.0 / 5, dx) { Title = "Теоретическая функция распределения" };




        }

    }
}
