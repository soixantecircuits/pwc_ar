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
	
	import gs.TweenMax;
	import gs.easing.*;
	
	//public class Flip3D extends ObjectContainer3D
	public class Flip3D extends ObjectAnimation
	{
		
		/*********************************** VARIABLES *******************************************/
		
		private var _mat:ColorMaterial;
		
		// [Embed(source="pic.jpg")]
		// private var picBitmap:Class;
		
		private var _p:Plane;
		
		private var _width:int;
		private var _height:int;
		
		[Embed(source="../resources/pic.png")]
		private var picBitmap:Class;
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function Flip3D(width:int, height:int)
		{
			
			_width = width;
			_height = height;
			
			_mat = new ColorMaterial(0xC73F0B);
			
			// à remplacer par _material = new BitmapMaterial(Cast.bitmap(picBitmap)) 
			// où bitmapmaterial fait référence à un jpeg en embed du type
			// à décommenter dans les variables et à cibler vers le bon jpeg
			// dans l'idéal, je pense à la première frame de la video en question
			
			
			_p = new Plane({width:_width, height:_height, material:_mat}); 
			//_p.y = 50;
			addChild(_p);
			
			this.visible = false;
			
		}
		
		
		/*********************************** PUBLIC FUNCTIONS ***********************************/
		
		public override function start():void
		{
			this.visible = true;
			
			_mat.alpha = 0;
			_p.y = 0;
			//_p.rotationX = 90;
			
			_p.width = _p.height = 0;
			
			TweenMax.to(_mat, .5, { alpha: .8, ease: Strong.easeOut, delay: 1 } );
			TweenMax.to(_p, .5, { width: _width, startAt: { height: 2 }, ease: Strong.easeInOut, delay: 1 } );
			TweenMax.to(_p, .5, { height: _height, ease: Strong.easeOut, delay: 1.6 } );
			//fix z as y value for the position depth
			TweenMax.to(_p, 1, { y: 46, rotationX: 360, startAt: {rotationX: 0}, ease: Strong.easeOut, delay: 2.1 } );
			TweenMax.to(_p, 3.1, { onComplete: complete });
			
		}
		
		public override function stop():void
		{
			this.visible = false;
		}
		
		
	}
}