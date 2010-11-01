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
	
	import utils.debug.Logger;

	
	public class PlanInstruction3D extends ObjectContainer3D
	{
		
		/*********************************** VARIABLES *******************************************/
		public static const FADE_SPEED:Number = 0.5;
		
		private var _mat:ColorMaterial;
		private var _mat2:ColorMaterial;

		
		[Embed(source="../resources/instruction.png")]
		private var picBitmap:Class;
		[Embed(source="../resources/instruction2.png")]
		private var picBitmap2:Class;
		
		private var _p:Plane;
		private var _p2:Plane;
		
		
		private var _alpha:Number;
		private var _alpha2:Number;
		
		private var _width:int;
		private var _height:int;
		private var _stepAlpha:Number;
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function PlanInstruction3D(width:int, height:int)
		{
			_width = width;
			_height = height;
			_mat = new BitmapMaterial(Cast.bitmap(picBitmap), {smooth:true });
			_mat2 = new BitmapMaterial(Cast.bitmap(picBitmap2), {smooth:true }); 
			this.bothsides = true;			
			_p = new Plane({width:_width, height:_height, material:_mat});
			_p2 = new Plane({width:_width, height:_height, material:_mat2});
			addChild(_p);
			addChild(_p2);
			_p.y = 0;
			_p2.y = 2;
			//_p.rotationY = 180;
			_mat.alpha = 0;
			_mat2.alpha = 0;
			this.visible = false;
		}
		
		
		/*********************************** PUBLIC FUNCTIONS ***********************************/
		
		public function upAlphaOK():void
		{
			//Logger.debug('*********** liflet 3D display - UP mat ALpha : '+_mat.alpha)
			_mat.alpha+=_stepAlpha;
		}
		
		public function downAlphaOK():void
		{
			//Logger.debug('*********** liflet 3D display - DOWN mat ALpha : '+_mat.alpha);
			_mat.alpha-=_stepAlpha;	
		}
		
		public function upAlphaNOK():void
		{
			//Logger.debug('*********** liflet 3D display - UP mat ALpha : '+_mat.alpha)
			_mat2.alpha+=_stepAlpha;
		}
		
		public function downAlphaNOK():void
		{
			//Logger.debug('*********** liflet 3D display - DOWN mat ALpha : '+_mat.alpha);
			_mat2.alpha-=_stepAlpha;	
		}
		
		public function setAlpha(alphaSet:Number):void
		{
			//Logger.debug('*********** liflet 3D display - SET mat ALpha : '+_mat.alpha);
			//_mat.alpha = alphaSet;
			TweenMax.to(_mat, 1.2, { alpha: alphaSet, ease: Strong.easeOut} );
		}
		
		public function setAlphaNOK(alphaSet:Number):void
		{
			//Logger.debug('*********** liflet MAL PLACE : '+_mat2.alpha);
			//_mat.alpha = alphaSet;
			if(_mat2.alpha != alphaSet)
				TweenMax.to(_mat2, 1.2, { alpha: alphaSet, ease: Strong.easeOut} );
		}
		
		public function start():void
		{
			
			//Logger.debug('*********** liflet 3D display start alpha: '+_mat.alpha);
			this.visible = true;
	
			//TweenMax.to(_mat, .5, { alpha: .8, ease: Strong.easeOut, delay: 0 } );
			//TweenMax.to(_p, 1, { onComplete: complete });
		}
		
		public function stop():void
		{
			
			//Logger.debug('************ liflet 3D hide : alpha :'+_mat.alpha);
			//TweenMax.to(this, 1, {autoAlpha:0, ease: Quad.easeOut});
			if(_mat.alpha>0)
			{
				TweenMax.to(_mat, 2.5, { alpha: 0, ease: Strong.easeOut} );
			}
			//this.visible = false;
			//_mat.alpha = 0;
		}
		
		public function switchImage():void
		{
			
			//Logger.debug('************ liflet 3D hide : alpha :'+_mat.alpha);
			//TweenMax.to(this, 1, {autoAlpha:0, ease: Quad.easeOut});
			if(_mat.alpha>0)
			{
				TweenMax.to(_mat, FADE_SPEED, { alpha:0.0 });
				TweenMax.to(_mat2, FADE_SPEED, { alpha:1.0 });
			}	
			//this.visible = false;
			//_mat.alpha = 0;
		}
		
		public function complete():void
		{
			dispatchEvent(new AppEvent(AppEvent.PLANINSTRU_START_COMPLETE));
		}
		
	}
}