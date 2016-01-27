
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using WpfApplication1.Models;


namespace WpfApplication1
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        ParameterType _selected_parameter_type = ParameterType.ExpectedValue;

        public MainWindow()
        {
            InitializeComponent();
        }

        private void update_model_btn_Click(object sender, RoutedEventArgs e)
        {
            var app_model = this.DataContext as AppModel;
            if (app_model != null)
            {
                new Task(async () =>
                {
                    app_model.UpdateModel(_selected_parameter_type);

                    await Dispatcher.InvokeAsync(() =>
                    {
                        interval_to_n_plot.InvalidatePlot();
                        interval_to_alpha_plot.InvalidatePlot();
                    });

                }).Start();
            }
        }

        private void parameter_type_rb_Click(object sender, RoutedEventArgs e)
        {
            var radio_button = sender as RadioButton;
            if (radio_button != null)
                _selected_parameter_type = (ParameterType)Enum.Parse(typeof(ParameterType), radio_button.Tag.ToString());
        }
    }
}
