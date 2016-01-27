using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;

namespace player
{
    public class WorkWithXml
    {
        public static List<record> ListOfAllComposition;

        public static List<record> GetQueue()
        {
            return ListOfAllComposition;
        }

        public static void WriteToXml()
        {

           XElement xml_list= new XElement("records");
           foreach (var record in ListOfAllComposition)
			{
				XElement xml_record = new XElement("record");
					xml_record.Add(new XElement("artist", record.artist));
                    xml_record.Add(new XElement("name", record.name));
                    xml_record.Add(new XElement("duration", record.duration.TotalSeconds.ToString()));
                    xml_record.Add(new XElement("about", record.about));
                    


				xml_list.Add(new XElement(xml_record));
			}
                XDocument Doc=new XDocument(xml_list);
                Doc.Save("records.xml");
        }
        

        public static void ReadFromXml()
        {
            XDocument doc = XDocument.Load("records.xml");
            XElement xml_list = doc.Root;
            foreach(XElement xml_record in xml_list.Elements())
            {
               record newRecord = new record(xml_record.Element("artist").Value, xml_record.Element("name").Value,
                   new TimeSpan(10000000*int.Parse(xml_record.Element("duration").Value)), xml_record.Element("about").Value);

               if(ListOfAllComposition == null)
                   ListOfAllComposition = new List<record>();
                ListOfAllComposition.Add(newRecord);
            }
       
        } 

    }
}














                