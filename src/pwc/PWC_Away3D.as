package pwc
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.*;
	import away3d.core.draw.DrawTriangle;
	import away3d.core.draw.ScreenVertex;
	import away3d.core.project.MeshProjector;
	import away3d.core.utils.Debug;
	import away3d.core.utils.FaceVO;
	import away3d.events.Loader3DEvent;
	import away3d.lights.DirectionalLight3D;
	import away3d.loaders.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	
	import com.transmote.flar.FLARManager;
	import com.transmote.flar.camera.FLARCamera_Away3D;
	import com.transmote.flar.marker.FLARMarker;
	import com.transmote.flar.marker.FLARMarkerEvent;
	import com.transmote.flar.tracker.FLARToolkitManager;
	import com.transmote.flar.utils.*;
	import com.transmote.flar.utils.geom.AwayGeomUtils;
	import com.transmote.flar.utils.geom.FLARGeomUtils;
	import com.transmote.flar.utils.geom.PVGeomUtils;
	import com.transmote.flar.utils.smoother.IFLARMatrixSmoother;
	import com.transmote.flar.utils.threshold.IThresholdAdapter;
	import com.transmote.flar.utils.threshold.IntegralImageThresholdAdapter;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	import gs.TweenMax;
	import gs.easing.*;
	
	import pwc.config.Config;
	
	import utils.debug.*;
	
	//public class PWC_Away3D extends Base_web
	public class PWC_Away3D extends Base
	{
		
		/*********************************** VARIABLES *******************************************/
		
		// FLARManager
		private var _fm:FLARManager;
		private var _marker:FLARMarker;
		
		private var _pwc3DScene:PWC_Away3DScene;
		public static var flash_:Flash3D;
		
		private var _instructionVideo1:Boolean = false;
		private var _instructionVideo2:Boolean = false;
		private var _instructionVideo3:Boolean = false;
		private var _instructionVideo4:Boolean = false;
		
		//private var thresholdAdapt:IntegralImageThresholdAdapter;
		//private var IFLARMatrixSmoother:IFLARMatrixSmoother;
		//private var IntegralImageThresholdAdapter;
		//private var MyCustomThresholdAdapter:IntegralImageThresholdAdapter;
		private var MyCustomSmoother:IFLARMatrixSmoother;
		
		private var _instruction:Boolean = false;
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function PWC_Away3D()
		{
			addEventListener(Event.ADDED_TO_STAGE, initFLAR); // making sure our stage is instanciated

			flash_ = new Flash3D(Config.VIEWPORT_3D_WIDTH, Config.VIEWPORT_3D_HEIGHT);
			
			mc_filter.blendMode = BlendMode.SCREEN;
		}
		
		
		/*********************************** PRIVATE FUNCTIONS ***********************************/
		
		/** init FLAR Manager **/
		private function initFLAR(e:Event):void
		{
			Logger.debug('initFLAR');
			this.removeEventListener(Event.ADDED_TO_STAGE, initFLAR);
			
			// create FLARManager instance and adding events
			_fm = new FLARManager("flarConfig.xml", new FLARToolkitManager(), this.stage);
						
			_fm.addEventListener(FLARMarkerEvent.MARKER_ADDED, markerAddedHandler);
			_fm.addEventListener(FLARMarkerEvent.MARKER_REMOVED, markerRemovedHandler);
			_fm.addEventListener(Event.INIT, init3d);
			
			
			// add FLARManager on stage so we have the webcam running
			mc_webcam.addChild(Sprite(_fm.flarSource));
			mc_webcam.addChild(flash_);
		}
		
		/** init 3d scene/camera/viewport/renderengine **/
		private function init3d(e:Event = null):void
		{			
			Logger.debug('init3D');
			_pwc3DScene = new PWC_Away3DScene(_fm, new Rectangle(0, 0, Config.VIEWPORT_3D_WIDTH, Config.VIEWPORT_3D_HEIGHT));
			mc_webcam.addChild(_pwc3DScene);	
			
			// get events from _pwc3DScene
			_pwc3DScene.addEventListener(AppEvent.LIFLET_ON, lifletOnHandler);
			_pwc3DScene.addEventListener(AppEvent.LIFLET_ON2, lifletOnHandler2);
			_pwc3DScene.addEventListener(AppEvent.LIFLET_ON3, lifletOnHandler3);
			_pwc3DScene.addEventListener(AppEvent.LIFLET_OFF, lifletOffHandler);
			
			_pwc3DScene.addEventListener(AppEvent.VIDEO1_BEGIN, video1Handler);
			_pwc3DScene.addEventListener(AppEvent.VIDEO2_BEGIN, video2Handler);
			_pwc3DScene.addEventListener(AppEvent.VIDEO3_BEGIN, video3Handler);
			_pwc3DScene.addEventListener(AppEvent.VIDEO4_BEGIN, video4Handler);
			
			_pwc3DScene.addEventListener(AppEvent.ANIMATION_BEGIN, animationBegin);
			
			// activate blur filter on camera
			/** blur on the whole image
			//mc_webcam.filters = [new BlurFilter(20, 20, 2)];*/
			/**only blur in the back not in the front*/
			/*Sprite(_fm.flarSource).filters = [new BlurFilter(20, 20, 2)];*/
			
		}
		
		
		
		
		/** Triggered when a marker is pointed to the webcam **/
		private function markerAddedHandler(e:FLARMarkerEvent):void
		{
			//Logger.debug('added');
			_pwc3DScene.addMarker(e.marker);
			
		}
		
		
		/** Triggered when a marker is removed from the webcam **/
		private function markerRemovedHandler(e:FLARMarkerEvent):void
		{
			//Logger.debug('removed');
			_pwc3DScene.removeMarker(e.marker);
			
		}
		
		
		
		/** Triggered when all markers are active **/
		private function lifletOnHandler(e:AppEvent):void
		{
			//Logger.debug('lifletOnHandler');	
			// remove filter
			/**the whole image
			TweenMax.to(mc_filter, 1, {autoAlpha: .5})
			TweenMax.to(mc_webcam, 1, {blurFilter:{blurX:0, blurY:0}})
			 * */

			/**Only the webcam*/
			/*TweenMax.to(Sprite(_fm.flarSource), 1, {blurFilter:{blurX:20, blurY:20}});
			TweenMax.to(mc_filter, 1, {autoAlpha: .5});*/
			// instructions
			TweenMax.to(Sprite(_fm.flarSource), 1, {blurFilter:{blurX:10, blurY:10}});
			if(this._instruction == false)
			{
				this._instruction = true;
				TweenMax.to(mc_instructions, 1, { y: 1026, ease: Strong.easeInOut });
			}
		}
		
		/** Triggered when all markers are active **/
		private function lifletOffHandler(e:AppEvent):void
		{
			//Logger.debug('lifletOffHandler');
			// remove filter
			/**the whole image
			TweenMax.to(mc_filter, 1, {autoAlpha: 1});
			TweenMax.to(mc_webcam, 1, {blurFilter:{blurX:20, blurY:20}});
			 * */
			
			/**Only the webcam*/
			TweenMax.to(Sprite(_fm.flarSource), 1, {blurFilter:{blurX:0, blurY:0}});
			TweenMax.to(mc_filter, 1, {autoAlpha: 1});
			
			
			// instructions
			if(this._instruction == true)
			{
				this._instruction = false;
				this._instructionVideo1 = false;
				this._instructionVideo2 = false;
				this._instructionVideo3 = false;
				this._instructionVideo4 = false;
				
				TweenMax.to(mc_instructions, 1, { y: 898, ease: Strong.easeInOut });
			}
		}
		private function lifletOnHandler2(e:AppEvent):void
		{			
			/**Only the webcam*/
			TweenMax.to(Sprite(_fm.flarSource), 1, {blurFilter:{blurX:4, blurY:4}});
		}
		private function lifletOnHandler3(e:AppEvent):void
		{
			TweenMax.to(Sprite(_fm.flarSource), 1, {blurFilter:{blurX:8 , blurY:8}});
		}
		
		private function animationBegin(e:AppEvent):void
		{
			Logger.debug('animationBeginfilter');
			TweenMax.to(Sprite(_fm.flarSource), 1, {blurFilter:{blurX:30, blurY:30}});
			TweenMax.to(mc_filter, 1, {autoAlpha: .8});
		}
		
		private function video1Handler(e:AppEvent):void
		{
			if(this._instructionVideo1 == false)
			{
				this._instruction = true;
				this._instructionVideo1 = true;
				TweenMax.to(mc_instructions, 1, { y: 1130, ease: Strong.easeInOut });
			}
		}
		private function video2Handler(e:AppEvent):void
		{
			if(this._instructionVideo2 == false)
			{
				this._instruction = true;
				this._instructionVideo2 = true;
				TweenMax.to(mc_instructions, 1, { y: 1226, ease: Strong.easeInOut });
			}
		}
		private function video3Handler(e:AppEvent):void
		{
			if(this._instructionVideo3 == false)
			{
				this._instruction = true;
				this._instructionVideo3 = true;
				TweenMax.to(mc_instructions, 1, { y: 1328, ease: Strong.easeInOut });
			}
		}
		private function video4Handler(e:AppEvent):void
		{
			if(this._instructionVideo4 == false)
			{
				this._instruction = true;
				this._instructionVideo4 = true;
				TweenMax.to(mc_instructions, 1, { y: 1438, ease: Strong.easeInOut });
			}
		}
		
	}
}