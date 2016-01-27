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
using WpfApplication2.Models;

namespace WpfApplication2
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            list_view.Items.Refresh();
        }

        private void DrawPlotButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var model = ((Model)this.DataContext);
                new Task(async () =>
                {
                    model.UpdateModel();
                    await Dispatcher.InvokeAsync(() =>
                    {
                        plot_view.InvalidatePlot(true);
                        list_view.Items.Refresh();
                    });
                }).Start();
            }
            catch { }
        }

    }
}
