package pwc
{
	
	import away3d.core.base.*;
	import away3d.primitives.Plane;
	import away3d.materials.*;
	import away3d.containers.*;
	
	import com.transmote.flar.marker.FLARMarker;
	import com.transmote.flar.marker.FLARMarkerEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import utils.debug.*;
	
	
	
	public class Marker extends ObjectContainer3D
	{
		
		/*********************************** VARIABLES *******************************************/
		
		private var _id:FLARMarker;
		private var _material:ColorMaterial
		private var _p:Plane;
		
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function Marker()
		{
			_material = new ColorMaterial(0xFF0000);
			_p = new Plane({material:_material});
			_p.y = 0;
			addChild(_p);
		}
		
		
		/*********************************** PRIVATE FUNCTIONS ***********************************/
		
		
	}
}