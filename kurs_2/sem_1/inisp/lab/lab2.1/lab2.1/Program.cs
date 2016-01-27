using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab2._1
{




    class Program:Collection
    {
        static void Main(string[] args)
        {
            coupe coupe1 = new coupe(1,4);
            coupe coupe2 = new coupe(2,3);
            coupe coupe3 = new coupe(3, 3);
            coupe coupe4 = new coupe(4,4);
            coupe coupe5 = new coupe(5,2);
            turn<coupe> carriage = new turn<coupe>();
            carriage.add(coupe1);
            carriage.add(coupe2);
            carriage.add(coupe3);
            carriage.add(coupe4);
            carriage.add(coupe5);
            foreach(coupe c in carriage)
            {
                Console.WriteLine(c.Number.ToString()+"вагон, кол. пассажиров="+c.Number_passenger.ToString());
            }
            Console.ReadLine();
        }
    }
}
