package pwc.config {
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import utils.debug.Logger;
	import utils.ui.CMenu;
	import utils.debug.Stats;
	import utils.ui.Magnet;
	
	/**
	 * Presets.as
	 * @author Adrien Felsmann
	 */
	public class Presets {
		
		/*********************************** VARIABLES *******************************************/
		
		private static var _displayObject:Sprite;
		
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		/**
		 * Init the basic funky tools we always need & love
		 * @param	displayObject
		 */
		public static function init(displayObject:Sprite):void {
			_displayObject = displayObject;
			
			if (Config.STATS_ENABLED) initStats();
			if (Config.LOGGER_UI_ENABLED) initTraceUI();
			initCM();
		}
		
		
		/*********************************** PRIVATE FUNCTIONS ***********************************/
		
		/**
		 * Init the stats graph
		 */
		private static function initStats():void {
			var stats:Stats = new Stats();
			_displayObject.addChild(stats);
			Magnet.ize(stats, null, 20, null, { x: 0, y: 0, width: Config.STAGE_WIDTH, height: Config.STAGE_HEIGHT });
		}
		
		/**
		 * init the UI logger
		 */
		private static function initTraceUI():void {
			Logger.init(0, 0, .3, 640, 480);
			_displayObject.addChild(Logger.instance);
			Magnet.ize(Logger.instance, null, 20, { width: 800, height: 100 }, { x: 0, y: 0, width: Config.STAGE_WIDTH, height: Config.STAGE_HEIGHT });
		}
		
		
		/**
		 * Init the ContextMenu
		 */
		private static function initCM():void {
			var cm:CMenu = new CMenu(
				_displayObject,
				new Array(
					['ContextMenu item', false, true, true, callbackFunction]
				)
			);
		}
		
		
		/*********************************** EVENT HANDLERS **************************************/
		
		private static function callbackFunction(e:ContextMenuEvent):void { }
	}
}