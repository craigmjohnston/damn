package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Craig M. Johnston
	 */
	public class Water extends Entity
	{
		[Embed(source = 'res/sprites/water.png')] private const WATER_SPRITE:Class;
		private var image:Image;
		
		private var riseSpeed:Number = 0.45;
		private var toMove:Number = 0;
		
		public var movedY:int = 0;
		
		private var isStopped:Boolean = false;
		
		public function Water() 
		{
			image = new Image(WATER_SPRITE);
			image.alpha = 0.5;
			graphic = image;
			setHitbox(320, 240, 0, 0);
			type = "water";
			layer = 2;
			
			x = 0;
			y = 240;
		}
		
		override public function update():void {	
			if (!isStopped) {
				if (y != -240) {
					toMove += riseSpeed;				
					if (toMove >= 1) {
						var move:int = Math.floor(toMove);
						if (y - move >= -240) {
							movedY = move;
						} else {
							y = -240;
							movedY = 0;
						}
						toMove -= move;
					}
				}
			}
		}
		
		public function stop():void {
			isStopped = true;
		}
		
		public function start():void {
			isStopped = false;
		}
		
	}

}