package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Craig M. Johnston
	 */
	public class Exit extends Entity 
	{
		[Embed(source = 'res/sprites/exit.png')] private const EXIT_SPRITE:Class;
		private var image:Image;
		
		public function Exit(x:int, y:int) 
		{
			image = new Image(EXIT_SPRITE);
			graphic = image;
			setHitbox(8, 8, 0, 0);
			this.x = x;
			this.y = y;
			type = "exit";
			layer = 4;
		}
		
	}

}