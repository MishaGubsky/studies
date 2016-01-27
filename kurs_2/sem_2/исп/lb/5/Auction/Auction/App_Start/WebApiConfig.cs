using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Cors;


namespace Auction
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            var cors = new EnableCorsAttribute("*", "*", "*");
            config.EnableCors(cors);
            config.Routes.MapHttpRoute(
                name :"DefaultApi",
                routeTemplate :"api/WebApi/{action}/{id}",
                defaults :new
                {
                    controller = "WebApi",
                    id = RouteParameter.Optional
                }
            );
        }
    }
}
