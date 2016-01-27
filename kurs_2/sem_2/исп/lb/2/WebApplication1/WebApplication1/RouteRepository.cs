using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace WebApplication1
{
    public class RouteRepository:IDisposable
    {
        private static RouteRepository repository = new RouteRepository();
        private List<Route> routes = ReadFromXml();

        public static RouteRepository GetRepository()
        {
            return repository;
        }

        public IEnumerable<Route> GetAllRoute()
        {
            return routes;
        }

        public void AddRoute(Route route)
        {
            routes.Add(route);
        }

       
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }


        private static List<Route> ReadFromXml()
        {
            XDocument doc = XDocument.Load("D:\\routes.xml");
            XElement xml_list = doc.Root;
            List<Route> ListOfAllComposition = new List<Route>();
            foreach(XElement xml_route in xml_list.Elements())
            {
                Route newRoute = new Route();
                newRoute.NumberOfBus=xml_route.Element("NumberOfBus").Value;
                foreach(XElement xml_st in xml_route.Element("Stations").Elements())
                    newRoute.Stations.Add(xml_st.Value.ToString());
                ListOfAllComposition.Add(newRoute);
            }
            return ListOfAllComposition;

        } 
    }
}