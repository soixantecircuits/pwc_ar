package pwc
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.utils.Cast;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gs.TweenMax;
	import gs.easing.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import utils.debug.*;
	
	//public class Flash3D extends ObjectContainer3D
	public class Flash3D extends Sprite
	{
		
		/*********************************** VARIABLES *******************************************/
		
		private var _width:int;
		private var _height:int;
		
		private var _flash:WhiteFlash;
		//private var _mat:ColorMaterial;
		//private var _p:Plane;
		
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function Flash3D(width:int, height:int)
		{
			_width = width;
			_height = height;
			_flash = new WhiteFlash();
			_flash.width = _width;
			_flash.height = _height;
			addChild(_flash);
			
			this.visible = false;
		}
		
		
		/*********************************** PUBLIC FUNCTIONS ***********************************/
		
		public function start():void
		{
			Logger.debug('flash start');
			
			this.visible = true;
			TweenMax.to(_flash, 0.2, { alpha: 1, ease: Strong.easeIn, delay: 0 } );
			TweenMax.to(_flash, 1, { alpha: 0, ease: Strong.easeOut, delay: 0.5 } );
			TweenMax.to(_flash, 1, { onComplete: complete });
		}
		
		public function stop():void
		{
			this.visible = false;
		}
		
		public function complete():void
		{
			dispatchEvent(new AppEvent(AppEvent.ANIMATION_COMPLETE));
		}		
	}
}