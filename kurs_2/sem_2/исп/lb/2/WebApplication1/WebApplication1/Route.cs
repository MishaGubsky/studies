using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace WebApplication1
{
    public class Route
    {
        public string NumberOfBus;

        public List<string> Stations;

        public Route()
        {
            Stations = new List<string>();
        }
    }
}