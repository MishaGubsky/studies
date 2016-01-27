using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Xml.Linq;

namespace WpfApplication1
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow:Window
    {
        ObservableCollection<Record> AllRecords;
        public MainWindow()
        {    
            
            InitializeComponent();
            AllRecords=new ObservableCollection<Record>();
            
            AllRecords.Add(new Record("Evanescence","My heart is broken","04:29","4"));
            AllRecords.Add(new Record("Король и Шут", "Энди Кауфман", "02:32", "2"));
            ListView1.ItemsSource = AllRecords;
        }

        

        




        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            if (Check())
            {
                AllRecords.Add(new Record(TextBox2.Text, TextBox1.Text, TextBox3.Text, TextBox4.Text));
                MessageBox.Show("Complite!");
            }
        }

        private bool Check()
        {
            if ((TextBox4.Text != "") && (TextBox3.Text != "") && (TextBox2.Text != "") && (TextBox1.Text != ""))
            {
                int k = 0;
                bool ch = true;
                if (TextBox3.Text.Length == 5)
                {
                    if (TextBox3.Text[2] != ':')
                    {
                        MessageBox.Show("Check 3 field");
                        return false;
                    }
                    if((TextBox3.Text[0] < '0') || (TextBox3.Text[0] > '6') || (TextBox3.Text[1] < '0') || (TextBox3.Text[1] > '9')
                        || (TextBox3.Text[3] < '0') || (TextBox3.Text[3] > '6') || (TextBox3.Text[4] < '0') || (TextBox3.Text[4] > '9'))
                    {
                        MessageBox.Show("Check 3 field");
                        return false;
                    }
                }
                else
                {
                    MessageBox.Show("Check 3 field");
                    return false;
                }
                int b=0;
                try{b = int.Parse(TextBox4.Text);}
                catch{};
                
                if ((b < 1) || (b > 5))
                {
                    MessageBox.Show("Check 4 field");
                    return false;
                }
                return true;
            }
            else
            {
                MessageBox.Show("Wrong data");
                return false;
            }
        }

        private void ListView1_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if(ListView1.SelectedIndex == -1)
                return;
                Record select = AllRecords[ListView1.SelectedIndex];
                TextBox1.Text = select.Artist;
                TextBox2.Text = select.Name;
                TextBox3.Text = select.Duration;
                TextBox4.Text = select.Rating;
        }

        private void ChangeRecord_Click(object sender, RoutedEventArgs e)
        {

                
                if (Check())
                {
                    AllRecords.RemoveAt(ListView1.SelectedIndex);
                    AllRecords.Add(new Record(TextBox1.Text, TextBox2.Text, TextBox3.Text, TextBox4.Text));
                    TextBox1.Clear();
                    TextBox2.Clear();
                    TextBox3.Clear();
                    TextBox4.Clear();
                    MessageBox.Show("Complite!");
                }
            
        }

        private void DeliteRecord_Click(object sender, RoutedEventArgs e)
        {
            AllRecords.RemoveAt(ListView1.SelectedIndex);
            TextBox1.Clear();
            TextBox2.Clear();
            TextBox3.Clear();
            TextBox4.Clear();
            MessageBox.Show("Complite!");
        }

        private void SaveRecord_Click(object sender, RoutedEventArgs e)
        {
            if (Directive.Text != "")
            {
                try
                {
                    XDocument doc = new XDocument();
                    XElement root = new XElement("Root");
                    doc.Add(root);
                    foreach (var rec in AllRecords)
                    {
                        XElement Xrec = new XElement("Record");
                        Xrec.Add(new XElement("Artist", rec.Artist));
                        Xrec.Add(new XElement("Name", rec.Name));
                        Xrec.Add(new XElement("Duration", rec.Duration));
                        Xrec.Add(new XElement("Rating", rec.Rating));
                        root.Add(Xrec);
                    }
                    if (Path.GetExtension(Directive.Text) != ".xml")
                        Directive.Text = Directive.Text + ".xml";
                    doc.Save(Directive.Text);
                    MessageBox.Show("Complite!!");
                } catch
                {
                    MessageBox.Show("check your directive");
                }
            }
            else
            {
                MessageBox.Show("enter directive");
            }

        }

        private void OpenFile_Click(object sender, RoutedEventArgs e)
        {

            if(Directive.Text != "")
            {
                try
                {
                    XDocument doc = XDocument.Load(Directive.Text);
                    XElement root = doc.Element("Root");
                    foreach(var el in root.Elements())
                    {
                        AllRecords.Add(new Record((string)el.Element("Artist").Value,
                            (string)el.Element("Name").Value,
                            (string)el.Element("Duration").Value,
                            (string)el.Element("Rating").Value));
                    }
                } catch
                {
                    MessageBox.Show("check your directive");
                }
            } else
            {
                MessageBox.Show("enter directive");
            }
        }

        
    }
}
