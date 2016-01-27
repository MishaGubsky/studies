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
    class FPSCounter : Microsoft.Xna.Framework.DrawableGameComponent
    {
        public int FPS;
        int frames;
        double seconds;

        public FPSCounter(Jumper game)
            : base(game)
        {

        }
        public override void Update(GameTime gameTime)
        {
            // TODO: Add your update code here
            seconds += gameTime.ElapsedGameTime.TotalSeconds;
            if (seconds >= 1)
            {
                FPS = frames;
                seconds = 0;
                frames = 0;
                Game.Window.Title = FPS.ToString();
            }

            base.Update(gameTime);
        }
        public override void Draw(GameTime gameTime)
        {
            frames++;
            base.Draw(gameTime);
        }
    }
}
