package pwc
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.utils.Cast;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import gs.TweenMax;
	import gs.easing.*;
	
	import utils.debug.Logger;

	
	//public class Fractal3D extends ObjectContainer3D
	public class Fractal3D extends ObjectAnimation
	{
		
		/*********************************** VARIABLES *******************************************/
		
		
		//private var _mat:ColorMaterial;
		//private var _p:Plane;
		//private var _:Plane;
		
		[Embed(source="../resources/pic3.png")]
		private var picBitmap:Class;
		
		private var _width:int;
		private var _height:int;
		private var _viewWidth:int;
		private var _viewHeight:int;
		
		private var _tiles:Vector.<Plane>;
		
		
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function Fractal3D(width:int, height:int, viewWidth:int, viewHeight:int)
		{
			_width = width/2;
			_height = height/2;
			
			_viewWidth = viewWidth;
			_viewHeight = viewHeight;
			scale(0.5);
			
			this.x = - _width + 70;
			this.z = _height - 30;
			this.y = 46;
			
			//this.rotationX = 90;
			_tiles = new Vector.<Plane>();
			this.visible = false;
		}
		
		
		/*********************************** PUBLIC FUNCTIONS ***********************************/
		
		public override function start():void
		{
			Logger.debug('flash3d start');
			this.visible = true;
			
			  //magic number		
			  //this.x -= 25;
			  //this.z -= 25;
			  var w:Number;
			  var h:Number;
			  var cols:Number = 8;
			  var rows:Number = 8;
			  
			  
			     var image:BitmapData = Bitmap(new picBitmap()).bitmapData;
			     w = image.width;
			     h = image.height;
			     var tileWidth:Number = w / cols;
			     var tileHeight:Number = h / rows;
			     var inc:int = 0;
			     var pnt:Point = new Point();
			     var rect:Rectangle = new Rectangle(0,0,tileWidth,tileHeight);
			     for (var i:int = 0; i<rows; i++){
				         for (var j:int = 0; j<cols; j ++){
					    var currTile:BitmapData= new BitmapData(tileWidth, tileHeight, true, 0x00000000);
					    rect.x = j * tileWidth;
					    rect.y = i * tileHeight;
					    currTile.copyPixels(image, rect, pnt, null, null, true);
					    var bit:Bitmap = new Bitmap(currTile, "auto", false);
					    var mat:BitmapMaterial = new BitmapMaterial(bit.bitmapData, {smooth:true });
						var s:Plane = _tiles[inc] = new Plane( { material:mat } );

					    //s.bothsides = true;
					    s.width = tileWidth;
					    s.height = tileHeight;
					    var sX:int = s.x = rect.x;
					    var sY:int =  s.z = -rect.y;
					    mat.alpha = .5;
					    
					    s.x = - _viewWidth  + Math.random() * _viewWidth * 3;
					    s.z = - _viewHeight + Math.random() * _viewHeight * 3;
					    s.y = 10 + Math.random() * 46;
					
					    TweenMax.to(mat, .6, {alpha:1, delay:1 +inc / 400, ease: Quad.easeIn});
					    TweenMax.to(s, .6, {x:sX, z:sY, y:0, alpha:1, delay:1 + inc / 400, ease: Quad.easeIn});
					    
					    addChild(s);
					    inc++;
				        }
			     }
			
		TweenMax.to(this, 1.6, { onComplete: complete });
		}
		
		//_screen.removeEventListener(Event.ENTER_FRAME, screenEnterFrameHandler);
		public override function stop():void
		{
				this.visible = false;
				
				for (var i:int = 0; i < _tiles.length; i++) 
				{
					removeChild(_tiles[i]);
				}
				
		}
		
		public override function complete():void
		{
			TweenMax.to(this, 1, {autoAlpha:0, ease: Quad.easeOut});
			TweenMax.to(this, 0, { onComplete: dispatchEvent, onCompleteParams: [new AppEvent(AppEvent.ANIMATION_COMPLETE)] });
		}
		
		
		/*********************************** PRIVATE FUNCTIONS ***********************************/
		
		
	}
}