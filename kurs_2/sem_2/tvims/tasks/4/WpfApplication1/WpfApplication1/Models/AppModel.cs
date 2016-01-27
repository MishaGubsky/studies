using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;

namespace WpfApplication1.Models
{
    using OxyPlot;
    using OxyPlot.Series;

    enum ParameterType
    {
        ExpectedValue = 0,
        Variance = 1
    }

    partial class AppModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        public void ChangeProperty<T>(ref T field, T value, string property_name)
        {
            field = value;
            if (PropertyChanged != null)
                PropertyChanged(this, new PropertyChangedEventArgs(property_name));
        }

        protected int _n = 20;
        protected double _alpha = 0.05;
        protected double _point_estimation = 0;
        protected Interval<double> _interval_estimation = new Interval<double>(0, 0);
        protected Interval<double> _accurate_interval_estimation = new Interval<double>(0, 0);

        protected PlotModel _interval_to_alpha_dependency_plot = new PlotModel();
        protected PlotModel _interval_to_n_dependency_plot = new PlotModel();
        protected MyStatistics _statistics = new MyStatistics();

        public int N
        {
            get { return _n; }
            set { ChangeProperty<int>(ref _n, value, "N"); }
        }

        public double Alpha
        {
            get { return _alpha; }
            set { ChangeProperty<double>(ref _alpha, value, "Alpha"); }
        }

        public double ExactParameter
        {
            get;
            protected set;
        }

        public double PointEstimation
        {
            get { return _point_estimation; }
            set { ChangeProperty(ref _point_estimation, value, "PointEstimation"); }
        }

        public Interval<double> IntervalEstimation
        {
            get { return _interval_estimation; }
            set { ChangeProperty(ref _interval_estimation, value, "IntervalEstimation"); }
        }


        public Interval<double> AccurateIntervalEstimation
        {
            get { return _accurate_interval_estimation; }
            set { ChangeProperty(ref _accurate_interval_estimation, value, "AccurateIntervalEstimation"); }
        }


        public List<int> AvaliableN
        {
            get { return new List<int>() { 20, 30, 50, 70, 100, 150 }; }
        }

        public List<double> AvaliableAlpha
        {
            get { return new List<double>() { 0.01, 0.05, 0.1, 0.2, 0.5 }; }
        }

        public PlotModel IntervalToAlphaDependencyPlot
        {
            get { return _interval_to_alpha_dependency_plot; }
        }

        public PlotModel IntervalToNDependencyPlot
        {
            get { return _interval_to_n_dependency_plot; }
        }


        public AppModel()
        {
            IntervalToAlphaDependencyPlot.TitleFont = "Calibri";
            IntervalToAlphaDependencyPlot.TitleFontSize = 16;
            IntervalToAlphaDependencyPlot.TitleFontWeight = 105;

            IntervalToNDependencyPlot.TitleFont = "Calibri";
            IntervalToNDependencyPlot.TitleFontSize = 16;
            IntervalToNDependencyPlot.TitleFontWeight = 105;

            UpdateModel(ParameterType.ExpectedValue);
        }

        public void UpdateModel(ParameterType paremeter_type)
        {
            var x = _statistics.GenerateVariationArray(N);
            DistributionParameter p = null;
            switch (paremeter_type)
            {
                case ParameterType.ExpectedValue:
                    ExactParameter = MyStatistics.M;
                    p = new ExpectedValue();
                    break;

                case ParameterType.Variance:
                    ExactParameter = MyStatistics.D;
                    p = new Variance();
                    break;
            }

            PointEstimation = p.PointEstimation(x);
            IntervalEstimation = p.IntervalEstimation(x, Alpha);
            AccurateIntervalEstimation = p.IntervalEstimation(x, Alpha, MyStatistics.D);

            BuildIntervalToAlphaDependency(IntervalToAlphaDependencyPlot, p, x);
            BuildIntervalToNDependency(IntervalToNDependencyPlot, p);
        }

        public void BuildIntervalToAlphaDependency(PlotModel plot, DistributionParameter p, double[] x)
        {
            LineSeries interval_series = new LineSeries() { Title = "Величина интервала " + p.Name };
            LineSeries accurate_interval_series = new LineSeries() { Title = "Величина интервала " + p.Name + "(известные параметры)" };

            plot.Title = "Зависимость величины интервала от доверительной вероятности";
            plot.Series.Clear();
            plot.Series.Add(interval_series);
            plot.Series.Add(accurate_interval_series);
            foreach (var alpha in AvaliableAlpha)
            {
                var i = p.IntervalEstimation(x, alpha);
                var ai = p.IntervalEstimation(x, alpha, (p is Variance) ? MyStatistics.M : MyStatistics.D);
                interval_series.Points.Add(new DataPoint(alpha, Math.Abs(i.End - i.Start)));
                accurate_interval_series.Points.Add(new DataPoint(alpha, Math.Abs(ai.End - ai.Start)));
            }
        }

        public void BuildIntervalToNDependency(PlotModel plot, DistributionParameter p)
        {
            LineSeries interval_series = new LineSeries() { Title = "Величина интервала " + p.Name };
            LineSeries accurate_interval_series = new LineSeries() { Title = "Величина интервала " + p.Name + "(известные параметры)" };


            plot.Title = "Зависимость величины интервала от размера выборки";
            plot.Series.Clear();
            plot.Series.Add(interval_series);
            plot.Series.Add(accurate_interval_series);
            foreach (var n in AvaliableN)
            {
                var xx = _statistics.GenerateVariationArray(n);
                var i = p.IntervalEstimation(xx, Alpha);
                var ai = p.IntervalEstimation(xx, Alpha, (p is Variance) ? MyStatistics.M : MyStatistics.D);
                interval_series.Points.Add(new DataPoint(n, Math.Abs(i.End - i.Start)));
                accurate_interval_series.Points.Add(new DataPoint(n, Math.Abs(ai.End - ai.Start)));
            }
        }
    }
}
