using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;

namespace lab3
{
    class Serialize
    {
        public void SerialezeObject(train obj)
        {
            var formatter = new BinaryFormatter();
            using(Stream s = File.Create("train.dat"))
                formatter.Serialize(s, obj);
        }
        public train DeserialezeObject()
        {
            train _train=new train();
            var formatter = new BinaryFormatter();
            using(Stream s = File.OpenRead("train.dat"))
            {
                 _train= (train)formatter.Deserialize(s);
            }
            return _train;            
        }
        public void SerializeWithDataContract(train _train)
        {
            var ds = new DataContractSerializer(typeof(train));
            using(Stream s = File.Create("D:\\serialize.xml"))
                ds.WriteObject(s,_train);
        }
        public train DeserializeWithDataContract()
        {
            train _train = new train();
            var ds = new DataContractSerializer(typeof(train));
            using(Stream s = File.OpenRead("D:\\serialize.xml"))
                _train=(train)ds.ReadObject(s);
            return _train;
        }
    }
}
