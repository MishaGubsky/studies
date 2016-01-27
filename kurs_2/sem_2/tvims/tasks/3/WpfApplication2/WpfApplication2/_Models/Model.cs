using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OxyPlot;
using OxyPlot.Axes;
using OxyPlot.Series;
using WpfApplication2._Models;
using System.ComponentModel;


namespace WpfApplication2.Models
{
    class Model : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        public void ChangeProperty<T>(ref T property, T value, string property_name)
        {
            property = value;
            if (this.PropertyChanged != null)
                this.PropertyChanged(this, new PropertyChangedEventArgs(property_name));
        }


        public const double a = -6, b = -2, y_a=-1.0/5, y_b=-1, dx=0.001;


        public string _result_message = "";
        public string Result
        {
            get { return _result_message; }
            protected set { ChangeProperty<string>(ref _result_message, value, "Result"); }
        }
        public int N { get; set; }
        public PlotModel PlotViewModel { get; private set; }
        public PlotModel PlotViewModel_1 { get; private set; }
        public LineSeries Histogram { get; set; }
        public FunctionSeries NormalFunction { get; private set; }
        public FunctionSeries ExponentialFunction { get; private set; }
        public FunctionSeries UniformFunction { get; private set; }

        public FunctionSeries MyFunction { get; private set; }
        
         

        public Model()
        {
            this.PlotViewModel = new PlotModel();
            this.PlotViewModel.LegendPlacement = LegendPlacement.Outside;
            this.PlotViewModel.LegendPosition = LegendPosition.BottomLeft;
            this.PlotViewModel.LegendFontSize = 16;
            this.PlotViewModel.LegendFont = "Calibri";
            this.PlotViewModel.Axes.Add(new LinearAxis(AxisPosition.Bottom, -1, -1.0 / 5));
            this.PlotViewModel.Axes.Add(new LinearAxis(AxisPosition.Left, 0, 1));

            /*this.PlotViewModel_1 = new PlotModel();
            this.PlotViewModel_1.LegendPlacement = LegendPlacement.Outside;
            this.PlotViewModel_1.LegendPosition = LegendPosition.BottomLeft;
            this.PlotViewModel_1.LegendFontSize = 16;
            this.PlotViewModel_1.LegendFont = "Calibri";
            this.PlotViewModel_1.Axes.Add(new LinearAxis(AxisPosition.Bottom, -1, -1.0 / 5));
            this.PlotViewModel_1.Axes.Add(new LinearAxis(AxisPosition.Left, 0, 7.5));*/

            N = 200;
            UpdateModel();
        }

