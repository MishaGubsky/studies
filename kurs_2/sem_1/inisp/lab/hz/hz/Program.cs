using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace hz
{
    class Program
    {
        static void Main(string[] args)
        {
            var words = "The quick brown fox jumps over the lazy dog".Split();
            var rnd = new Random();
            var text = Enumerable.Repeat(0, 1000)
            .Select(i => words[rnd.Next(words.Length)]);
            // using обеспечит корректное закрытие потоков
            using(Stream s = File.Create("compressed.bin"))
            {
                using(var ds = new DeflateStream(s, CompressionMode.Compress))
                {
                    using(TextWriter w = new StreamWriter(ds))
                    {
                        foreach(string word in text)
                        {
                            w.Write(word + " ");
                        }
                    }
                }
            }
            using(Stream s = File.OpenRead("compressed.bin"))
            {
                using(var ds = new DeflateStream(s, CompressionMode.Decompress))
                {
                    using(TextReader r = new StreamReader(ds))
                    {
                        Console.Write(r.ReadToEnd());
                    }
                }
            }
            Console.Read();
        }
    }
}
