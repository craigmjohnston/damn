package  
{
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.graphics.Tilemap;
	
	/**
	 * ...
	 * @author Craig M. Johnston
	 */
	public class Border extends Entity
	{
		private var _tilemap:Tilemap;		
		
		[Embed(source = 'res/tilesets/test.png')] private static const DEBUG_TILESET:Class;
		
		public function Border()
		{
			_tilemap = new Tilemap(DEBUG_TILESET, 320, 240, 8, 8);
			
			for (var i:int = 0; i < 2; i++) {
				for (var j:int = 0; j < 30; j++) {
					_tilemap.setTile(i * 39, j, 0);
				}
			}
			
			//setup
			graphic = _tilemap;
			layer = 1;			
			type = "level";
		}
		
	}

}