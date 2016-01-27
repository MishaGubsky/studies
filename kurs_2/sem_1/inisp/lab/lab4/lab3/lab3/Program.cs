using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace lab3
{
    class Program  
    {
        static void Main(string[] args)
        {
            coupe coupe1 = new coupe(1,4);
            coupe coupe2 = new coupe(2,3);
            coupe coupe3 = new coupe(3, 3);
            coupe coupe4 = new coupe(4,4);
            coupe coupe5 = new coupe(5,2);

            carriage carriage = new carriage(1,5);
            carriage.add(coupe1);
            carriage.add(coupe2);
            carriage.add(coupe3);
            carriage.add(coupe4);
            carriage.add(coupe5);

            carriage carriage1 = new carriage(1, 1);
            carriage1.add(coupe1);

            carriage carriage2 = new carriage(2, 2);
            carriage2.add(coupe1);
            carriage2.add(coupe5);

            carriage carriage3 = new carriage(3, 3);
            carriage3.add(coupe1);
            carriage3.add(coupe3);
            carriage3.add(coupe4);

            train train = new train();
            train.add(carriage);
            train.add(carriage1);
            train.add(carriage2);
            train.add(carriage3);

            Serialize s = new Serialize();
            s.SerializeWithDataContract(train);

            train _train = new train();
            _train = s.DeserializeWithDataContract();
        }
    }
}
