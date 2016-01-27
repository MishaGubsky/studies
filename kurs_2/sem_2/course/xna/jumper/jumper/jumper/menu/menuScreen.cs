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
    public class menuScreen:Screen
    {
        menu[] menu;
        //Текстуры и прямоугольники для вывода элементов меню
        Texture2D menuTxtStartGame;
        Texture2D menuTxtScore;
        Texture2D menuTxtExit;
        Rectangle menuTxtStartGameR, menuTxtScoreR, menuTxtExitR;
        Texture2D menuBack, menuGameName;
        Rectangle menuBackR;
        Texture2D Meleft;
        Texture2D Meright;
        Texture2D en;
        public menuScreen(Game game, Texture2D _menuBack, Texture2D _menuGameName, Texture2D Me, Texture2D Meright, Texture2D en,
            Texture2D _menuTxtStartGame, Texture2D _menuTxtScore, Texture2D _menuTxtExit,
            Rectangle _menuTxtStartGameR, Rectangle _menuTxtScoreR, Rectangle _menuTxtExitR)
            : base(game)
        {
            // TODO: Construct any child components here
            menuBack = _menuBack;
            menuGameName = _menuGameName;
            menuBackR = new Rectangle(0, 0, 600, 900);
            menuTxtStartGame = _menuTxtStartGame;
            menuTxtStartGameR = _menuTxtStartGameR;
            menuTxtScore = _menuTxtScore;
            menuTxtScoreR = _menuTxtScoreR;
            menuTxtExit = _menuTxtExit;
            menuTxtExitR = _menuTxtExitR;
            this.Meleft = Me;
            this.Meright = Meright;
            this.en = en;

            menu = new menu[3];

            menu[0] = new menu(game, menuTxtStartGame, menuTxtStartGameR, Color.Wheat);
            menu[1] = new menu(game, menuTxtScore, menuTxtScoreR, Color.White);
            menu[2] = new menu(game, menuTxtExit, menuTxtExitR, Color.White);
        }

        /// <summary>
        /// Allows the game component to perform any initialization it needs to before starting
        /// to run.  This is where it can query for any required services and load content.
        /// </summary>
        public void GetKey(int i)
        {
            //i=1 - первый пункт
            //i=2 - второй пункт
            //i=3 - третий пункт
            if(i == 1)
            {
                menu[0].color = Color.Wheat;
                menu[1].color = Color.White;
                menu[2].color = Color.White;

            }
            if(i == 2)
            {
                menu[0].color = Color.White;
                menu[1].color = Color.Wheat;
                menu[2].color = Color.White;
            }
            if(i == 3)
            {
                menu[0].color = Color.White;
                menu[1].color = Color.White;
                menu[2].color = Color.Wheat;

            }
        }

        /// <summary>
        /// Allows the game component to update itself.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        public override void Draw(GameTime gameTime)
        {
            // TODO: Add your update code here
            float t = (float)gameTime.TotalGameTime.TotalSeconds * 5+245;
            int dy = (int)(Math.Sin(t)*5);

            sprBatch.Draw(menuBack, menuBackR, Color.White);
            sprBatch.Draw(menuGameName, new Vector2(180,150), Color.White); 
            sprBatch.Draw(en, new Vector2(245, 350+dy), Color.White);
            t = (float)gameTime.TotalGameTime.TotalSeconds * 5 + 20;
            dy = (int)(Math.Sin(t) * 5);
            sprBatch.Draw(Meright, new Vector2(20, 550+dy), Color.White);
            t = (float)gameTime.TotalGameTime.TotalSeconds * 5 + 500;
            dy = (int)(Math.Sin(t) * 5);
            sprBatch.Draw(Meleft, new Vector2(500, 550+dy), Color.White);
            

            for(int i = 0;i < 3;i++)
                sprBatch.Draw(menu[i].imageTexture, menu[i].imageRectangle, menu[i].color);
            base.Draw(gameTime);
        }
    }
}
