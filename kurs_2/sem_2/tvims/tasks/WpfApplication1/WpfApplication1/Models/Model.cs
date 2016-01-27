using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
using OxyPlot;
using OxyPlot.Axes;
using OxyPlot.Series;


namespace WpfApplication1.Models
{
    class Model:INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        public void SetProperty<T>(ref T field, T value, string property_name)
        {
            field = value;
            if(PropertyChanged!=null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(property_name));
            }
        }


        public const double a = -6, b =-2, dx = 0.001;

        public int N { get; set; }
        public PlotModel PlotViewModel { get; private set; }
        public double[] VariationArray { get; private set; } 
        public LineSeries EmpiricalFunction { get ; private set; }
        public FunctionSeries TheoreticalFunction { get; private set; }

        
        public LineSeries VarFunction;
        public LineSeries VariationFunction { 
            get { return VarFunction;}  
            set { SetProperty(ref VarFunction, value, "VariationFunction"); } 
        }

        public Model()
        {
            this.PlotViewModel = new PlotModel();
            this.PlotViewModel.LegendPlacement = LegendPlacement.Outside;
            this.PlotViewModel.LegendPosition = LegendPosition.BottomLeft;
            this.PlotViewModel.LegendFontSize = 16;
            this.PlotViewModel.LegendFont = "Calibri";
            this.PlotViewModel.Axes.Add(new LinearAxis(AxisPosition.Bottom, -1, -1.0/5));
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
                y[i] = 1/(x+1);
            }

            double[] v = y.OrderBy((x) => x).ToArray();
            double[] F = new double[N];
            for (int i = 0; i < N; i++)
            {
                int w = 0;
                for (int j = 0; j < N; j++)
                    if (v[i] == v[j]) w++;

                F[i] = (double)w / N;
                if (i > 0) 
                    F[i] += F[i - 1];
            }

            VariationFunction = new LineSeries();
            for (int i = 0; i < N; i++)
            {
                VariationFunction.Points.Add(new DataPoint(v[i], Math.Round(F[i],1)));
            }

            EmpiricalFunction = new LineSeries() { Title = "Эмпирическая функция распределения"};
            for (int i = 0; i < N; i++)
            {
                EmpiricalFunction.Points.Add(new DataPoint(v[i], (i > 0) ? Math.Round(F[i - 1], 1) : 0));
                EmpiricalFunction.Points.Add(new DataPoint(v[i], Math.Round(F[i], 1)));
            }


            Func<double, double> tF = (arg) => 
            {
                if (arg < -1) 
                    return 0;
                else if (arg >= -1/5) 
                    return 1;
                else 
                    return (1.0/(4*Math.Abs(arg))-0.25);
            };
            TheoreticalFunction = new FunctionSeries(tF, -1, -1.0/5, dx) { Title = "Теоретическая функция распределения" };
        }

    }
}
