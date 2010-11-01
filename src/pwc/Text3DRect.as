package pwc
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Bertrand Niquel
	 */
	public class Text3DRect extends Sprite
	{
		
		public function Text3DRect(regX:Number, regY:Number, width:int, height:int, color:uint):void
		{
			graphics.beginFill(color);
			graphics.drawRect(regX,regY,width,height);
			graphics.endFill();
		}
		
	}

}