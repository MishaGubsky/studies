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
    public class BasClass:Microsoft.Xna.Framework.DrawableGameComponent
    {
        Texture2D sprTextureleft;
        Texture2D sprTextureright;
        Texture2D text;
        public Vector2 sprPosition;
        public Rectangle sprRectangle;
        bool tor;
        Games game;
        public BasClass(Game game1, Games game, ref Texture2D _sprTexture, ref Texture2D _sprTexture2, Vector2 _sprPosition, Rectangle _sprRectangle)
            : base(game1)
        {
            this.game = game;
            this.tor = game.last;
            sprTextureleft = _sprTexture;
            sprTextureright = _sprTexture2;
            sprPosition = _sprPosition;
            sprRectangle = _sprRectangle;
            // TODO: Construct any child components here
        }

        /// <summary>
        /// Allows the game component to perform any initialization it needs to before starting
        /// to run.  This is where it can query for any required services and load content.
        /// </summary>
        public override void Initialize()
        {
            // TODO: Add your initialization code here

            base.Initialize();
        }

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
        /// <summary>
        /// Allows the game component to update itself.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        public override void Update(GameTime gameTime)
        {
            // TODO: Add your update code here 
            SpriteBatch sprBatch = (SpriteBatch)Game.Services.GetService(typeof(SpriteBatch));
            tor = game.last;
            if(tor)
                text=sprTextureleft;
            else
                text=sprTextureright;
            base.Update(gameTime);
        }

        public override void Draw(GameTime gameTime)
        {
            SpriteBatch sprBatch = (SpriteBatch)Game.Services.GetService(typeof(SpriteBatch));
                sprBatch.Draw(text, sprPosition, sprRectangle, Color.White);
            base.Draw(gameTime);
            
        }
    }
}