package pwc
{
	import away3d.containers.*;	
	import flash.events.Event;

	import utils.debug.Logger;

	public class ObjectAnimation extends ObjectContainer3D
	{
			
		public function ObjectAnimation()
		{
			
		}
		
		/*********************************** PUBLIC FUNCTIONS ***********************************/
		/**																					  **/
		public function start():void
		{
		}
		
		public function stop():void
		{
		}
		
		public function complete():void
		{
			dispatchEvent(new AppEvent(AppEvent.ANIMATION_COMPLETE));
		}
	}
}