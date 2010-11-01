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
	import away3d.core.filter.AnotherRivalFilter;
	import away3d.core.project.MeshProjector;
	import away3d.core.render.QuadrantRenderer;
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
	import com.transmote.flar.utils.geom.AwayGeomUtils;
	import com.transmote.flar.utils.geom.FLARGeomUtils;
	import com.transmote.flar.utils.geom.PVGeomUtils;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import gs.TweenGroup;
	import gs.TweenMax;
	import gs.easing.*;
	
	import pwc.config.Config;
	
	import utils.debug.*;
	
	
	public class PWC_Away3DScene extends Sprite
	{
		
		/*********************************** VARIABLES *******************************************/
		// Away3D
		private var _view3D:View3D;
		private var _camera3D:FLARCamera_Away3D;
		private var _scene3D:Scene3D;
		private var _container:Vector.<ObjectContainer3D> = new Vector.<ObjectContainer3D>();
		private var _containAn:Vector.<ObjectContainer3D> = new Vector.<ObjectContainer3D>();
		private var _light:DirectionalLight3D;
		private var _renderEngine:QuadrantRenderer;
		
		// 3D objects
		private static var CENTER_X_MARKER:int = 330;
		private static var MARGING_LEFT:int = 125;
		private static var MARGING_TOP:int = 50;
		private static var ROTATION:int = 180;		// La vidéo apparait à l'envers. L'inverse pour la remettre dans le bon sens
//		private var _animation:MarkerAnimation;
		private var isObjectShow:Boolean=false;
		private var isInstructionShow:Boolean=false;
		
		//AR var
		private var bMirrorDisplay:Boolean;
		private var markersByPatternId:Vector.<Vector.<FLARMarker>>;	// FLARMarkers, arranged by patternId
		private var activePatternIds:Vector.<int>;						// list of patternIds of active markers
		private var prevActivePatIds:int = -1;
		
		//  TEMP
		private static var NB_MARKERS	: uint = 4;
		private var mTimerShow	: Timer = new Timer(900, 1);
		private var mTimerHide	: Timer = new Timer(1500, 1);
		private var mAnimation	: Vector.<MarkerAnimation> = new Vector.<MarkerAnimation>();
		private var idObjShow	: uint;
		private var cpt			: uint = 0;
		
		private var _cptFrames   : Number = 0;
		private var _tableIds	 : Vector.<Number> = new Vector.<Number>();
		private var _lastTableIds	 : Vector.<Number> = new Vector.<Number>();
		private var _maxFrames   : Number = 8;
		private var _thresholdDetect: Number = 0.4;
		private var _watchTheMiss :  Number = 0;
		private var _watchNext :  Boolean = false;
		private var _iteration : Number=0;
		//private var _prevMarker : Marker;
		
		private var _objInstruction		:PlanInstruction3D;
		private var _sObjInstruction	:ObjectContainer3D;
		private var _containerInstruction	:ObjectContainer3D;
		
		public function PWC_Away3DScene(flarManager:FLARManager, viewportSize:Rectangle)
		{
			this.bMirrorDisplay = flarManager.mirrorDisplay;
			
			this.init();
			this.init3d(flarManager, viewportSize);
			
		}
		
		
		private function init () :void {
			// set up lists (Vectors) of FLARMarkers, arranged by patternId
			this.markersByPatternId = new Vector.<Vector.<FLARMarker>>();
			
			// keep track of active patternIds
			this.activePatternIds = new Vector.<int>();
			
			for( cpt=0; cpt<NB_MARKERS; cpt++ )
			{
				_tableIds[cpt] = 0;
				_lastTableIds[cpt] = 0;
			}
		}
		
		/** init 3d scene/camera/viewport/renderengine **/
		private function init3d (flarManager:FLARManager, viewportSize:Rectangle) :void 
		{
			_scene3D  = new Scene3D();
			_camera3D = new FLARCamera_Away3D(flarManager, viewportSize);
			
			
			//_view3D.forceUpdate = true;
			
			_renderEngine = new QuadrantRenderer(new AnotherRivalFilter(200));
			
			_view3D   = new View3D( {x: 0.5 * viewportSize.width, y: 0.5 * viewportSize.height, scene: _scene3D, camera: _camera3D});
			_view3D.renderer = _renderEngine;
			
			addChild(_view3D);
			
			_objInstruction = new PlanInstruction3D(380,242);
			_containerInstruction = new ObjectContainer3D();
			_sObjInstruction = new ObjectContainer3D();
			_sObjInstruction.addChild( _objInstruction );
			_sObjInstruction.name = "container";
			_sObjInstruction.ownCanvas = true;
			_sObjInstruction.yaw(ROTATION);
			_containerInstruction.addChild( _sObjInstruction );
			_scene3D.addChild(_containerInstruction);
			
			for( cpt=0; cpt<NB_MARKERS; cpt++ )
			{
				_containAn[cpt] = new ObjectContainer3D();
				_container[cpt] = new ObjectContainer3D();
				
				var tmpAnim:MarkerAnimation = new MarkerAnimation(cpt, _view3D, PWC_Away3D.flash_);
				tmpAnim.addEventListener(AppEvent.MOVIE_END, movieEndHandler);
				mAnimation.push( tmpAnim );
				
				_containAn[cpt].addChild( mAnimation[cpt] );
				_containAn[cpt].name = "container";
				_containAn[cpt].yaw(ROTATION);
				_containAn[cpt].ownCanvas = true;

				
				_container[cpt].addChild( _containAn[cpt] );
				_scene3D.addChild(_container[cpt]);				
			}
			
			// Creer des ecouteurs pour le temps
			//mTimerShow.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteShow);
			//mTimerHide.addEventListener(TimerEvent.TIMER_COMPLETE, hideAllDisplayAnimation);
			
			// lighting stage
			//_light = new DirectionalLight3D({x:-1000, y:1000, z:-1000, brightness:1});
			//_scene3D.addChild(light);
			_objInstruction.start();
			_sObjInstruction.alpha = 0;
			addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		
		private function onEnterFrame (evt:Event) :void {			
			//Logger.debug('cpt : '+_cptFrames);
			var i:Number=0;

			if(_cptFrames < _maxFrames)
			{
				for(i=0; i < activePatternIds.length; i++)
				{
	 				_tableIds[this.markersByPatternId[this.activePatternIds[i]][0].patternId] += 1;
					//Logger.debug(this.markersByPatternId[this.activePatternIds[i]][0].patternId);
				}
				//Logger.debug(_cptFrames);
				_cptFrames++;
			}
			else
			{
				//Calcule des moyennes du tableau des presences
				for(i = 0; i < _tableIds.length; i++)
				{
					_tableIds[i] = _tableIds[i]/_maxFrames;
				}
				
				var moy:Number = (_tableIds[0] + _tableIds[1] + _tableIds[2] +_tableIds[3])/4;
				
				if((isObjectShow == true) && (moy <= 0.1)) //moy because we do not want to hide the element curerntly displayed.
				{
					this._iteration = 0;
					hideAllDisplayAnimation();
					_maxFrames = 8;
				}
				
				Logger.debug("iterations : "+this._iteration);
				if (isObjectShow == false){
					
					var cptInf:Number = 0;
					var min:Number = 1;
					var index:uint = 0;
					for(i=0; i< _tableIds.length; i++)
					{
						if(_tableIds[i] < min)
						{
							min = _tableIds[i];
							index = i;
							if(_tableIds[i]<1)
								cptInf++;
						}
					}
					
					switch (this._iteration) 
					{
						case 0 : 
							Logger.debug("case 0 !");
							//trace("case0");
							//trace("activepattern: "+ this.activePatternIds.length);
							if (moy == 1)
							{
								this._iteration = 1;
								this._maxFrames = 4;
							}
							else
								this._iteration = 0;
							break;
						case 1 : 
							Logger.debug("case 1 !");
							//trace("case0");
							//trace("activepattern: "+ this.activePatternIds.length);
							if (moy == 1)
							{
								this._iteration = 2;
								this._maxFrames = 8;
							}
							else
								this._iteration = 0;
							break;
						
						//Passage 1 on stocke les valeures précédentes
						case 2 :
							Logger.debug("case 2 !");
							//trace("case2");
							if((moy<1))
							{
								this._iteration = 3;
								this._maxFrames = 4;
							}
							else
							{
								this._maxFrames = 2;
								this._iteration = 2;
							}
							break;
						
						case 3 :
							//trace("case3");
							Logger.debug("case 3 !");
							
							if ( ((4-cptInf) >2) && (moy>0) )
							{
								this._iteration = 4;
								this._maxFrames = 4;
							}
							else
							{
								this._maxFrames = 8;
								this._iteration = 0;
							}
							break;
						
						case 4 :
							//trace("case4");
							Logger.debug("case 4 !");
							if ( (this._tableIds[index] == 0) && ((4-cptInf) > 2) && (index != 1))
							{
								idObjShow = index;
								this.showObject();
								this._iteration = -1;
								this._maxFrames = 8;
								
								if(index == 0)
									dispatchEvent(new AppEvent(AppEvent.VIDEO1_BEGIN));
								else if(index == 2)
									dispatchEvent(new AppEvent(AppEvent.VIDEO3_BEGIN));
								else if(index == 3)
									dispatchEvent(new AppEvent(AppEvent.VIDEO4_BEGIN));
								
							}
							else if ( _tableIds[1] < 0.5 && ((4-cptInf) >2) && (moy>0) )
							{
								this._iteration = 5;
								this._maxFrames = 4;
							}	
							else
							{
								this._iteration = 0;
								this._maxFrames = 8;
							}	
							break;
						
						case 5 :
							//trace("case 5");
							Logger.debug("case 5 !");
							if ( _tableIds[1] == 0 && ((4-cptInf) >2) && (moy>0) )
							{
								idObjShow = 1;
								this.showObject();
								this._iteration = -1;
								dispatchEvent(new AppEvent(AppEvent.VIDEO2_BEGIN));
							}
							else
								this._iteration = 0;
							
							this._maxFrames = 8;	
							break;	
					}
				}	
				Logger.debug('******************************');
				//trace('******************************');
				for(i = 0; i < _tableIds.length; i++)
				{
					Logger.debug('Value ['+i+'] '+_tableIds[i]);
				//	trace('Value ['+i+'] '+_tableIds[i]);
					_tableIds[i] = 0;
				}
				//trace('******************************');
				Logger.debug('******************************');
				this._cptFrames = 0;
				
				//sauvegarde des anciens échantillons
				for(i = 0; i < _tableIds.length; i++)
				{
					_lastTableIds[i] = _tableIds[i];
				}
			}
				
			if(isObjectShow == false)
			{
				//Activation de l'objet
				if(this.activePatternIds.length>3)
				{
				//	trace("la");
					_objInstruction.setAlphaNOK(0);
					
					_sObjInstruction.alpha = 1;
					//isInstructionShow = true;
					_objInstruction.setAlpha(0.8);
				}
				else if((moy>0.7)&&(this._iteration == 1))
				{
					_objInstruction.alpha = 0.8;
				}
				//on l'enleve dans le cas ou l'on a plus de marqueur
				else if((this.activePatternIds.length < 4)&&(this._iteration > 3))
				{
					//trace("ici");
					//Logger.debug('Current: '+this.activePatternIds.length+' Prev: '+this.prevActivePatIds);
					//_objInstruction.setAlpha(0);
					_objInstruction.stop();
					TweenMax.to(_sObjInstruction, 2.3, { alpha: 0, ease: Strong.easeOut} );
					//isInstructionShow = false;
				}
				else if(moy<0.2)
				{
					_objInstruction.stop();
					TweenMax.to(_sObjInstruction, 0.5, { alpha: 0, ease: Strong.easeOut} );
					hideAllDisplayAnimation();
					//isInstructionShow = false;
				}
				else if( ((moy<1)&&(this._iteration == 0)) || ((this.activePatternIds.length < 3)&&((this.activePatternIds.length > 2))&&(this._iteration == 0)))
				{
					TweenMax.to(_sObjInstruction, 0.5, { alpha: 1, ease: Strong.easeIn} );
					_objInstruction.setAlpha(0);
					_objInstruction.setAlphaNOK(0.8);
				}
				
				
				/*if ((this.activePatternIds.length == this.prevActivePatIds) && (this.activePatternIds.length > 3))
				{
					//Logger.debug('SET SET: '+this.activePatternIds.length+' Prev: '+this.prevActivePatIds);
					
				}*/
			}
			/*else if(isInstructionShow == true)
			{
				Logger.debug('SET SET: '+this.activePatternIds.length+' Prev: '+this.prevActivePatIds);
				_objInstruction.stop();
				TweenMax.to(_sObjInstruction, 2, { alpha: 0, ease: Strong.easeOut} );
				isInstructionShow = false;
			}*/
			
			if((this.activePatternIds.length == 4) && (isObjectShow == false))
			{
				dispatchEvent(new AppEvent(AppEvent.LIFLET_ON));
			}
			else if((this.activePatternIds.length == 3) && (isObjectShow == false))
			{
				dispatchEvent(new AppEvent(AppEvent.LIFLET_ON3));
			}
			else if((this.activePatternIds.length == 2) && (isObjectShow == false))
			{
				dispatchEvent(new AppEvent(AppEvent.LIFLET_ON2));
			}
			else if((this.activePatternIds.length < 2) && (isObjectShow == false))
			{
				dispatchEvent(new AppEvent(AppEvent.LIFLET_OFF));
				hideAllDisplayAnimation();
			}
			
			updateScene();
			_view3D.render();
		}
		
		private function updateScene () :void 
		{
		
		// update all Object containers according to the transformation matrix in their associated FLARMarkers
		var i:int = this.activePatternIds.length;
		var markerList:Vector.<FLARMarker>;
		var marker:FLARMarker;
		var usePatId:int=0;
		var diffMaxX:int = 999;
		var j:int;
		
		if( this.activePatternIds.length > 0 )
		{
			for ( cpt=0; cpt<this.activePatternIds.length; cpt++ )
			{
				marker = this.markersByPatternId[this.activePatternIds[cpt]][0];
				//Logger.debug("["+ marker.patternId +"] : x = "+marker.x+" et y = "+marker.y);
				//trace("cpt = "+cpt+"["+ marker.patternId +"] : x = "+marker.x+" et y = "+marker.y);
				if( Math.abs(CENTER_X_MARKER - marker.x) < diffMaxX )
				{
					diffMaxX = Math.abs(CENTER_X_MARKER - marker.x);
					usePatId = cpt;
				}
			}
			//trace("************ ");
			Logger.debug("************ ");
			
			//trace(diffMaxX + " , " + usePatId);
			marker = this.markersByPatternId[this.activePatternIds[usePatId]][0];
			_container[idObjShow].transform = AwayGeomUtils.convertMatrixToAwayMatrix(marker.transformMatrix, this.bMirrorDisplay);
			_containerInstruction.transform = AwayGeomUtils.convertMatrixToAwayMatrix(marker.transformMatrix, this.bMirrorDisplay);
			
			switch( marker.patternId )
			{
				case 0:
					//Logger.debug('case 0');
					_container[idObjShow].getChildByName("container").x = MARGING_LEFT;
					_container[idObjShow].getChildByName("container").z = MARGING_TOP;
					_containerInstruction.getChildByName("container").x = MARGING_LEFT;
					_containerInstruction.getChildByName("container").z = MARGING_TOP;
					break;
				case 1:	
					//Logger.debug('case 1');
					_container[idObjShow].getChildByName("container").x = -MARGING_LEFT;
					_container[idObjShow].getChildByName("container").z = MARGING_TOP;
					_containerInstruction.getChildByName("container").x = -MARGING_LEFT;
					_containerInstruction.getChildByName("container").z = MARGING_TOP;
					break;
				case 2:	
					//Logger.debug('case 2');
					_container[idObjShow].getChildByName("container").x = MARGING_LEFT;
					_container[idObjShow].getChildByName("container").z = -MARGING_TOP;
					_containerInstruction.getChildByName("container").x = MARGING_LEFT;
					_containerInstruction.getChildByName("container").z = -MARGING_TOP;
					break;
				case 3:	
					//Logger.debug('case 4');
					_container[idObjShow].getChildByName("container").x = -MARGING_LEFT;		
					_container[idObjShow].getChildByName("container").z = -MARGING_TOP;	
					_containerInstruction.getChildByName("container").x = -MARGING_LEFT;
					_containerInstruction.getChildByName("container").z = -MARGING_TOP;
					break;	
			}
		}
				
							/**Logg all active marker :
							Logger.debug('actived marker length[] : ' +this.activePatternIds.length);
							 * */
		}
						
						
		/** Triggered when a marker is pointed to the webcam **/
		/*public function addMarker (marker:FLARMarker) :void 
		{
			this.storeMarker(marker);
			
			Logger.debug('added: '+marker.patternId+', activePatternIds.length: '+ this.activePatternIds.length);
			
			if( prevActivePatIds == this.activePatternIds.length )	return;
			
			mTimerShow.stop();
			mTimerHide.stop();
			
			if( this.activePatternIds.length >= 4 )
			{
				mTimerHide.start();
				// instructions
				// change instruction		
				dispatchEvent(new AppEvent(AppEvent.LIFLET_ON));
			}*/
			/*else if (this.activePatternIds.length >= 3 )
			{
				dispatchEvent(new AppEvent(AppEvent.LIFLET_ON));
				Logger.debug('added: '+marker.patternId+', activePatternIds.length: '+ this.activePatternIds.length);
			}*/
			/*prevActivePatIds = this.activePatternIds.length;
		}*/
		/** Triggered when a marker is pointed to the webcam **/
		public function addMarker (marker:FLARMarker) :void 
		{
			this.storeMarker(marker);
			
			//Logger.debug('added:'+marker.patternId+', nbMarkerDisplay01: '+ this.activePatternIds.length);
			
			if( prevActivePatIds == this.activePatternIds.length )	return;
			
			//mTimerShow.stop();
			//mTimerHide.stop();
			
			prevActivePatIds = this.activePatternIds.length;
		}
		
		/** Triggered when a marker is removed from the webcam **/
		public function removeMarker (marker:FLARMarker) :void 
		{
			if ( !this.disposeMarker(marker) ) 						return;
			
			//Logger.debug('removed'+marker.patternId+', nbMarkerDisplay02: '+ this.activePatternIds.length);
			
			if ( prevActivePatIds == this.activePatternIds.length )	return;
			
			//mTimerShow.stop();
			//mTimerHide.stop();
			
			
			/*if ( this.activePatternIds.length == 3 && !isObjectShow )
			{
				idObjShow = marker.patternId;
				mTimerShow.start();				
			}
			else if	( this.activePatternIds.length == 0 )
			{
				mTimerHide.start();
				// instructions off
				dispatchEvent(new AppEvent(AppEvent.LIFLET_OFF));
				_objInstruction.stop();
			}*/
			
			prevActivePatIds = this.activePatternIds.length;
		}
		
		private function storeMarker (marker:FLARMarker) :void {
			// store newly-detected marker.
			
			var markerList:Vector.<FLARMarker>;
			if (marker.patternId < this.markersByPatternId.length) {
				// check for existing list of markers of this patternId...
				markerList = this.markersByPatternId[marker.patternId];
			} else {
				this.markersByPatternId.length = marker.patternId + 1;
			}
			if (!markerList) {
				// if no existing list, make one and store it...
				markerList = new Vector.<FLARMarker>();
				this.markersByPatternId[marker.patternId] = markerList;
				this.activePatternIds.push(marker.patternId);
			}
			// ...add the new marker to the list.
			markerList.push(marker);
		}
		
		private function disposeMarker (marker:FLARMarker) :Boolean {
			// find and remove marker.
			// returns false if marker's patternId is not currently active.
			
			var markerList:Vector.<FLARMarker>;
			if (marker.patternId < this.markersByPatternId.length) {
				// get list of markers of this patternId
				markerList = this.markersByPatternId[marker.patternId];
			}
			if (!markerList) {
				// patternId is not currently active; something is wrong, so exit.
				return false;
			}
						
			var markerIndex:uint = markerList.indexOf(marker);
			if (markerIndex != -1) {
				markerList.splice(markerIndex, 1);
				if (markerList.length == 0) {
					this.markersByPatternId[marker.patternId] = null;
					var patternIdIndex:int = this.activePatternIds.indexOf(marker.patternId);
					if (patternIdIndex != -1) {
						this.activePatternIds.splice(patternIdIndex, 1);
					}
				}
			}
			
			return true;
		}
		
		// hide all animation
		private function hideAllDisplayAnimation(e:TimerEvent=null):void
		{
			for(cpt=0; cpt<NB_MARKERS; cpt++)
			{
				mAnimation[cpt].stop();
				_objInstruction.stop();
				_containAn[cpt].alpha = 0;
				dispatchEvent(new AppEvent(AppEvent.LIFLET_OFF));
			}
			isObjectShow = false;
		}
		
		// Show the animation after a specify time
		private function timerCompleteShow(e:TimerEvent):void
		{
			//Logger.debug('idObjShow: '+ idObjShow);
			hideAllDisplayAnimation();
			_objInstruction.stop();
			//_scene3D.addChild(_container[idObjShow]);
			mAnimation[idObjShow].start();
			this.begin();
			isObjectShow = true;
		}
		
		private function showObject():void
		{
			//Logger.debug('idObjShow: '+ idObjShow);
			hideAllDisplayAnimation();
			_objInstruction.stop();
			//_scene3D.addChild(_container[idObjShow]);
			_containAn[idObjShow].alpha = 1;
			mAnimation[idObjShow].start();
			this.begin();
			isObjectShow = true;
		}
		
		private function movieEndHandler(e:AppEvent):void
		{
			this._iteration = 0;
			hideAllDisplayAnimation();
		}
		
		public function begin():void
		{
			//Logger.debug('begin animation');
			dispatchEvent(new AppEvent(AppEvent.ANIMATION_BEGIN));
		}
	}
}