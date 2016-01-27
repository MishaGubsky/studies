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
    public class Box: Microsoft.Xna.Framework.DrawableGameComponent
    {
        public Texture2D Texture;
        public Vector2 Position;
        public Rectangle Rectangle;
        Game game;
        public Box(ref Texture2D texture,Vector2 Position, Rectangle rect, Game game): base(game)
        {
            this.Texture = texture;
            this.Rectangle = rect;
            this.Position = Position;
            this.game = game;
        }

        public void Draw(SpriteBatch spriteBatch)
        {
            spriteBatch.Draw(Texture, Position, Rectangle, Color.White);
        }
    }
}
