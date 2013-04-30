package  
{
	import net.flashpunk.World;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Craig M. Johnston
	 */
	public class DebugWorld extends World
	{
		private var breathText:TextDisplay;
		private var player:Player;
		private var level:Level;
		
		private var screens:uint = FP.rand(12);
		
		private var stopScrollingTop:Boolean = false;
		private var stopScrollingBottom:Boolean = false;
		
		private var exits:Array;
		
		private var water:Water;
		
		public function DebugWorld() 
		{
			level = new Level(screens);
			player = new Player(level.getPlayerStartX(), level.getPlayerStartY());
			breathText = new TextDisplay("", 10, 8);
			
			var exitsPos:Array = level.getExits();
			exits = new Array(exitsPos.length);
			
			for (var i:int = 0; i < exitsPos.length; i++) {				
				exits[i] = new Exit(exitsPos[i][0], exitsPos[i][1]);
				add(exits[i]);
			}
			
			water = new Water();
			
			add(player);
			add(breathText);
			add(water);
			add(level);
		}
		
		override public function update():void {
			super.update();
			if (player.isUnderwater()) {
				breathText.setText("Breath: " + player.getBreath());
			} else {
				breathText.setText("");
			}
			
			//if the player is below the middle of the screen
				//stop scrolling until he reaches it (or above it)
				//water is not affected by player movement
			//if the player is above the middle of the screen
				//stop scrolling until he reaches it (or below it)
				//water is not affected by player movement
			
			//if the player is on the water
				//player movement = water movement
				
			//if the player is not on the water
				//player movement != water movement
				//water scrolls with the rest of the scene, while also moving
			
			
			var waterScroll:Boolean = false;
			
			if (player.y < 112 || (level._tilemap.y >= 0 && player.y <= 112 && player.movedY < 0)) {
				if (stopScrollingBottom) {
					player.y = 112;
					if (player.goWithTheWater) {
						water.y = 112;
					}
					stopScrollingBottom = false;
					waterScroll = true;
				} else {
					stopScrollingTop = true;
					waterScroll = false;
				}
			} else if (player.y > 112 || (level._tilemap.y == -(240 * (screens - 1)) && player.y >= 112 && player.movedY > 0)) {
				if (stopScrollingTop) {
					player.y = 112;
					if (player.goWithTheWater && level._tilemap.y < 0) {
						water.y = 112;
					}					
					stopScrollingTop = false;
					waterScroll = true;
				} else {
					stopScrollingBottom = true;
					waterScroll = false;
				}
			} else {
				stopScrollingTop = false;
				stopScrollingBottom = false;
			}
				
			if (player.goWithTheWater) {
				player.movedY = water.movedY;
				waterScroll = false;
			} else if (!stopScrollingBottom && !stopScrollingTop) {
				waterScroll = true;
			}
			
			if (!stopScrollingBottom && !stopScrollingTop) {
				var exit:Exit;
				if (player.goWithTheWater) {
					if (level._tilemap.y < 0) {
						level._tilemap.y += player.movedY;
						level._grid.y += player.movedY;
						for each(exit in exits) {
							exit.y += player.movedY;
						}
					}
				} else {
					if (level._tilemap.y < 0) {
						level._tilemap.y -= player.movedY;
						level._grid.y -= player.movedY;
						for each(exit in exits) {
							exit.y -= player.movedY;
						}
					}
				}
				player.y = 112;
			} else {
				player.y += player.movedY;
			}
			
			if (!player.goWithTheWater && water.y <= 120 && player.y < water.y) {
				waterScroll = true;
			}
			
			if (level._tilemap.y >= 0) {
				waterScroll = false;
			}
				
			if ((!player.goWithTheWater) || (player.goWithTheWater && (stopScrollingBottom || stopScrollingTop)) || (player.goWithTheWater && water.y <= 120 && level._tilemap.y >= 0)) {
				if (waterScroll) {
					water.y -= water.movedY + player.movedY;
				} else {
					water.y -= water.movedY;
				}
			}
			
			player.movedY = 0;
			water.movedY = 0;
		}
		
	}

}