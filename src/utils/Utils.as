package utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import utils.debug.Logger;
	/**
	 * Various.as
	 * @author Bertrand Niquel
	 */
	public class Utils
	{
		
		public static function ucfirst(str:String):String {
			return String( str.charAt( 0 ).toUpperCase() + str.substr( 1, str.length ) ); 
		}
		
		public static function clearDisplayObjectContainer(d:DisplayObjectContainer):void
		{
			while(d.numChildren > 0) d.removeChildAt(0);
		}
		
		public static function setRegistrationPoint(s:Sprite, regx:Number, regy:Number, showRegistration:Boolean = false):void
		{
			//translate movieclip 
			s.transform.matrix = new Matrix(1, 0, 0, 1, -regx, -regy);
			
			//registration point.
			if (showRegistration)
			{
				var mark:Sprite = new Sprite();
				mark.graphics.lineStyle(1, 0x000000);
				mark.graphics.moveTo(-5, -5);
				mark.graphics.lineTo(5, 5);
				mark.graphics.moveTo(-5, 5);
				mark.graphics.lineTo(5, -5);
				s.parent.addChild(mark);
			}
		}
		
		public static function setVisible(s:Sprite, visible:Boolean):void
		{
			s.visible = visible;
		}
		
		public static function scaleCorrection(d:DisplayObject):void
		{
			
			d.transform.matrix = new Matrix(1, 0, 0, 1, d.x, d.y);
			
			//Logger.debug('d.scaleX: ' + d.scaleX + ' / d.width: ' + d.width);
			//var xfactor:Number = d.width / (d.width + 1);
			//var yfactor:Number = d.height / (d.height + 1);
			//d.scaleX = xfactor;
			//d.scaleY = yfactor;
			//Logger.debug('d.scaleX: ' + xfactor + ' / d.width: ' + d.width);
			
			//var orig_x:Number = d.x;
			//var orig_y:Number = d.y;
			
			
			//d.z=0;
		}
		
		public static function getTextMonth(month:Number):String
		{
			var text_month:String;
			switch(month) {
				case 0:
					text_month = 'January';
					break;
				case 1:
					text_month = 'February';
					break;
				case 2:
					text_month = 'March';
					break;
				case 3:
					text_month = 'April';
					break;
				case 4:
					text_month = 'May';
					break;
				case 5:
					text_month = 'June';
					break;
				case 6:
					text_month = 'July';
					break;
				case 7:
					text_month = 'August';
					break;
				case 8:
					text_month = 'September';
					break;
				case 9:
					text_month = 'October';
					break;
				case 10:
					text_month = 'November';
					break;
				case 11:
					text_month = 'December';
					break;
					
			}
			return text_month;
		}
		
		public static function shuffleArray(arr:Array):Array 
		{
			var len:int = arr.length;
			var temp:*;
			var i:int = len;
			
			while (i--) {
				var rand:int = Math.floor(Math.random() * len);
				temp = arr[i];
				arr[i] = arr[rand];
				arr[rand] = temp;
			}
			return arr;
		}

		
	}

}