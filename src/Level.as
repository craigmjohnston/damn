package  
{
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Craig M. Johnston
	 */
	public class Level extends Entity
	{
		public var _tilemap:Tilemap;
		public var _grid:Grid;
		
		private var playerStartX:uint;
		private var playerStartY:uint;
		private var exits:Array;
		
		private var screens:uint = 0;
		
		[Embed(source = 'res/tilesets/test.png')] private static const DEBUG_TILESET:Class;
		
		[Embed(source = 'res/levels/level1.oel', mimeType = 'application/octet-stream')] private const LEVEL_1:Class;
		[Embed(source = 'res/levels/level2.oel', mimeType = 'application/octet-stream')] private const LEVEL_2:Class;
		[Embed(source = 'res/levels/level3.oel', mimeType = 'application/octet-stream')] private const LEVEL_3:Class;
		[Embed(source = 'res/levels/level4.oel', mimeType = 'application/octet-stream')] private const LEVEL_4:Class;
		[Embed(source = 'res/levels/level5.oel', mimeType = 'application/octet-stream')] private const LEVEL_5:Class;
		
		private var levelSections:Array = [
			LEVEL_1,
			LEVEL_2,
			LEVEL_3,
			LEVEL_4,
			LEVEL_5,
		];
		
		public function Level(screens:uint)
		{		
			var levels:Array = [screens];
			this.screens = screens;
			
			for (var i:int = 0; i < screens; i++) {
				levels[i] = levelSections[FP.rand(levelSections.length - 1)];
			}
			
			_tilemap = new Tilemap(DEBUG_TILESET, 640, 480 * screens, 8, 8);
			_grid = new Grid(640, 480 * screens, 8, 8, 0, 0);
						
			for (var j:int = 0; j < screens; j++) {
				loadMap(levels[j], j, j == screens - 1, j == 0);
			}
			
			_tilemap.y = -(240 * (screens - 1));
			_grid.y = -(240 * (screens - 1));
			
			//setup
			graphic = _tilemap;
			layer = 3;
			mask = _grid;	
			type = "level";
		}
		
		public function loadMap(xml:Class, index:int, isBottom:Boolean, isTop:Boolean):void {
			var data:ByteArray = new xml;
			var dataString:String = data.readUTFBytes(data.length);
			var xmlData:XML = new XML(dataString);
			
			var gridString:String;
			
			var dataList:XMLList;
			var dataElement:XML;
			
			var tileSetHeight:int = 8;
			
			//tiles
			dataList = xmlData.floortiles.tile;
			for each(dataElement in dataList) {
				var tileIndex:int = (int(dataElement.@ty) / 8 * (tileSetHeight / 8)) + int(dataElement.@tx) / 8;
				
				var int1:int = int(dataElement.@x) / 8;
				var int2:int = (int(dataElement.@y) / 8) * (index + 1);
				
				_tilemap.setTile(int(dataElement.@x) / 8, (int(dataElement.@y) / 8) + (30 * index), tileIndex);
			}
			
			//grid
			gridString = xmlData.floor.text();
			var gridRows:Array = gridString.split("-");
			
			for (var i:int = 0; i < gridRows.length; i++) {
				var row:String = gridRows[i];
				for (var j:int = 0; j < row.length; j++) {
					if (row.charAt(j) == "1") {
						_grid.setTile(j, i + (30 * index), true);
					}
				}
			}
			
			if (isBottom) {
				for (var l:int = 0; l < 40; l++) {
					_tilemap.setTile(l, 29 + (30 * index), 0);
					_grid.setTile(l, 29 + (30 * index), true);
				}
			}
			
			if (isTop) {
				for (l = 0; l < 40; l++) {
					_tilemap.setTile(l, 0, 0);
					_grid.setTile(l, 0, true);
				}
			}
			
			//objects
			if (isBottom) {
				var playerElement:XML = xmlData.pieces.player[0];
				playerStartX = playerElement.@x;
				playerStartY = playerElement.@y;
			}
			
			if (isTop) {
				dataList = xmlData.pieces.exit;
				exits = [dataList.length];
				
				for (var k:int = 0; k < dataList.length(); k++) {
					var exit:XML = dataList[k];
					exits[k] = [int(exit.@x), int(exit.@y) - (240 * (screens - 1))];
				}
			}
		}
		
		public function getPlayerStartX():uint {
			return playerStartX;
		}
		
		public function getPlayerStartY():uint {
			return playerStartY;
		}
		
		public function getExits():Array {
			return exits;
		}
		
	}

}