        public void UpdateModel()
        {
            GetStatistic();
            this.PlotViewModel.Series.Clear();
            this.PlotViewModel.Series.Add(Histogram);
            this.PlotViewModel.Series.Add(NormalFunction);
            this.PlotViewModel.Series.Add(ExponentialFunction);
            this.PlotViewModel.Series.Add(UniformFunction);
            this.PlotViewModel.Series.Add(MyFunction);
            
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
            if (N <= 100)
                _n = (int)Math.Sqrt(N);
            else
                _n = (int)(4 * Math.Log(N));


            

            double[] F = new double[N];
            for (int i = 0; i < N; i++)
            {
                int w = 0;
                for (int j = 0; j < N; j++)
                    if (v[i] == v[j]) w++;

                F[i] = (double)w / N;
                if (i > 0) F[i] += F[i - 1];
            }
            Histogram = new LineSeries() { Title = "Эмпирическая функция распределения", Color=OxyColors.Green };
            for (int i = 0; i < N; i++)
            {
                Histogram.Points.Add(new DataPoint(v[i], (i > 0) ? Math.Round(F[i - 1],1) : 0));
                Histogram.Points.Add(new DataPoint(v[i], Math.Round(F[i], 1)));
            }


            NormalDistributon _norm = new NormalDistributon(v);
            Func<double, double> tf = (arg) =>
            {
                if (arg < -1)
                    return 0;
                else if (arg >= -1 / 5)
                    return 1;
                else
                {
                    return _norm.Function(arg);
                }
            };
            NormalFunction = new FunctionSeries(tf, -1, -1.0 / 5, dx) { Title = "Нормальный закон распределения", Color=OxyColors.Orange };





            ExponentialDistribution _exp = new ExponentialDistribution(v);
            Func<double, double> tf1 = (arg) =>
            {
                if (arg < -1)
                    return 0;
                else if (arg >= -1 / 5)
                    return 1;
                else
                {
                    return _exp.Function(arg);
                }
            };
            ExponentialFunction = new FunctionSeries(tf1, -1, -1.0 / 5, dx) { Title = "Экспоненциальный закон распределения", Color=OxyColors.Plum};





            MyDistribution _myfun = new MyDistribution();
            Func<double, double> tf3 = (arg) =>
            {
                if (arg < -1)
                    return 0;
                else if (arg >= -1 / 5)
                    return 1;
                else
                {
                    return _myfun.Function(arg);
                }
            };
            MyFunction = new FunctionSeries(tf3, -1, -1.0 / 5, dx) { Title = "Теоретическая функция распределения", Color=OxyColors.Red };




            UniformDistribution _uni = new UniformDistribution(v);
            Func<double, double> tf2 = (arg) =>
            {
                if (arg < -1)
                    return 0;
                else if (arg >= -1 / 5)
                    return 1;
                else
                {
                    return _uni.Function(arg);
                }
            };
            UniformFunction = new FunctionSeries(tf2, -1, -1.0 / 5, dx) { Title = "Равномерный закон распределения", Color=OxyColors.Blue };




////////////////////////////////////////////////////////////////////////////
            double[] _pirsonAnswers = new double[4];
            Pirson _pirson = new Pirson();
            _pirsonAnswers[0] = _pirson._Pirson(v, _norm);
            _pirsonAnswers[1] = _pirson._Pirson(v, _exp);
            _pirsonAnswers[2] = _pirson._Pirson(v, _uni);
            _pirsonAnswers[3] = _pirson._Pirson(v, _myfun);

            ////////////////////////////////////////

            int _N1=30;

            double[] y1 = new double[_N1];
            for (int i = 0; i < 30; i++)
            {
                double ksi = rand.NextDouble();
                double x = ksi * (b - a) + a;
                y1[i] = 1 / (x + 1);
            }
            v = y1.OrderBy((x) => x).ToArray();

            double[] _colmoAnswers = new double[4];
            Colmogorov _colmo = new Colmogorov();
            _colmoAnswers[0] = _colmo._Colmogorov(v, _norm);
            _colmoAnswers[1] = _colmo._Colmogorov(v, _exp);
            _colmoAnswers[2] = _colmo._Colmogorov(v, _uni);
            _colmoAnswers[3] = _colmo._Colmogorov(v, _myfun);

            ////////////////////////////////////////////////////////////////////////

            int _N2 = 50;

            double[] y2 = new double[_N2];
            for (int i = 0; i < 50; i++)
            {
                double ksi = rand.NextDouble();
                double x = ksi * (b - a) + a;
                y2[i] = 1 / (x + 1);
            }
            v = y2.OrderBy((x) => x).ToArray();


            double[] _mizesAnswers = new double[4];
            Mizes _mizes = new Mizes();
            _mizesAnswers[0] = _mizes._Mizes(v, _norm);
            _mizesAnswers[1] = _mizes._Mizes(v, _exp);
            _mizesAnswers[2] = _mizes._Mizes(v, _uni);
            _mizesAnswers[3] = _mizes._Mizes(v, _myfun);


            string[] answerString = { "-Нормальный з.р. ",
                                        "-Экспоненциальный з.р. ",
                                            "-Равномерный з.р. ",
                                            "-Теоретическую ф.р. "
                                    };
            
            for(int i=0; i<4;i++)
            {
                bool _yes = false;
                if (_pirsonAnswers[i] != 0)
                {
                    answerString[i] += "критерий Пирсона не отклоняет с вероятностью " +
                        _pirsonAnswers[i].ToString() + ' ';
                    _yes = true;
                }
                if (_colmoAnswers[i] != 0)
                {
                    if(_yes)
                    {
                        answerString[i] += ",\n";
                    }
                    answerString[i] += "критерий Колмогорова не отклоняет с вероятностью " +
                        _colmoAnswers[i].ToString() + ' ';
                    _yes = true;
                }
                if (_mizesAnswers[i] != 0)
                {

                    if (_yes)
                    {
                        answerString[i] += ",\n";
                    }
                    answerString[i] += "критерий Мизеса не отклоняет с вероятностью " +
                    _mizesAnswers[i].ToString();
                }
                if ((_mizesAnswers[i] == 0) && (_colmoAnswers[i] == 0) && (_pirsonAnswers[i] == 0))
                    answerString[i] += "ни один из критериев не подтверждает";

                answerString[i] += ";\n";
            }

            this.Result="";
            this.Result = answerString.Aggregate((working,next)=>next+working);

            
        }
    }
}
