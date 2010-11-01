package utils.ui {
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * CMenu.as
	 * @author Adrien Felsmann
	 */
	public class CMenu {
		
		/*********************************** VARIABLES *******************************************/
		
		private var _cm:ContextMenu = new ContextMenu();
		
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		/**
		 * Build the global contextmenu with the data provided by the given array
		 * @param	displayObject
		 * @param	array
		 */
		public function CMenu(displayObject:Sprite, array:Array):void {
			_cm.hideBuiltInItems();
			
			for (var i:int = 0; i < array.length; i++) {
				
				if (typeof array[i][1] != "boolean") { array[i][1] = false; }
				if (typeof array[i][2] != "boolean") { array[i][2] = true; }
				if (typeof array[i][3] != "boolean") { array[i][3] = true; }
				
				var cmi:ContextMenuItem = new ContextMenuItem(array[i][0], array[i][1], array[i][2], array[i][3]);
				
				if (array[i][4] != null) {
					cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, array[i][4]);
				}
				
				_cm.customItems.push(cmi);
			}
			
            displayObject.contextMenu = _cm;
		}
	}
}