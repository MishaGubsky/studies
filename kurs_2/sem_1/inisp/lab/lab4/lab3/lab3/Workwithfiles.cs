using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace lab3
{
    class Workwithfiles
    {

            
        
            public void writetofile(train stream)
            {
                RijndaelManaged rijmanaged = new RijndaelManaged();
                byte[] key = { 0x17, 0x54, 0x03, 0x34, 0x05, 0x63, 0x51, 0x48, 0x29, 0x15, 0x11 };
                byte[] iv = { 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16 };

                FileInfo file = new FileInfo("D:\\file.txt");
                if(file.Exists == false)
                {
                    file.Create();
                }
                using(Stream f = file.Create())
                {
                    using(var ds = new DeflateStream(f, CompressionMode.Compress))
                    {
                        using(var crypto = new CryptoStream(ds, rijmanaged.CreateEncryptor(key, iv),
                            CryptoStreamMode.Write))
                        {
                            using(TextWriter bw = new StreamWriter(crypto))
                            {
                                bw.WriteLine(stream.number);
                                bw.WriteLine(stream.number_carriages);
                                foreach(var c in stream)
                                {
                                    bw.WriteLine(c.number);
                                    bw.WriteLine(c.number_coupes);
                                    foreach(var s in c)
                                    {
                                        bw.WriteLine(s.number);
                                        bw.WriteLine(s.number_passenger);
                                    }
                                }
                            }
                            crypto.Close();
                        }
                    }
                }
            }
            public train readfromfile(train stream)
            {
                RijndaelManaged rijmanaged = new RijndaelManaged();
                byte[] key = { 0x17, 0x54, 0x03, 0x34, 0x05, 0x63, 0x51, 0x48, 0x29, 0x15, 0x11 };
                byte[] iv = { 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16 };


                using(Stream f = File.OpenRead("D:\\file.txt"))
                {
                    using(var ds = new DeflateStream(f, CompressionMode.Decompress))
                    {
                        using(var crypto = new CryptoStream(ds, rijmanaged.CreateDecryptor(key, iv),
                            CryptoStreamMode.Read))
                        {
                            using(TextReader bw = new StreamReader(crypto))
                            {
                                stream.number = int.Parse(bw.ReadLine());
                                stream.number_carriages = int.Parse(bw.ReadLine());
                                for(int i = 0;i < stream.number_carriages;i++)
                                {
                                    int number, number_coupes;
                                    number = int.Parse(bw.ReadLine());
                                    number_coupes = int.Parse(bw.ReadLine());
                                    carriage newcar = new carriage(number, number_coupes);
                                    for(int j = 0;j < newcar.number_coupes;j++)
                                    {
                                        int numberof, number_passenger;
                                        numberof = int.Parse(bw.ReadLine());
                                        number_passenger = int.Parse(bw.ReadLine());
                                        coupe newcoupe = new coupe(numberof, number_passenger);
                                        newcar.add(newcoupe);
                                    }
                                    stream.add(newcar);
                                }
                            }
                        }
                    }
                }
                return stream;
            }


            
            public train readfrombinaryfile(train stream)
            {
                RijndaelManaged rijmanaged = new RijndaelManaged();
                byte[] key = { 0x17, 0x54, 0x03, 0x34, 0x05, 0x63, 0x51, 0x48, 0x29, 0x15, 0x11 };
                byte[] iv = { 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16 };

                using(Stream str = File.OpenRead("myfile.bin"))
                {
                    using(var ds = new DeflateStream(str, CompressionMode.Decompress))
                    {
                        using(var crypto = new CryptoStream(ds, rijmanaged.CreateDecryptor(key, iv),
                            CryptoStreamMode.Read))
                        {
                            using(var f = new BinaryReader(crypto))
                            {
                                stream.number = f.ReadInt32();
                                stream.number_carriages = f.ReadInt32();
                                for(int i = 0;i < stream.number_carriages;i++)
                                {
                                    int number,number_coupes;
                                    number = f.ReadInt32();
                                    number_coupes=f.ReadInt32();
                                    carriage newcar = new carriage(number,number_coupes);
                                    for(int j = 0;j < newcar.number_coupes;j++)
                                    {
                                        int numberof, number_passenger;
                                        numberof=f.ReadInt32();
                                        number_passenger=f.ReadInt32();
                                        coupe newcoupe = new coupe(numberof, number_passenger);
                                        newcar.add(newcoupe);
                                    }
                                    stream.add(newcar);
                                }
                            }
                        }
                    }
                }
                return stream;
            }
            public void writetobinaryfile(train stream)
            {
                RijndaelManaged rijmanaged = new RijndaelManaged();

                byte[] key = { 0x17, 0x54, 0x03, 0x34, 0x05, 0x63, 0x51, 0x48, 0x29, 0x15, 0x11 };
                byte[] iv = { 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16 };
       
                using(Stream str=File.Create("myfile.bin"))
                {
                    using(var ds = new DeflateStream(str, CompressionMode.Compress))
                    {
                        using(var crypto = new CryptoStream(ds, rijmanaged.CreateEncryptor(key, iv),
                            CryptoStreamMode.Write))
                        {
                            using(var bw = new BinaryWriter(crypto))
                            {
                                bw.Write(stream.number);
                                bw.Write(stream.number_carriages);
                                foreach(var c in stream)
                                {
                                    bw.Write(c.number);
                                    bw.Write(c.number_coupes);
                                    foreach(var s in c)
                                    {
                                        bw.Write(s.number);
                                        bw.Write(s.number_passenger);
                                    }
                                }
                            }
                            crypto.Close();
                        }  
                    }
                }
            }


    }
}
