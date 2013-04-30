package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Craig M. Johnston
	 */
	public class Main extends Engine
	{
		
		public function Main():void 
		{
			super(320, 240, 60, false);
			FP.screen.scale = 2;
			FP.world = new MainMenuWorld;
		}
		
		override public function init():void 
		{
			
		}
		
	}
	
}