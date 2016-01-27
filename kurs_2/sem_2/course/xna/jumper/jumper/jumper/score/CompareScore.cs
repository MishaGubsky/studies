using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace WindowsGame1
{
    public class CompareScore
    {
        string filename = @"D:/score.txt";
        string[] records = File.ReadAllLines(@"D:/score.txt");
        string temp;
        string newscore;
        string curScore = "";
        string numbers = "0123456789";

        public string[] Score(string newscore)
        {
            temp = "      " + newscore;
            this.newscore = temp.Substring(temp.Length - 6, 6);
            int i;
            for(i = 0;i < 5;i++)
            {
                curScore = oldScore(records[i].Substring(3, 6));
                if(compare(curScore, this.newscore))
                {
                    int k = 4;
                    while(i < k)
                    {
                        records[k] = records[k].Substring(0, 3);
                        records[k] = records[k] + records[k - 1].Substring(3, 6);
                        k--;
                    }
                    records[i] = records[i].Substring(0, 3);
                    temp = records[i];
                    records[i] = records[i] + newscore + "      ";
                    break;
                }
            }
            writetofile(records);
            if(i < 5)
                records[i] = temp + newscore + " New Record";
            return records;
        }

        public string oldScore(string begin)
        {
            string newstr = "";
            for(int i = 0;i < 6;i++)
            {
                char c = begin[i];
                if(numbers.Contains(c))
                    newstr = newstr + c;
                else
                    newstr = ' ' + newstr;

            }
            return newstr;
        }

        void writetofile(string[] records)
        {
            File.WriteAllLines(filename, records);
        }

        bool compare(string cur, string newscor)
        {
            int more = string.CompareOrdinal(cur, newscor);
            if(more < 0)
                return true;
            else
                return false;
        }
    }
}
