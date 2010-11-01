package utils {
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * Delay.as
	 * Timer Shortcut Class
	 * @author Adrien Felsmann
	 */
	public class Delay {
		
		/*********************************** VARIABLES *******************************************/
		
		private static var _callback:Function;
		
		
		/*********************************** PUBLIC FUNCTIONS ************************************/
		
		/**
		 * Execute a callback function with a specified delay and loop
		 * Delay.execute(callback, delay, loop);
		 * @param	callback
		 * @param	delay
		 * @param	loop
		 */
		public static function execute(callback:Function, delay:Number, loop:int=0):void {
			_callback = callback;
			var timer:Timer = new Timer(delay, loop);
			timer.addEventListener(TimerEvent.TIMER, _callback);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, removeTimer);
			timer.start();
		}
		
		private static function removeTimer(e:TimerEvent):void {
			e.target.removeEventListener(TimerEvent.TIMER, _callback);
			e.target.removeEventListener(TimerEvent.TIMER_COMPLETE, removeTimer);
		}
	}
}