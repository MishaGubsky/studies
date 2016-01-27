using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace lab3
{
    [DataContract(Name = "carriage")]
    public class carriage:turn<coupe>
    {
        [DataMember(Name = "Numberofcarriage")]
        public int number;
        public int Number
        {
            get
            {
                return number;
            }
            set
            {
                number = value;
            }
        }
        [DataMember(Name = "Number_coupes")]
        public int number_coupes;
        public int Number_coupes
        {
            get
            {
                return number_coupes;
            }
            set
            {
                number_coupes = value;
            }
        }

        public carriage(int number, int number_coupes)
        {
            Number = number;
            Number_coupes = number_coupes;
        }

        public coupe[] Findcoupe(int find_number)
        {
            if(find_number <= this.number_coupes)
                return this.Where(x => (x.Number == find_number)).ToArray();
            else
                throw new ArgumentNullException();
        }
    }
        
}
