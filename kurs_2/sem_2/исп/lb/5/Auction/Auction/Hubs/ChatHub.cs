using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using Auction.Models;
using Auction.Controllers;

namespace Auction.Hubs
{
    public class Chat : Hub
    {
        // Отправка сообщений
        public void Send(string message, string name)
        {
                Clients.All.addMessage(name, message);
        }
    }
}