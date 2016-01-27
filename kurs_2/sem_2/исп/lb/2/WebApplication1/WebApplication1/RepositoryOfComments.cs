using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication1
{
    public class RepositoryOfComments
    {
        private static RepositoryOfComments repository = new RepositoryOfComments();
        private List<Comment> ListOfComments = new List<Comment>();

        public static RepositoryOfComments GetRepository()
        {
            return repository;
        }

        
        public IEnumerable<Comment> GetAllComments()
        {
            return ListOfComments;
        }

        public void AddComment(Comment com)
        {
            ListOfComments.Add(com);
        }
    }
}