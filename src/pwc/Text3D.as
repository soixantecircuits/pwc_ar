package pwc
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.utils.Cast;
	import away3d.events.IteratorEvent;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import gs.plugins.TweenPlugin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextLineMetrics;

	
	import gs.TweenMax;
	import gs.easing.*;
	
	import utils.debug.*;
	import utils.*;
	
	public class Text3D extends ObjectContainer3D
	{
		
		/*********************************** VARIABLES *******************************************/
		
		private var _dt:DynamicText;
		private var _mat:MovieMaterial;
		private var _p:Plane;
		private var _y:int = 300;
		private var _amplitude:int = 50;
		private var _text:String;
		private var _margin:int = 32;
		private var _maxChars:int = 10;
		
		// stores the number of Text3D instances
		private var _id:int;
		public static var _count_texts:int = 0;
		
		// background colors
		private var _bg_color1:String;
		private var _bg_color2:String;
		
		// rectangles
		private var _smallRect:Text3DRect;
		private var _bigRect:Text3DRect;
		
		private var _aCoords:Array = [ { x: -460, z: 215,  y: 160 },
									   { x: 460,  z: 215,  y: 160 },
									   { x: 460,  z: -220, y: 160 },
									   { x: -460, z: -220, y: 160 }];
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function Text3D(text:String, bg_color1:String, bg_color2:String)
		{
			this.visible = false;
			
			_text = text;
			trace("text : "+_text);
			
			_bg_color1 = bg_color1;
			_bg_color2 = bg_color2;
			
			// set material
			_mat = new MovieMaterial( Sprite(_dt = new DynamicText()), {smooth:true, precision:8 } );
			_p = new Plane( { material:_mat } );
			addChild(_p);
			
			// lock material width to avoid text to get stretched
			_mat.lockW = 1000;
			_mat.lockH = 150;
			
			//_dt.tf.defaultTextFormat = 
			
			_dt.tf.autoSize = TextFieldAutoSize.LEFT;
			
			_id = _count_texts;
			
			if(_count_texts < 3)
				_count_texts ++;
			else
				_count_texts = 0;
			
			scale(0.5);
			
			
			showText();
		}
		
		
		
		/*********************************** PUBLIC FUNCTIONS ***********************************/
		
		
		public function showText():void
		{
			this.visible = true;
			
			// set texts to lowercase
			//_dt.tf.text = _text.toLowerCase();
			//_dt.tf.text = _text;
			_dt.tf.htmlText = _text;
			
			var words:Array = _text.split(' ');
			
			if (words.length > 1)
			{
				
				var format:TextFormat = new TextFormat();
				format.size = 31;
				_dt.tf.setTextFormat(format);
				_dt.tf.multiline = true;
				_dt.tf.wordWrap = true;
				_dt.tf.height = 80;
				
				if(_text.search("'") == 6 )
				{
				//	trace("apostrophe");
					_dt.tf.width = _dt.tf.textWidth + 5;
				}
				else	
				{
				//	trace("nop");
					_dt.tf.width = _dt.tf.textWidth;
				}
				//trace("nop :" + _text.search("'"));
			}
			
			
			// set a few properties for _p
			_p.width = _mat.width;
			_p.height = _mat.height;
			//_p.rotationX = 90;
			
			
			// set x/y/z for _p
			_p.x = _aCoords[_id].x;
			_p.y = _aCoords[_id].y;
			_p.z = _aCoords[_id].z;
			
			// place rectangles
			placeSmallRect();
			placeBigRect();
			_dt.addChild(_dt.tf);
			
			Logger.debug('_smallRect.width: ' + _smallRect.width);
			Logger.debug('_smallRect.height: ' + _smallRect.height);
			
			// x center material on plane
			_mat.offsetX = _p.width / 2 - _dt.width / 2;
			
			// initializing sprites
			_dt.tf.alpha = 0;
			_bigRect.scaleX = _bigRect.scaleY = 0;
			_smallRect.scaleX = _smallRect.scaleY = 0;
			_bigRect.alpha = 0;
			_smallRect.alpha = 0;
			
			
			// using tweenmax to change background colors (simplest way to do it in AS3)
			// replace 'null' with the hex color code
			TweenMax.to(_bigRect, 0, { tint: _bg_color1 } );
			TweenMax.to(_smallRect, 0, { tint: _bg_color2 } );
			
			
			// animation
			TweenMax.to(_smallRect, 1, { scaleX: 1, scaleY: 1, alpha: 1, ease: Strong.easeOut } );
			TweenMax.to(_bigRect, 1, { scaleX: 1, scaleY: 1, alpha: 1, ease: Strong.easeInOut, delay: .2 } );
			TweenMax.to(_dt.tf, .5, {autoAlpha: 1, startAt: {autoAlpha: 0}, delay: 1 });
			
			// this controls the time before we hide the text
			TweenMax.to(this, 0, {delay: 3, onComplete: hideText});
		}
		
		/**
		 * handles the placement and register point of the small rectangle
		 */
		private function placeSmallRect():void
		{
			var rectX:int;
			var rectY:int;
			var rectRegX:int;
			var rectRegY:int;
			var rectWidth:int = _margin;
			var rectHeight:int = _margin;
			
			// we give x the value of 1 instead of 0 to 
			// avoid a display bug
			
			// top left
			if (_aCoords[_id].x < 0 && _aCoords[_id].z > 0)
			{
				Logger.debug('top left');
				rectX = _dt.tf.width + 20 + (rectWidth * 2);
				rectY = 144;
				rectRegX = -rectWidth;
				rectRegY = -rectHeight;
				
			}
				// bottom left
			else if (_aCoords[_id].x < 0 && _aCoords[_id].z < 0)
			{
				Logger.debug('bottom left');
				rectX = _dt.tf.width + 20 + (rectWidth * 2);
				rectY = 0;
				rectRegX = -rectWidth;
				rectRegY = 0;
			}
				// bottom right
			else if (_aCoords[_id].x > 0 && _aCoords[_id].z < 0)
			{
				Logger.debug('bottom right');
				rectX = 1;
				rectY = 0;
				rectRegX = 0;
				rectRegY = 0;
			}
				// top right
			else if (_aCoords[_id].x > 0 && _aCoords[_id].z > 0)
			{
				Logger.debug('top right');
				rectX = 1;
				rectY = 144;
				rectRegX = 0;
				rectRegY = -rectHeight;
			}
			
			_smallRect = new Text3DRect(rectRegX, rectRegY, rectWidth, rectHeight, 0xff00ff);
			_smallRect.x = rectX;
			_smallRect.y = rectY;
			_dt.addChild(_smallRect);
			
		}
		
		/**
		 * handles the placement and register point of the big rectangle
		 */
		private function placeBigRect():void
		{
			var rectX:int;
			var rectY:int;
			var rectRegX:int;
			var rectRegY:int;
			var rectWidth:int = _dt.tf.width + 20;
			var rectHeight:int = _dt.tf.height;
			
			// top left
			if (_aCoords[_id].x < 0 && _aCoords[_id].y > 0)
			{
				rectX = rectWidth + _margin;
				rectY = rectHeight + _margin;
				rectRegX = -rectWidth;
				rectRegY = -rectHeight;
				
			}
				// bottom left
			else if (_aCoords[_id].x < 0 && _aCoords[_id].y < 0)
			{
				rectX = rectWidth + _margin;
				rectY = _margin;
				rectRegX = -rectWidth;
				rectRegY = 0;
			}
				// bottom right
			else if (_aCoords[_id].x > 0 && _aCoords[_id].y < 0)
			{
				rectX = _margin;
				rectY = _margin;
				rectRegX = 0;
				rectRegY = 0;
			}
				// top right
			else if (_aCoords[_id].x > 0 && _aCoords[_id].y > 0)
			{
				Logger.debug('top right');
				rectX = _margin;
				rectY = _margin + rectHeight;
				rectRegX = 0;
				rectRegY = -rectHeight;
			}
			
			_bigRect = new Text3DRect(rectRegX, rectRegY, rectWidth, rectHeight, 0xff00ff);
			_bigRect.x = rectX;
			_bigRect.y = rectY;
			_dt.addChild(_bigRect);
			
		}
		
		private function hideText():void
		{
			TweenMax.to(_dt, 1, {autoAlpha: 0, onComplete: remove });
			
		}
		
		/**
		 * resets all vars to null and removes _p from being rendered
		 */
		private function remove():void
		{
			removeChild(_p);
			_p = null;
			
			_dt = null;
			_mat = null;
			_y = NaN;
			_amplitude = NaN;
			_text = null;
			_id = NaN;
			_margin = NaN;
			
			_smallRect = null;
			_bigRect = null;
		}
		
	}
}