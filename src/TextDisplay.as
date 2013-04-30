package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text
	
	/**
	 * ...
	 * @author Craig M. Johnston
	 */
	public class TextDisplay extends Entity
	{
		private var text:Text;
		
		public function TextDisplay(text:String, x:uint, y:uint) 
		{
			this.text = new Text(text);
			graphic = this.text;
			this.x = x;
			this.y = y;
		}
		
		public function setText(text:String):void {
			this.text = new Text(text);
			graphic = this.text;
		}
	}

}