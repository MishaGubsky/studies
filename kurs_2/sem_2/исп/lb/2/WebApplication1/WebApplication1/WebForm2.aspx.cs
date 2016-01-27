using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.ModelBinding;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class WebForm2:System.Web.UI.Page
    {
        protected string ShowRoute(string bus)
        {
            StringBuilder html = new StringBuilder();
            var Data = RouteRepository.GetRepository().GetAllRoute().Where(r => r.NumberOfBus == bus);
            foreach(var rtbus in Data)
            {
                for(int i = 0;i < rtbus.Stations.Count;i++)
                {
                    int j = rtbus.Stations.Count - i - 1;
                    html.Append(String.Format("<tr><td>{0}</td><td>{1}</td></tr>", rtbus.Stations[i], rtbus.Stations[j]));
                }
            }
            return html.ToString();
        }

        protected string ShowTerminals(string bus)
        {
            StringBuilder html = new StringBuilder();
            var Data = RouteRepository.GetRepository().GetAllRoute().Where(r => r.NumberOfBus == bus).First();
            string FL=Data.Stations.First() + '-' +Data.Stations.Last();
            string LF = Data.Stations.Last() + '-' + Data.Stations.First();
            html.Append(String.Format("<th>{0}</th><th>{1}</th>",FL, LF));
            return html.ToString();

        }

        protected void GetComments()
        {
            StringBuilder html = new StringBuilder();
            var Data = RepositoryOfComments.GetRepository().GetAllComments();
            foreach(var com in Data)
            {
                Panel1.Controls.Add(new Label(){Text='-'+com.NameUser, CssClass="LabelName"});
                Panel1.Controls.Add(new Panel());
                Panel1.Controls.Add(new Label(){Text =com.StrComment, CssClass="LabelStrComment"});
                Panel1.Controls.Add(new Panel());
            }          

        }   

        protected void Button1_Click(object sender, EventArgs e)
        {
                Comment comment = new Comment();
                comment.NameUser = Request.Form["nam"];
                comment.StrComment = Request.Form["com"];
                if((comment.NameUser != "") && (comment.StrComment != ""))
                    RepositoryOfComments.GetRepository().AddComment(comment);
                GetComments();
        }

        
    }
}