using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Media;


namespace WindowsGame1
{
    /// <summary>
    /// This is a game component that implements IUpdateable.
    /// </summary>
    public class Screen:Microsoft.Xna.Framework.DrawableGameComponent
    {
        public SpriteBatch sprBatch;
        public Screen(Game game)
            : base(game)
        {
            Visible = false;
            Enabled = false;
            //получим объект SpriteBatch
            sprBatch = (SpriteBatch)Game.Services.GetService(typeof(SpriteBatch));
            // TODO: Construct any child components here
        }

        /// <summary>
        /// Allows the game component to perform any initialization it needs to before starting
        /// to run.  This is where it can query for any required services and load content.
        /// </summary>
        public void Show()
        {
            Visible = true;
            Enabled = true;
        }
        //Процедура для скрытия и отключения объекта
        public void Hide()
        {
            Visible = false;
            Enabled = false;
        }
    }
}
