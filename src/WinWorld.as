package  
{
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Craig M. Johnston
	 */
	public class WinWorld extends World
	{
		
		public function WinWorld() 
		{
			add(new TextDisplay("You Escaped!", 0, 0));
			add(new TextDisplay("press R to play again", 50, 50));
		}
		
		override public function update():void {
			super.update();
			if (Input.pressed(Key.R)) {
				FP.world = new DebugWorld;
			} else if (Input.pressed(Key.ESCAPE)) {
				FP.world = new MainMenuWorld;
			}
		}
	}

}