using Android.Widget;
using System;
using System.IO;
using Android.OS;
using Android.App;

namespace Fun
{
	[Activity (Label = "Fun", MainLauncher = true, Icon = "@mipmap/icon")]
	public class MainActivity : ListActivity
	{
		public DataBase db;
		public ListView ingridientList;

		protected override void OnCreate (Bundle savedInstanceState)
		{
			base.OnCreate (savedInstanceState);

			SetContentView (Resource.Layout.Main);

			Button button = FindViewById<Button> (Resource.Id.myButton);
			
			button.Click += delegate {
				StartActivity (typeof(NewCoctail));
			};
			FillContent ();

		}

		void FillContent ()
		{
//			CoctailItem[] items = db.GetItems ();
//			ListAdapter = new ArrayAdapter<IngridientItem> (this, Resource.Id.ingridientList, items);
//			ingridientList =(ListView) FindViewById (Resource.Id.coctailImagelist);


			string [] items = new string[]{ "df", "fd", "fd" };
			ListAdapter = new ArrayAdapter<String> (this, Android.Resource.Layout.SimpleListItem1, items);

		}


//		void OnSelection (object sender, SelectedChangedEventArgs e)
//		{
//			
//		}
//
//		protected override void OnAppearing ()
//		{
//			ingridientList.ItemsSource = Repositories.db.GetItems ();
//			base.OnAppearing ();
//		}
//
//		// обработка нажатия кнопки добавления
//		private void CreateBook (object sender, EventArgs e)
//		{
//			this.Navigation.PushAsync (new AddPage ());
//		}


	}
}


