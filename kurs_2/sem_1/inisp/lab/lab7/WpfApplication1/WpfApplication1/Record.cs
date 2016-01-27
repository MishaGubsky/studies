using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace WpfApplication1
{
    public class Record:INotifyPropertyChanged
    {
        private string name;
        private string artist;
        private string rating;
        private string duration;

        public Record()
        {return;}

        public Record(string _Artist, string _Name, string _Duration, string _Rating)
        {
            name = _Name;
            artist = _Artist;
            duration = _Duration;
            rating = _Rating;
        }
        public string Name
        {
            get { return name; }
            set { name = value; }
        }
        public string Artist
        {
            get
            {
                return artist;
            }
            set
            {
                artist = value;
            }
        }
        public string Duration
        {
            get
            {
                return duration;
            }
            set
            {
                duration = value;
            }
        }
        public string Rating
        {
            get
            {
                return rating;
            }
            set
            {
                rating = value;
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
    }
}
