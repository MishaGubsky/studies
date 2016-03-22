using System;
using System.IO;
using System.Collections.Generic;
using System.Xml.Serialization;

namespace Fun
{
	[Serializable]
	[XmlRoot("DataBase")]
	public class XmlContainer
	{
		[XmlArray("Coctails")]
		[XmlArrayItem("Coctail")]
		public List<CoctailItem> Coctails = new List<CoctailItem>();

		[XmlArray("Ingredients")]
		[XmlArrayItem("Ingredient")]
		public List<IngredientItem> Ingredients = new List<IngredientItem>();

	}
}

