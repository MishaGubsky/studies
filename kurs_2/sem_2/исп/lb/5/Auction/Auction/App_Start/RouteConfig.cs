using Auction.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Auction
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name :"Default",
                url :"{controller}/{action}/{id}",
                defaults :new
                {
                    controller = "Home", action = "Index", id = UrlParameter.Optional
                },
                constraints: new
                {
                    myConstraint = new CustomConstraint("/Lot/Index/")
                });

            routes.MapRoute(
                name: "route_Admin",
                url: "Admin/{action}/{id}",
                defaults: new
                {
                    controller = "Home",
                    action = "Index",
                    id = UrlParameter.Optional
                },
                constraints: new { httpMethod = new HttpMethodConstraint("GET") }
                );
            routes.MapRoute(
                name: "route_Lot",
                url: "Lot/{action}/{id}",
                defaults :new
                {
                    controller = "List", action = "ViewList", id=UrlParameter.Optional
                });
        }
    }
}