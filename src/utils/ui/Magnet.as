package utils.ui {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gs.easing.Strong;
	import gs.TweenLite;
	
	/**
	 * Magnet.as
	 * @author Adrien Felsmann
	 */
	public class Magnet {
		
		/*********************************** VARIABLES *******************************************/
		
		private var _target:Object;
		private var _attractor:Object;
		private var _distance:Number;
		private var _targetBounds:Object;
		private var _attractorBounds:Object;
		
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		/**
		 * Build a new magnetic interaction between the given target and his attractor
		 * @param	target
		 * @param	attractor
		 * @param	distance
		 * @param	targetBounds
		 * @param	attractorBounds
		 */
		public function Magnet(
					target:Object = null,
					attractor:Object = null,
					distance:Number = 10,
					targetBounds:Object = null,
					attractorBounds:Object = null
				) {
			
			_target = target;
			_attractor = attractor;
			_distance = distance;
			_targetBounds = targetBounds;
			_attractorBounds = attractorBounds;
			
			_target.addEventListener(MouseEvent.MOUSE_DOWN, targetMouseDownHandler);
			_target.addEventListener(MouseEvent.MOUSE_UP, targetMouseUpHandler);
		}
		
		
		/*********************************** STATIC FUNCTIONS ************************************/
		
		/**
		 * Static shortcut to build a new Magnet instance
		 * @param	target
		 * @param	attractor
		 * @param	distance
		 * @param	targetBounds
		 * @param	attractorBounds
		 * @return
		 */
		public static function ize(
					target:Object = null,
					attractor:Object = null, distance:Number = 10,
					targetBounds:Object = null,
					attractorBounds:Object = null
				):Magnet {
			
			return new Magnet(target, attractor, distance, targetBounds, attractorBounds);
		}
		
		
		/*********************************** EVENT HANDLERS **************************************/
		
		/**
		 * Drag the targeted object
		 * @param	e
		 */
		private function targetMouseDownHandler(e:MouseEvent):void {
			e.currentTarget.startDrag();
		}
		
		/**
		 * Stop dragging the targeted object and stick it to his attractor if its near
		 * @param	e
		 */
		private function targetMouseUpHandler(e:MouseEvent):void {
			e.currentTarget.stopDrag();
			
			var targetBounds:Object;
			if (_targetBounds) targetBounds = _targetBounds;
			else targetBounds = _target;
			
			var attractorBounds:Object;
			if (_attractorBounds)  attractorBounds = _attractorBounds;
			else  attractorBounds = _attractor;
			
			// Top
			if ((_target.y > attractorBounds.y - _distance) && (_target.y < attractorBounds.y + _distance)) {
				TweenLite.to(_target, .3, { y: attractorBounds.y, ease: Strong.easeOut, overwrite: false } );
			}
			
			// Right
			if ((_target.x + targetBounds.width > attractorBounds.x + attractorBounds.width - _distance) && (_target.x + targetBounds.width < attractorBounds.x + attractorBounds.width + _distance)) {
				TweenLite.to(_target, .3, { x: attractorBounds.x + attractorBounds.width - targetBounds.width, ease: Strong.easeOut, overwrite: false } );
			}
			
			// Bottom
			if ((_target.y + targetBounds.height > attractorBounds.y + attractorBounds.height - _distance) && (_target.y + targetBounds.height < attractorBounds.y + attractorBounds.height + _distance)) {
				TweenLite.to(_target, .3, { y: attractorBounds.y + attractorBounds.height - targetBounds.height, ease: Strong.easeOut, overwrite: false } );
			}
			
			// Left
			if ((_target.x > attractorBounds.x - _distance) && (_target.x < attractorBounds.x + _distance)) {
				TweenLite.to(_target, .3, { x: attractorBounds.x, ease: Strong.easeOut, overwrite: false } );
			}
		}
	}
}