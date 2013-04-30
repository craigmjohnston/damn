package  
{
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Craig M. Johnston
	 */
	public class MainMenuWorld extends World
	{
		[Embed(source = 'res/music/title.mp3')] private const TITLE_MUSIC:Class;
		private var bgMusic:Sfx = new Sfx(TITLE_MUSIC);
		
		public function MainMenuWorld() 
		{
			add(new TextDisplay("Damn my stubby little legs...", 0, 0));
			add(new TextDisplay("press SPACE to start", 50, 50));
			bgMusic.loop();
		}
		
		override public function update():void {
			super.update();
			if (Input.pressed(Key.SPACE)) {
				FP.world = new DebugWorld;
			}
		}
	}

}