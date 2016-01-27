<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm2.aspx.cs" Inherits="WebApplication1.WebForm2" %>

<!DOCTYPE html>

<head>
    
    <title>Bus Stations</title>
    
    <link rel="stylesheet" href="Styles.css" />
    

    

</head>
<body>
        <form id="form1" runat="server">
       <div class="times_table">	
			<div class="tt_h2_main">
				<div>
					<h2 style="text-align:center;">
						<a class="bus_tt" href="index.aspx">
								Маршруты автобусов 
						</a>
                        <p style="text-align: center; color:green; font-style:italic;">Автобус проходит по следующим остановкам</p>
					</h2>
				</div>
			</div>	
        </div>               
                        
            <div class="list_direction" >
                <table style="width:100%" color: #3672AD;">
                       <tr style="color: #3672AD;">
                        <%= ShowTerminals( Request.Params["per"])%>
                       </tr>
                  <tr style="color: #3672AD;">
                          <%= ShowRoute( Request.Params["per"])%>
                  </tr>
               </table>
            </div>
    <div class="comments">
        <p style="width: 186px"><b>Ваше имя:</b><br>
            <textarea id="nam" rows="1"  runat="server"></textarea>
            <asp:RequiredFieldValidator ControlToValidate="nam" CssClass="RequiredFilds" ID="RequiredFieldValidator1" runat="server" ErrorMessage="Введите Ваше имя" EnableClientScript="false"></asp:RequiredFieldValidator>
        </p>    
        <p style="width: 250px"><b>Комментарий</b><Br>
            <textarea id="com" rows="5"  runat="server"></textarea>
            <asp:RequiredFieldValidator ControlToValidate="com" CssClass="RequiredFilds" ID="RequiredFieldValidator2" runat="server" ErrorMessage="Введите комментарий" EnableClientScript="false"></asp:RequiredFieldValidator>
        </p>
        <p style="width: 97px; margin-left: 148px">
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Post" Width="96px" />
        </p>
        
       
         
     </div> 
    <div class="comments">    
        
        <asp:Panel ID="Panel1" runat="server">
        </asp:Panel>
        
    </div> 
        </form>
</body> 
</html>
   