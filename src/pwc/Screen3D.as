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
	
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import pwc.config.Config;

	//public class Screen3D extends ObjectContainer3D
	public class Screen3D extends ObjectAnimation
	{
		
		/*********************************** VARIABLES *******************************************/
		
		private var _screen:Screen;
		private var _mat:ColorMaterial;
		private var _p:Plane;
		
		private var _width:int;
		private var _height:int;
		
		// filters
		private var bf:BlurFilter = new BlurFilter(3,3,1);
		private var glowFilter_2:GlowFilter = new GlowFilter(0xBCAA00, 2, 18, 10, 2, 3, true, false);
		private var glowFilter_b_2:GlowFilter = new GlowFilter(0xBCAA00, 2, 10, 10, 3, 9, false, false);
		private var dropShadow_2:DropShadowFilter = new DropShadowFilter(0, 360, 0xD4C003, 1, 70, 70, 5, 3, false, false, false);
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function Screen3D(width:int, height:int)
		{
			_width = width;
			_height = height;
			
			
			_mat = new MovieMaterial( Sprite(_screen = new Screen()), {smooth:true, transparent: true, precision:8} );
			//_mat = new MovieMaterial( Sprite(_screen = new Screen()), {alpha: .5} );
			//_mat = new ColorMaterial( 0xffffff, {transparent: true} );
			_p = new Plane({width:_width, height:_height, material:_mat});
			_mat.alpha = .5;
			//_p.blendMode = 
			_p.y = 46;
			_screen.stop();
			addChild(_p);
			
			_screen.filters = [bf, glowFilter_2, glowFilter_b_2, dropShadow_2];
			
			this.visible = false;
			
		}
		
		
		/*********************************** PUBLIC FUNCTIONS ***********************************/
		
		public override function start():void
		{
			this.visible = true;
			_screen.gotoAndPlay('start');
			_screen.addEventListener(Event.ENTER_FRAME, screenEnterFrameHandler);
		}
		
		public override function stop():void
		{
			this.visible = false;
			_screen.stop();
			_screen.removeEventListener(Event.ENTER_FRAME, screenEnterFrameHandler);
		}
		
		
		/*********************************** PRIVATE FUNCTIONS ***********************************/
		
		private function screenEnterFrameHandler(e:Event):void
		{
			if(_screen.currentLabel == 'end')
			{
				_screen.stop();
				_screen.removeEventListener(Event.ENTER_FRAME, screenEnterFrameHandler);
				
				dispatchEvent(new AppEvent(AppEvent.ANIMATION_COMPLETE));
				
			}
		}
	}
}