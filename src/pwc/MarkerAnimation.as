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
	import flash.text.TextFieldAutoSize;
	
	import gs.TweenMax;
	import gs.easing.*;
	
	import pwc.config.*;
	
	import utils.debug.*;
	
	public class MarkerAnimation extends ObjectContainer3D
	{
		
		/*********************************** VARIABLES *******************************************/
		
		private var _id:int;
		private var _aTexts:Array;
		
		private var _view:View3D;

		// 3D objects
		//private var _obj_marker:Marker;
		private var _obj_video:Video3D;		
		private var _obj_3D:ObjectAnimation;
		
		//Color of each animation
		private var _bg_color1:String;
		private var _bg_color2:String;
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function MarkerAnimation(id:int, view:View3D, obj_flash:Flash3D) 
		{
			
			// set id
			_id = id;
			
			// init array of Text3D objects
			_aTexts = new Array();
			
			// set scene reference
			_view = view;
			
			/*************************/
			if (_id == 0)
			{
				_obj_3D = new Flip3D(Config.VIDEO_WIDTH, Config.VIDEO_HEIGHT);
				_bg_color1 = Config.BG_COLOR1VIDEO1;
				_bg_color2 = Config.BG_COLOR2VIDEO1;
			}
			else if (_id == 1)
			{
				//Very bad copy of flash and attached listener on static variable...
				obj_flash.addEventListener(AppEvent.ANIMATION_COMPLETE, animationCompleteHandler);
				_bg_color1 = Config.BG_COLOR1VIDEO2;
				_bg_color2 = Config.BG_COLOR2VIDEO2;
			}
			else if (_id == 2)
			{
				_obj_3D = new Screen3D(Config.VIDEO_WIDTH, Config.VIDEO_HEIGHT)
				_bg_color1 = Config.BG_COLOR1VIDEO3;
				_bg_color2 = Config.BG_COLOR2VIDEO3;
			}
			else if (_id == 3)
			{
				_obj_3D = new Fractal3D(Config.VIDEO_WIDTH, Config.VIDEO_HEIGHT, Config.VIEWPORT_3D_WIDTH, Config.VIEWPORT_3D_HEIGHT);
				_bg_color1 = Config.BG_COLOR1VIDEO4;
				_bg_color2 = Config.BG_COLOR2VIDEO4;
			}
			
			if(_obj_3D != null)
			{
				addChild(_obj_3D);
				_obj_3D.addEventListener(AppEvent.ANIMATION_COMPLETE, animationCompleteHandler);
			}
			
			/*************************/
			
			if (_id == 0)
				_obj_video = new Video3D(Config.VIDEO_URL1, Config.VIDEO_WIDTH, Config.VIDEO_HEIGHT);
			else if (_id == 1)
				_obj_video = new Video3D(Config.VIDEO_URL2, Config.VIDEO_WIDTH, Config.VIDEO_HEIGHT);
			else if (_id == 2)
				_obj_video = new Video3D(Config.VIDEO_URL3, Config.VIDEO_WIDTH, Config.VIDEO_HEIGHT);
			else if (_id == 3)
				_obj_video = new Video3D(Config.VIDEO_URL4, Config.VIDEO_WIDTH, Config.VIDEO_HEIGHT);
			
			addChild(_obj_video);
			_obj_video.addEventListener(AppEvent.CUE_POINT, cuePointHandler);	
		}
		
		/*********************************** PUBLIC FUNCTIONS ***********************************/
		public function start():void
		{
			Logger.debug('MarkerAnimation:start');

			if(_id != 1)
				_obj_3D.start();
			else if(_id == 1)
			{
				PWC_Away3D.flash_.start();
			}
		}
		
		public function stop():void
		{
			if(_id != 1)
				_obj_3D.stop();
			else if(_id == 1)
			{
				PWC_Away3D.flash_.stop();
			}
			
			_obj_video.stop();
			
			for(var i:int = 0; i < _aTexts.length; i ++)
			{
				removeChild(_aTexts[i]);
			}
			
		}	
			
		/*********************************** PRIVATE FUNCTIONS ***********************************/
		private function animationCompleteHandler(e:AppEvent):void
		{
			Logger.debug('animationCompleteHandler');
			_obj_video.start();
		}
		
		
		private function cuePointHandler(e:AppEvent):void
		{
			Logger.debug('cuePointHandler: e.obj.time');
			Logger.debug('cuePointHandler: e.obj.time'+e.obj.parameters.word);
			// text3D
			if(e.obj.parameters.word != "end")
			{
				var text3D:Text3D = new Text3D(e.obj.parameters.word, _bg_color1, _bg_color2);
				addChild(text3D);
				_aTexts.push(text3D);	
			}
			else if(e.obj.parameters.word == "end")
			{
				Logger.debug("e*************nd of clip");
				dispatchEvent(new AppEvent(AppEvent.MOVIE_END));
			}
		}		
	}
}