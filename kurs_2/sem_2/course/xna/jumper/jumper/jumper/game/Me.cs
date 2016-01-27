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
    public class Me : BasClass
    {
        Rectangle scrBounds;
        Games game;
        Game _game;
        Rectangle SpriteRect;
        Vector2 CurentPosition;
        float sprSpeed = 5;
        bool jump = true;
        bool flying = false;
        bool updown = false;
        public bool kill = false;
        public bool win = false;
        public float ySpeed = 4;
        float sprAcceleration = 0.23f;
        float sprGrAcc = 0;
        float curspeed = 3;
        int curScore;
        int way;
        int sprScores = 0;
        int qualityofbonus;
        List<Box> boxs;
        List<EnemyCollection> enemies;
        List<bonusElements> bonuses;

        public Me(Game game, Games games, ref Texture2D _sprTexture, ref Texture2D _sprTexture2,
            Vector2 _sprPosition, Rectangle _sprRectangle, List<Box> sprboxs, List<bonusElements> bonuses, List<EnemyCollection> enemies)
            : base(game, games, ref _sprTexture, ref _sprTexture2, _sprPosition, _sprRectangle)
        {
            boxs = sprboxs;
            this.game = games;
            this.bonuses = bonuses;
            this.enemies = enemies;
            this._game = game;
            SpriteRect = _sprRectangle;
            scrBounds = new Rectangle(0, 0, game.Window.ClientBounds.Width, game.Window.ClientBounds.Height);
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

        void Check()
        {
            if (sprPosition.X < scrBounds.Left)
            {
                sprPosition.X = scrBounds.Right-sprRectangle.Width;
            }
            if (sprPosition.X > scrBounds.Right - sprRectangle.Width)
            {
                sprPosition.X = scrBounds.Left;
            }
            if (sprPosition.Y < scrBounds.Top)
            {
                sprPosition.Y = scrBounds.Top;
            }
            if (sprPosition.Y > scrBounds.Bottom - sprRectangle.Height+10)
            {
                kill=true;
            }
        }

        void MoveUp(float speed)
        {
            this.sprPosition.Y -= speed;
        }
        void MoveDown(float speed)
        {
            this.sprPosition.Y += speed;
        }
        void MoveLeft(float speed)
        {
            this.sprPosition.X -= speed;
        }
        void MoveRight(float speed)
        {
            this.sprPosition.X += speed;
        }

        private bool IsWallIsTheBottom()        //проверка на нижнюю границу    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        {
            int Collision = 0;
            foreach (Box spr in boxs)
            {
                    if (this.sprPosition.X + this.sprRectangle.Width > spr.Position.X &&
                        this.sprPosition.X < spr.Position.X + 50 &&
                        this.sprPosition.Y + 1 + this.sprRectangle.Height > spr.Position.Y &&
                        this.sprPosition.Y + 1 + this.sprRectangle.Height/2 < spr.Position.Y + 15)
                        Collision++;

            }
            if (Collision > 0)
                return true;
            else
                return false;
        }


        void Move(GameTime gametime)
        {
            KeyboardState kbState = Keyboard.GetState();


            if (jump)
            {
                this.GoToUp(gametime);
                jump = true;
            }
            else 
                if(!flying)
                while (!IsCollideWithWall())
                {
                    MoveDown((sprSpeed / 10));
                }
            if (kbState.IsKeyDown(Keys.Left))
            {
                game.last = true;
                MoveLeft(sprSpeed);
                if(jump)
                while (IsCollideWithWall())
                {
                    MoveRight((sprSpeed / 10));
                }
            }
            if (kbState.IsKeyDown(Keys.Right))
            {
                game.last = false;
                MoveRight(sprSpeed);
                if(jump)
                while (IsCollideWithWall())
                {
                    MoveLeft((sprSpeed / 10));
                }
            }
        }

        private bool IsCollideWithWall()                //проверка на ступеньку     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
        {
            foreach (Box spr in boxs)
            {
                if(this.sprPosition.X + this.sprRectangle.Width > spr.Position.X+5 &&
                    this.sprPosition.X < spr.Position.X + 5 &&
                    this.sprPosition.Y + this.sprRectangle.Height-20 > spr.Position.Y &&
                    this.sprPosition.Y < spr.Position.Y + 20)
                        return true;
            }
            return false;
        }

         bool IsunderEnemy()                           //прыгнул сверху врага!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
         {
             foreach(EnemyCollection spr in enemies)
             {
                 if(!IsCollideWithEnemy() && this.sprPosition.X + this.sprRectangle.Width > spr.Position.X &&
                     this.sprPosition.X < spr.Position.X + spr.Rectangle.Width &&
                     this.sprPosition.Y + this.sprRectangle.Height < spr.Position.Y + spr.Rectangle.Height && 
                     this.sprPosition.Y+1> spr.Position.Y - this.sprRectangle.Height)
                 {
                     enemies.Remove(spr);
                     return true;
                 }
             }
             return false;
         }
          
        bool IsCollideWithBonus()                   //проверка на бонусы
         {
             bonusElements findspr=null;
             qualityofbonus = 0;
             foreach(bonusElements spr in bonuses)
             {
                 if(this.sprPosition.X + this.sprRectangle.Width > spr.Position.X &&
                     this.sprPosition.X < spr.Position.X + spr.Rectangle.Width &&
                     this.sprPosition.Y + this.sprRectangle.Height > spr.Position.Y&&
                     this.sprPosition.Y < spr.Position.Y + this.sprRectangle.Height)
                 {
                     bonuses.Remove(spr);
                     findspr = spr;
                     if(spr.Rectangle.Width < 60)
                         qualityofbonus = 2;
                     else if(spr.Rectangle.Width == 63)
                         qualityofbonus = 3;
                     else
                         qualityofbonus = 1;
                     return true;
                 }
             } 
           if(findspr!=null)
             findspr.Dispose();
             return false;
         }        

        bool IsCollideWithEnemy()                   //проверка на врага!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        {
            foreach(EnemyCollection spr in enemies)
            {
                if(this.sprPosition.X + this.sprRectangle.Width > spr.Position.X &&
                    this.sprPosition.X < spr.Position.X + spr.Rectangle.Width &&
                    this.sprPosition.Y - 1 > spr.Position.Y + spr.Rectangle.Height&&
                    this.sprPosition.Y - this.sprRectangle.Height-1 < spr.Position.Y + spr.Rectangle.Height)
                    return true;
            }
            return false;
        }

        void KillMe()                                //смерть->летит вниз
        {
            if(sprPosition.Y + SpriteRect.Height - 5 < scrBounds.Bottom)
            {
                MoveDown(sprGrAcc);
                sprGrAcc += 1;
            } else
            {
                game.gameOver();
            }
        }                          

        void doBonus()
        {
           jump = false;
           flying = true;
           if(qualityofbonus == 1)
               way = 1000;
           if(qualityofbonus == 2)
               way = 2000;
           if(qualityofbonus == 3)
               way = 3000;
           CurentPosition = this.sprPosition;
           curScore = game.sprScores;
        }               

        void GoToDown()
        {
            if (sprGrAcc == 0)
                sprGrAcc = sprAcceleration;
            MoveDown(sprGrAcc);
            while (IsCollideWithWall())
            {
                MoveUp((sprSpeed / 10));
            }
            sprGrAcc += sprAcceleration;
            if (IsWallIsTheBottom())
                sprGrAcc = 0;
           
            if(IsunderEnemy())
            {
                sprGrAcc = 0;
            }           
        }

        void GoToUp(GameTime gametime)
        {

            if (ySpeed > 0)
            {
                ySpeed = ySpeed - sprAcceleration * gametime.ElapsedGameTime.Milliseconds / 10;
                curspeed = ySpeed;
                MoveUp(ySpeed);
            }
            else
            {
                jump = false;
                GoToDown();
                ySpeed = 10;
            }
            //if (IsWallIsTheBottom())
            //    sprGrAcc = 0;
            
        }
        
        /// <summary>
        /// Allows the game component to update itself.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        

        public override void Update(GameTime gameTime)
        {
            // TODO: Add your update code here
            if(!flying && !kill && !win)
            {
                Move(gameTime);
                Check();
                GoToDown();

                if(IsCollideWithBonus())
                    doBonus();
                if(IsCollideWithEnemy())
                {
                    kill = true;
                }

                CurentPosition = this.sprPosition;
                game.GetScreenRect(CurentPosition);
                if(CurentPosition.Y < 300 && (ySpeed > sprGrAcc))
                {
                    game.sprScores += (int)((ySpeed - sprGrAcc));
                    game.Scroll(ySpeed - sprGrAcc);
                }
                ySpeed = 10;

               /* if(game.sprScores > 2100)
                    win = true;   */

            } else if(flying && !win)
            {
                Move(gameTime);
                if((this.sprPosition.Y < 310))
                    if(curScore + way > game.sprScores)
                    {
                        game.sprScores += 10;
                        game.Scroll(10);
                    } else
                    {
                        MoveDown(10);
                        flying = false;
                        jump = true;
                    } else
                    if((CurentPosition.Y > 300))
                        MoveUp(10);

                if((this.sprPosition.Y > 310))
                    if(curScore + way > game.sprScores)
                    {
                        game.sprScores += 10;
                        game.Scroll(10);
                    } else
                    {
                        flying = false;
                        jump = true;
                    } else
                    if(CurentPosition.Y < 300)
                    MoveDown(10);
               /* if(game.sprScores > 2100)
                    win = true; */

            } else if(kill)
            {
                //this.Dispose();
                KillMe();
            }/* else if(win)
            {
                this.Dispose();
                game.Win();
            }  */
                
            
            

            base.Update(gameTime);
        }
    }
}
