package pwc
{
	import flash.events.Event;
	
	/**
	 * AppEvent.as
	 * @author Bertrand Niquel
	 */
	public class AppEvent extends Event 
	{
		/*********************************** VARIABLES *******************************************/
		private var _obj:Object;
		
		/*********************************** CONSTANTS *******************************************/
		public static const PLANINSTRU_START_COMPLETE:String = "planInstruStartComplete"
		
		public static const LIFLET_ON:String  = "lifletOn";
		public static const LIFLET_ON2:String = "lifletOn2";
		public static const LIFLET_ON3:String = "lifletOn3";
		
		public static const LIFLET_OFF:String = "lifletOff";
		
		public static const CUE_POINT:String = "cuePoint";
		
		public static const ANIMATION_COMPLETE:String = "animationComplete";
		public static const ANIMATION_BEGIN:String = "animationBegin";
		
		public static const VIDEO1_BEGIN:String = "video1";
		public static const VIDEO2_BEGIN:String = "video2";
		public static const VIDEO3_BEGIN:String = "video3";
		public static const VIDEO4_BEGIN:String = "video4";
		
		public static const MOVIE_END:String = "movieend";
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function AppEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, obj:Object=null) 
		{ 
			super(type, bubbles, cancelable);
			
			_obj = obj;
		} 
		
		
		/*********************************** PUBLIC FUNCTIONS ************************************/
		
		public override function clone():Event 
		{ 
			return new AppEvent(type, _obj, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MenuEvent", "type", "bubbles", "cancelable", "eventPhase", "obj"); 
		}
		
		public function get obj():Object {
			return _obj;
		}
		
	}
	
}