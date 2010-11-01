package utils {
	
	/**
	 * Maths.as
	 * @author Adrien Felsmann
	 */
	public class Maths {
		
		/**
		 * Return the given number with 0 before if the number is not much long
		 * @param	number
		 * @param	n
		 * @return
		 */
		public static function formatTime(number:int, n:int):String {
			var num:String = number.toString();
			var numLength:int = number.toString().length;
			
			if (numLength < n) {
				while (numLength < n) {
					num = '0' + num.toString();
					numLength++;
				}
			}
			
			return num;
		}
	}
}