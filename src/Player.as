package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Craig M. Johnston
	 */
	public class Player extends Entity 
	{
		[Embed(source = 'res/sprites/player.png')] private const PLAYER_SPRITE:Class;
		
		public var sprPlayer:Spritemap = new Spritemap(PLAYER_SPRITE, 8, 8);
		
		private var image:Image;
		
		private var xSpeed:Number = 0;
		private var ySpeed:Number = 0;
		
		private var xSpeedToMove:Number = 0;
		private var ySpeedToMove:Number = 0;
		
		private var runSpeed:int = 3;
		
		private var movingLeft:Boolean;
		private var movingRight:Boolean;
		
		private var movingUp:Boolean;
		private var movingDown:Boolean;
		
		private var upthrustApplied:Boolean = false;
		
		private var maxFallSpeed:int = 25;
		
		private var breath:int = 10;
		private var lastBreathTick:Number = 0;
		
		private var inWater:Boolean = false;
		private var theWater:Water;
		
		private var underwater:Boolean = false;
		
		public var movedY:int = 0;
		
		public var goWithTheWater:Boolean = false;
		
		public var underwaterCollision:Boolean = false;
		
		public function Player(x:uint, y:uint) 
		{
			//animations
			sprPlayer.add("idle", [0], 1, false);
			sprPlayer.add("run", [1, 2, 3], 10, true);
			
			this.x = x;
			this.y = y;
					
			graphic = sprPlayer;
			setHitbox(8, 8, 0, 0);
			type = "player";
			
			layer = 4;
		}
		
		override public function update():void {
			getDirections()
			if (!Boolean(theWater)) {
				theWater = Water(collide("water", x, y));
				inWater = Boolean(theWater);
			}		
			
			if (!Boolean(collide("level", x, y))) {
				underwaterCollision = false;
			}
			
			if (inWater && this.y <= theWater.top - 6 && underwater && !underwaterCollision) {
				underwater = false;
			}
			
			if (inWater && this.y >= theWater.top - 6 && !underwater) {
				if (!Boolean(collide("level", x, theWater.top - theWater.movedY - 6))) {
					this.y = theWater.top - 6; 
					goWithTheWater = true;
				} else if (this.y >= theWater.top) {
					goWithTheWater = false;
					underwater = true;
					underwaterCollision = true;
					movedY = 0;
				} else {
					goWithTheWater = false;
					underwater = true;
					underwaterCollision = true;
					movedY = 0;
				}
			}
			
			if (underwater) { //breath
				if (FP.elapsed + lastBreathTick >= 1) {
					if (breath > 0) {
						breath--;
					} else { // dead
						FP.world = new LoseWorld;
					}
					lastBreathTick = FP.elapsed;
				} else {
					lastBreathTick += FP.elapsed;
				}				
			} else if (breath != 10) {
				breath = 10;
				lastBreathTick = 0;
			}
			
			if (collide("exit", x, y)) { //exit
				FP.world = new WinWorld;
			}
			
			if (Input.check(Key.LEFT)) {
				xSpeed = underwater || inWater ? -runSpeed / 5 : -runSpeed;
			}
			if (Input.check(Key.RIGHT)) {
				xSpeed = underwater || inWater ? runSpeed / 5 : runSpeed;
			}
			if (underwater) {
				if (Input.check(Key.UP)) {
					ySpeed = -runSpeed / 5;
				}
				if (Input.check(Key.DOWN)) {
					ySpeed = runSpeed / 5;
				}
			}
			
			xSpeed += xSpeedToMove;
			xSpeedToMove = xSpeed - Math.floor(xSpeed);
			xSpeed = Math.floor(xSpeed);
					
			ySpeed += ySpeedToMove;
			ySpeedToMove = ySpeed - Math.floor(ySpeed);
			ySpeed = Math.floor(ySpeed);
						
			//underwater collisions
			if (underwater) {
				getDirections();
				var xCollision:Boolean = false;
				var yCollision:Boolean = false;
				
				var xRatio:Number = ySpeed != 0 ? xSpeed / ySpeed : xSpeed; //how many pixels in X we move for every pixel in Y			
				var xCheckToDo:Number = 0; //how much checking we have to do on the X axis to catch up with the Y axis (so that we stick with the ratio)
				
				var xCheck:int = (movingRight ? x + 1 : (!movingRight && !movingLeft ? x : x - 1)); //where we're checking on the X axis at the moment
				
				for (var k:int = (movingDown ? y + 1 : (!movingDown && !movingUp ? y : y - 1)); (movingDown ? k <= y + ySpeed : k >= y + ySpeed); (movingDown ? k++ : k--)) {
					//check for vertical collisions
					if (ySpeed != 0) {
						if (collide("level", xCheck, k)) {
							yCollision = true;
							if (collide("level", x, y)) {
								ySpeed = 0;
								k = y;
							} else {
								ySpeed = k - (y + (movingDown ? 1 : -1));
								k = y + ySpeed;
							}					
						}
					}
					
					//check for horizontal collisions
					if (!xCollision) {
						xCheckToDo += Math.abs(xRatio);				
						if (xCheckToDo >= 1) {
							for (var l:int = 0; l <= Math.floor(xCheckToDo) - 1; l++) {
								if (collide("level", xCheck, k)) {								
									if (collide("level", x, y)) {
										xSpeed = 0;
									} else {
										xSpeed = xCheck - (x + (movingRight ? 1 : -1));
									}
									xCollision = true;
									continue;
								}						
								if (movingRight) {
									xCheck++;
								} else {
									xCheck--;
								}
								xCheckToDo--;
							}
						} 
					}
					
					if (xCollision && yCollision) {
						continue;
					}
				}		
			} else { //above-water collisions
				if (Boolean(collide("level", x + xSpeed, y))) {
					getDirections();
					for (var n:int = (movingRight ? x + 1 : (!movingRight && !movingLeft ? x : x - 1)); (movingRight ? n <= x + xSpeed : n >= x + xSpeed); (movingRight ? n++ : n--)) {
						if (xSpeed != 0) {
							if (collide("level", n, y)) {
								xCollision = true;
								if (collide("level", x, y)) {
									xSpeed = 0;
									n = x;
								} else {
									xSpeed = n - (x + (movingRight ? 1 : -1));
									n = x + xSpeed;
								}					
							}
						}
					}
				}
			}
			
			
			this.x += xSpeed;
			this.movedY = ySpeed;
			
			xSpeed = 0;
			ySpeed = 0;
		}
		
		private function getDirections():void {
			movingLeft = xSpeed < 0;
			movingRight = xSpeed > 0;			
			movingUp = ySpeed < 0;
			movingDown = ySpeed > 0;
		}
		
		public function getBreath():int {
			return this.breath;
		}
		
		public function isUnderwater():Boolean {
			return this.underwater;
		}
		
		public function isInWater():Boolean {
			return this.inWater;
		}
		
	}

}