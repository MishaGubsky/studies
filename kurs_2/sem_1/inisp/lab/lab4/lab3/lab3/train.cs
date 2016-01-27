using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace lab3
{
    [Serializable] 
    [DataContract(Name = "train")]
    public class train:turn<carriage>
    {
        [DataMember(Name = "Numberoftrain")]
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

        [DataMember(Name = "Number_carriages")]
        public int number_carriages;
        public int Number_carriages
        {
            get
            {
                return number_carriages;
            }
            set
            {
                number_carriages = value;
            }
        }

        public train()
        {
        }

        public carriage[] Findcarrige(int find_number)
        {
            if(find_number <= this.number_carriages)
                return this.Where(x => (x.Number == find_number)).ToArray();
            else
                throw new ArgumentNullException();
        }
    }
}
