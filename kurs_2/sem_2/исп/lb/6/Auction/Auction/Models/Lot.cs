using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Auction.Models
{
    public class Lot
    {
        public int Id { get; set; }
        [Required]
        [Display(Name = "Название")]
        public string Name { get; set; }
        [Required]
        [Display(Name = "Описание")]
        public string Description { get; set; }
        [DataType(DataType.Date)]
        //[RegularExpression(@"[0-9]+\.[0-9]+\.[0-9]+", ErrorMessage = "Некорректная дата")]
        public DateTime ExpirationDateTime { get; set; }
        [Required]
        [Display(Name = "Цена")]
        public int Price { get; set; }
    }
}