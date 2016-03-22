using System;
using SQLite.Net.Attributes;

namespace Fun
{
	[Table ("Ingredient")]
	public class IngredientItem
	{
		[PrimaryKey, AutoIncrement]
		public int Id { get; set; }

		public string Name { get; set; }

		public int AlcoholCount { get; set; }
	}
}

