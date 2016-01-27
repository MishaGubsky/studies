<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="WebApplication1.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Routes</title>
    <link rel="stylesheet" href="Styles.css" />
</head>
    <form id="form1" runat="server">
        <body>
        <a href="#" class="bus_tt">Маршруты автобусов</a>
        <div class="shell" style="padding: 0px 8.5px 33px">
               <div class="honeycombs ">
                <div class="honeycomb" title="Маршрут автобусa №1">
                    <a href="WebForm2.aspx?per=1">
                     <img src="/img/empty.png" border="0" usemap="#route1" >
					    <div class="text-field">1</div>
                               <map name="route1" id="Map1">                              
						            <area shape="poly" coords="20,64,3,33,19,4,53,3,71,34,53,65"/>
                               </map>
					</a>   
					     

			    </div>
                <div class="honeycomb" title="Маршрут автобусa №2">
                    <a href="WebForm2.aspx?per=2">
									    <img src="/img/empty.png" border="0" usemap="#route2">
									    <div class="text-field">
										    2
									    </div>
									    <map name="route2" id="route2">
										    <area shape="poly" coords="20,64,3,33,19,4,53,3,71,34,53,65"/>
									    </map>
                        </a>
                </div>
                <div class="honeycomb" title="Маршрут автобусa №3">
                    <a href="WebForm2.aspx?per=3">
									    <img src="/img/empty.png" border="0" usemap="#route3">
									    <div class="text-field">
										    3
									    </div>
                        <map name="route3" id="Map3">
										    <area shape="poly" coords="20,64,3,33,19,4,53,3,71,34,53,65"/>
									    </map>
                        </a>
                </div>
		    </div>	
         </div>
</body>
    </form>
</html>
