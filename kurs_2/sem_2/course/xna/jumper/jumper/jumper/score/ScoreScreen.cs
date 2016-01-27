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
    public class ScoreScreen:Screen
    {
        Texture2D backTexture;
        Rectangle backRectangle;
        string[] records;
        SpriteFont MyFont;
        Vector2 StringPosition;

        public ScoreScreen(Game game, SpriteFont MyFont, Texture2D _back, string[] scoreStr)
            : base(game)
        {
            this.MyFont = MyFont;
            backTexture = _back;
            records = scoreStr;
            backRectangle = new Rectangle(0, 0, 600, 900);
            // TODO: Construct any child components here
        }

        public void Read(string[] records)
        {
            this.records = records;
        }
        /// <summary>
        /// Allows the game component to perform any initialization it needs to before starting
        /// to run.  This is where it can query for any required services and load content.
        /// </summary>
        /// 

        public override void Draw(GameTime gameTime)
        {
            int y = 100;
            sprBatch.Draw(backTexture, backRectangle, Color.White);
            sprBatch.DrawString(MyFont, "SCORE", new Vector2(200,15), Color.Red);
            
            foreach(string OutString in records)
            {
                StringPosition = new Vector2(20, y);
                sprBatch.DrawString(MyFont, OutString, StringPosition, Color.Red);
                y += 100;
            }

            base.Draw(gameTime);
        }
    }
}
