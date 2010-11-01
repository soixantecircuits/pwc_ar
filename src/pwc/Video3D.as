package pwc
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.utils.Cast;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	
	import fl.video.MetadataEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gs.TweenMax;
	
	import utils.debug.*;

	public class Video3D extends ObjectContainer3D
	{
		
		/*********************************** VARIABLES *******************************************/
		
		private var _screenVideo:ScreenVideo;
		private var _netConnection:NetConnection;
		private var _netStream:NetStream;
		//private var _mat:VideoMaterial;
		private var _mat:MovieMaterial;
		private var _p:Plane;
		private var _client:Object;
		
		private var _url:String;
		private var _width:int;
		private var _height:int;
		private var _ratio:Number;
		
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function Video3D(url:String, width:int, height:int)
		{
			
			_url = url;
			_width = width;
			_height = height;
			
			/*_mat = new VideoMaterial({file: _url, loop: true});
			//_mat.alpha = .8;
			//_mat.autoUpdate = true;
			_mat.pause();
			_client = new Object();
			_client.onCuePoint = cuePointHandler;
			_mat.netStream.client = _client;
			_mat.netStream.addEventListener(MetadataEvent.CUE_POINT, cuePointHandler);
			//_mat.volume = 0;*/
			
			
			// trying out alpha with video object in a moviematerial
			_mat = new MovieMaterial( Sprite(_screenVideo = new ScreenVideo()), {smooth:true, transparent: true, precision:8} );
			//_screenVideo.vid.volume = 0;
			_screenVideo.vid.smoothing = true;
			_netConnection = new NetConnection();
			_netConnection.connect(null);
			
			_netStream = new NetStream(_netConnection);
			_screenVideo.vid.attachNetStream(_netStream);
			//_screenVideo.vid.smoothing = true;
			_client = new Object();
			_client.onCuePoint = cuePointHandler;
			_netStream.client = _client;
			_netStream.addEventListener(MetadataEvent.CUE_POINT, cuePointHandler);
			
			//_screenVideo.alpha = .5;
			
			//_mat.vid.play(url);
			_p = new Plane({width:_width, height:_height, material:_mat});
			_p.y = 48;
			addChild(_p);
			//this.alpha = .5;
			
			this.visible = false;
			
		}
		
		
		/*********************************** PUBLIC FUNCTIONS ***********************************/
		
		public function start():void
		{
			this.visible = true;
			addChild(_p);
			//_mat.seek(0);
			//_mat.play();
			_screenVideo.alpha = 0;
			
			TweenMax.to(_screenVideo, 1, {autoAlpha: .9});

			
			_netStream.play(_url);
			
			
		}
		
		public function stop():void
		{
			//this.visible = false;
			_screenVideo.alpha = 0;
			_screenVideo.visible = false;
			_netStream.pause();
			removeChild(_p);
			//_mat.pause();
		}
		
		
		/*********************************** PRIVATE FUNCTIONS ***********************************/
		
		
		private function cuePointHandler(info:Object):void
		{
			dispatchEvent(new AppEvent(AppEvent.CUE_POINT, false, false, info));
			Logger.debug('cuepoint: @' + info.time +': ' + info.name);
		}
	}
}