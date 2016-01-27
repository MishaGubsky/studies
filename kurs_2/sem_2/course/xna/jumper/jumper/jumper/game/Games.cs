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
using System.Security.Policy;


namespace WindowsGame1
{

    /// <summary>
    /// This is a game component that implements IUpdateable.
    /// </summary>
    public class Games : Screen
    {
        private Texture2D txtBackground;
        private Texture2D txtMeleft;
        private Texture2D txtMeright;
        private Texture2D txtWall;
        private Texture2D txtBonus;
        private Texture2D txtEnemy;
        List<Box> boxs;
        List<bonusElements> bonuses;
        List<EnemyCollection> enemies;
        public Game game;
        Rectangle recSprite;
        Texture2D [] boncollection;
        Texture2D [] encollection;
        int levelLength;
        public bool kill;
        public bool win;
        public bool last=false;
        public int sprScores = 0;
        SpriteFont MineFont;
        public Me mine;
        public string[] NewRecords;
        //public YouWin YouWin;

        public Games(Game _game, ref Texture2D background, ref Texture2D Me, ref Texture2D Meright, ref Texture2D Wall, ref Texture2D[] boncollection, ref Texture2D[] encollection)
            : base(_game)
        {
            game = _game;
            this.boncollection = boncollection;
            this.encollection = encollection;
            txtBackground = background;
            txtMeleft = Me;
            txtMeright = Meright;
            txtWall = Wall;
            MineFont = game.Content.Load<SpriteFont>("scoreInscreen");
            //YouWin = new YouWin(game1, MineFont, txtBackground);
            createMaps();

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

        protected override void LoadContent()
        {
            // Create a new SpriteBatch, which can be used to draw textures.
            
            // TODO: use this.Content to load your game content here
        }                                                                                                

         void createMaps()
        {
            boxs = new List<Box>();
            bonuses = new List<bonusElements>();
            enemies = new List<EnemyCollection>();
            string[] lines = File.ReadAllLines(@"D:/Layer.txt");
            int en=0, bon = 0;

            levelLength = 100 * lines.Count();
            int x = 0;
            int y = 0;
            int i=lines.Count()-1, j = 0;

            for(;i >= 0;i--)
            {
                for(;j < lines[i].Length;j++)
                {
                    char c = lines[i][j];
                    switch(c)
                    {
                        case '1':
                        {
                            Rectangle boxrect = new Rectangle(0, 0, 100, 20);
                            Vector2 boxposition = GetScreenRect(new Vector2(x, y));
                            Box box = new Box(ref txtWall, boxposition, boxrect, game);
                            boxs.Add(box);
                            break;
                        }
                        case '2':
                        {

                            bon = (int)new Random().Next(0, 2);
                            switch(en)
                            {
                                case 0:
                                {
                                    Rectangle enrect = new Rectangle(0, 0, 100, 65);
                                    Vector2 enposition = GetScreenRect(new Vector2(x, y));
                                    txtEnemy = encollection[en];
                                    EnemyCollection enemy = new EnemyCollection(ref txtEnemy, enposition, enrect, game);
                                    enemies.Add(enemy);
                                    en++;
                                    break;
                                }
                                case 1:
                                {
                                    Rectangle enrect = new Rectangle(0, 0, 173, 95);
                                    Vector2 enposition = GetScreenRect(new Vector2(x, y));
                                    txtEnemy = encollection[en];
                                    EnemyCollection enemy = new EnemyCollection(ref txtEnemy, enposition, enrect, game);
                                    enemies.Add(enemy);
                                    en++;
                                    break;
                                }
                                case 2:
                                {
                                    Rectangle enrect = new Rectangle(0, 0, 120, 100);
                                    Vector2 enposition = GetScreenRect(new Vector2(x, y));
                                    txtEnemy = encollection[en];
                                    EnemyCollection enemy = new EnemyCollection(ref txtEnemy, enposition, enrect, game);
                                    enemies.Add(enemy);
                                    en++;
                                    break;
                                }
                                case 3:
                                {
                                    Rectangle enrect = new Rectangle(0, 0, 50, 100);
                                    Vector2 enposition = GetScreenRect(new Vector2(x, y));
                                    txtEnemy = encollection[en];
                                    EnemyCollection enemy = new EnemyCollection(ref txtEnemy, enposition, enrect, game);
                                    enemies.Add(enemy);
                                    en++;
                                    break;
                                }
                                case 4:
                                {
                                    Rectangle enrect = new Rectangle(0, 0, 80, 105);
                                    Vector2 enposition = GetScreenRect(new Vector2(x, y));
                                    txtEnemy = encollection[en];
                                    EnemyCollection enemy = new EnemyCollection(ref txtEnemy, enposition, enrect, game);
                                    enemies.Add(enemy);
                                    en++;
                                    break;
                                }
                                case 5:
                                {
                                    Rectangle enrect = new Rectangle(0, 0, 60, 100);
                                    Vector2 enposition = GetScreenRect(new Vector2(x, y));
                                    txtEnemy = encollection[en];
                                    EnemyCollection enemy = new EnemyCollection(ref txtEnemy, enposition, enrect, game);
                                    enemies.Add(enemy);
                                    en = 0;
                                    break;
                                }

                            }


                            break;
                        }
                        case '3':
                        {
                            bon = (int) new Random().Next(0,2);
                            switch(bon)
                            {
                                case 2:
                                {
                                    Rectangle bonrect = new Rectangle(0, 0, 63, 110);                                //max
                                    Vector2 bonposition = GetScreenRect(new Vector2(x, y));
                                    txtBonus = boncollection[0];
                                    bonusElements bonus = new bonusElements(ref txtBonus, bonposition, bonrect, game);
                                    bonuses.Add(bonus);
                                    bon=0;
                                    break;
                                }
                                case 1:
                                {
                                    Rectangle bonrect = new Rectangle(0, 0, 21, 80);                                     //midle
                                    Vector2 bonposition = GetScreenRect(new Vector2(x, y));
                                    txtBonus = boncollection[bon];
                                    bonusElements bonus = new bonusElements(ref txtBonus, bonposition, bonrect, game);
                                    bonuses.Add(bonus);
                                    bon++;
                                    break;
                                }
                                case 0:
                                {
                                    Rectangle bonrect = new Rectangle(0, 0, 80, 60);                                    //min
                                    Vector2 bonposition = GetScreenRect(new Vector2(x, y));
                                    txtBonus = boncollection[2];
                                    bonusElements bonus = new bonusElements(ref txtBonus, bonposition, bonrect, game);
                                    bonuses.Add(bonus);
                                    bon ++;
                                    break;
                                }
                            }

                            break;
                        }
                    }
                    x += 100;
                }
                j = 0;
                x = 0;
                y += 100;
            }
            recSprite = new Rectangle ( 0, 0, 80, 80 ) ;

            mine=new Me(game, this, ref txtMeleft, ref txtMeright, GetScreenRect(new Vector2(0, 100)), 
                recSprite, boxs, bonuses, enemies);
            game.Components.Add(mine);
        }

         public Vector2 GetScreenRect (Vector2 pos)
         {
             Vector2 p = pos;
             p.Y = game.Window.ClientBounds.Height - p.Y;
             return p;
         }

         public void Scroll(float dy)
         {
             for(int i=0;i<boxs.Count;i++)
             {
                 Box box = boxs[i];
                 box.Position.Y += dy;
                 if(box.Position.Y > game.Window.ClientBounds.Height)
                 {
                     box.Dispose();
                     boxs.Remove(box);
                 }
             }
             for(int i = 0;i < enemies.Count;i++)
             {
                 EnemyCollection en = enemies[i];
                 en.Position.Y += dy;
                 if(en.Position.Y > game.Window.ClientBounds.Height)
                 {
                     en.Dispose();
                     enemies.Remove(en);
                 }
             }
             for(int i = 0;i < bonuses.Count;i++)
             {
                 bonusElements bon = bonuses[i];
                 bon.Position.Y += dy;
                 if(bon.Position.Y > game.Window.ClientBounds.Height)
                 {
                     bon.Dispose();
                     bonuses.Remove(bon);
                 }
             }
         }

        /* public void Win()
         {
             this.Hide();
             CompareScore comscor = new CompareScore();
             NewRecords = comscor.Score(this.sprScores.ToString());
             win = true;
         }
          */
         public void gameOver()
         {
             this.Hide();     
             mine.Dispose();
             CompareScore comscor = new CompareScore();
             NewRecords=comscor.Score(this.sprScores.ToString());
             kill = true;
         }

        protected override void UnloadContent()
        {
            txtBackground.Dispose();
            txtMeleft.Dispose();
            txtMeright.Dispose();
            txtWall.Dispose();

            // TODO: Unload any non ContentManager content here
        }
        /// <summary>
        /// Allows the game component to update itself.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        public override void Update(GameTime gameTime)
        {
            // TODO: Add your update code here

            base.Update(gameTime);
        }

        public override void Draw(GameTime gameTime)
        {
            SpriteBatch spriteBatch = (SpriteBatch)Game.Services.GetService(typeof (SpriteBatch));
            foreach(Box box in boxs)
            {
                box.Draw(spriteBatch);
            }
            foreach(bonusElements bon in bonuses)
            {
                bon.Draw(gameTime);
            }
            foreach(EnemyCollection en in enemies)
            {
                en.Draw(gameTime);
            }
            spriteBatch.DrawString(MineFont, "SCORE", new Vector2(500, 15), Color.Red);
            spriteBatch.DrawString(MineFont, this.sprScores.ToString(), new Vector2(500, 35), Color.Red);
            mine.Draw(gameTime);
            base.Draw(gameTime);

            // TODO: Add your drawing code here 
        }
    }
}
