using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace lab2._1
{
    class Workwithfiles:Collection
    {
        class workwithtextfiles
        {
        }
        class workwithbineryfile
        {
            public workwithbineryfile()
            {
            }
            public void writetofile(train stream)
            {
                using(Stream str=File.Create("myfile.bin"))
                {
                    using(var ds = new DeflateStream(str, CompressionMode.Compress))
                    {
                        using(var crypto=new CryptoStream())
                        var bw = new BinaryWriter(stream);
                    }
                    var fs = new FileStream("test.dat", FileMode.OpenOrCreate);
                }
            }
        }

    }
}
