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
using System.IO;


namespace WindowsGame1
{
    
    /// <summary>
    /// This is a game component that implements IUpdateable.
    /// </summary>
    public class YouWin:Screen
    {   
        Texture2D backTexture;
        Rectangle backRectangle;
        string record;
        SpriteFont MyFont;

        public YouWin(Game game, SpriteFont MyFont, Texture2D _back)
            : base(game)
        {
            this.MyFont = MyFont;
            backTexture = _back;
            backRectangle = new Rectangle(0, 0, 600, 900);
            // TODO: Construct any child components here
        }

        public void Read(string record)
        {
            this.record = record;
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

        /// <summary>
        /// Allows the game component to update itself.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        public override void Draw(GameTime gameTime)
        {

           
            sprBatch.Draw(backTexture, backRectangle, Color.White);
            sprBatch.DrawString(MyFont, "My congratulations", new Vector2(150, 50), Color.Red);
            sprBatch.DrawString(MyFont, "You Win!", new Vector2(200, 100), Color.Red);
            sprBatch.DrawString(MyFont, "Your score is", new Vector2(175, 150), Color.Red);
            sprBatch.DrawString(MyFont, record, new Vector2(475, 150), Color.Yellow);
            
            base.Draw(gameTime); 
        }
    }
}
