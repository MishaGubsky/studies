using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Content;

namespace WindowsGame1
{
    public class menu
    {
        public Texture2D imageTexture;
        public Rectangle imageRectangle;
        public Color color;
        public menu(Game game, Texture2D _texture, Rectangle _rectangle, Color _color)
        {
            imageTexture = _texture;
            imageRectangle = _rectangle;
            color = _color;
        }

        ~menu()
        {
            Dispose();
        }

        public void Dispose()
        {
              imageTexture.Dispose();
        }
    }
}
