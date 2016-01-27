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

        public double[] VariationArray { get; private set; } 
        public PlotModel PlotViewModel { get; private set; }
        public PlotModel PlotViewModel_1 { get; private set; }
        public LineSeries Histogram { get; private set; }
        public LineSeries PoligonFunction { get; set; }
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
            this.PlotViewModel.Axes.Add(new LinearAxis(AxisPosition.Left, 0, 7.5));

            this.PlotViewModel_1 = new PlotModel();
            this.PlotViewModel_1.LegendPlacement = LegendPlacement.Outside;
            this.PlotViewModel_1.LegendPosition = LegendPosition.BottomLeft;
            this.PlotViewModel_1.LegendFontSize = 16;
            this.PlotViewModel_1.LegendFont = "Calibri";
            this.PlotViewModel_1.Axes.Add(new LinearAxis(AxisPosition.Bottom, -1, -1.0 / 5));
            this.PlotViewModel_1.Axes.Add(new LinearAxis(AxisPosition.Left, 0, 7.5));

            N = 400;
            UpdateModel();
        }

        public void UpdateModel()
        {
            GetStatistic();
            this.PlotViewModel.Series.Clear();
            this.PlotViewModel.Series.Add(Histogram);
            this.PlotViewModel.Series.Add(TheoreticalFunction);
            this.PlotViewModel.Series.Add(PoligonFunction);
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

                double[] F = new double[N];
                int w = N / _n;
                double Ai = v[0], Bi;
                int j = 0;

                for (int i = 1; i < _n; i++)
                {
                    Bi =(double) (v[w* i] + v[(w * i)+1]) / 2;
                    double _h = Bi - Ai;
                    Ai = Bi;

                    F[i] = (double) w / (N * _h);
                }

            VariationArray = v;

            Histogram = new LineSeries() { Title = "Гистограмма" };
            Histogram.Points.Add(new DataPoint(v[0], 0));

            for (int i = 0; i < _n; i++)
            {
                Histogram.Points.Add(new DataPoint(Ai, F[i]));
                Ai = (double)(v[w * i] + v[(w * i) + 1]) / 2; 
                Histogram.Points.Add(new DataPoint(Ai, F[i]));
            }
            Histogram.Points.Add(new DataPoint(y_a, F[_n-1]));




            VariationFunction = new LineSeries();
            for (int i = 0; i < N; i++)
            {
                VariationFunction.Points.Add(new DataPoint(v[i], F[i]));
            }


            



            Ai = v[0];
            PoligonFunction = new FunctionSeries() { Title = "Полигон"};
            PoligonFunction.Points.Add(new DataPoint(Ai, 0));
            for (int i = 0; i < _n-1; i++)
            {
                Bi = (double)(v[w * i] + v[(w * i) + 1]) / 2;
                PoligonFunction.Points.Add(new DataPoint((Bi+Ai)/2, F[i]));
                Ai = Bi;
            }
            Bi = y_a;
            PoligonFunction.Points.Add(new DataPoint((Bi + Ai) / 2, F[_n-1]));
            PoligonFunction.Points.Add(new DataPoint(Bi, F[_n - 1]));

            Func<double, double> tF = (arg) =>
            {
                if (arg < -1)
                    return 0;
                else if (arg >= -1 / 5)
                    return 1;
                else
                    return (1.0 / (4 * arg * arg) - 0.2);
            };
            TheoreticalFunction = new FunctionSeries(tF, -1, -1.0 / 5, dx) { Title = "Теоретическая функция распределения"};
        
           
            }

    }
}
