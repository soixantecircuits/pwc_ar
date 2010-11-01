package pwc.config {

	
	/**
	 * Config.as
	 * @author Bertrand Niquel
	 */
	public class Config {
		
		/*********************************** CONSTANTS *******************************************/
		
		/**
		 * Project settings
		 */
		public static const TITLE:String = '';
		
		/**
		 * Flash settings
		 */
		public static const STAGE_WIDTH:Number = 0;
		public static const STAGE_HEIGHT:Number = 0;
		public static const STAGE_MARGIN:Number = 0;
		
		
		/**
		 * Logger settings
		 */
		/*public static const LOGGER_TEXT_ENABLED:Boolean = true;
		public static const LOGGER_UI_ENABLED:Boolean = true;
		public static const LOGGER_LOGINFO:Boolean = true;
		public static const LOGGER_LOGDEBUG:Boolean = true;
		public static const LOGGER_LOGWARNING:Boolean = true;
		public static const LOGGER_LOGERROR:Boolean = true;*/
		
		public static const LOGGER_TEXT_ENABLED:Boolean = false;
		public static const LOGGER_UI_ENABLED:Boolean = false;
		public static const LOGGER_LOGINFO:Boolean = false;
		public static const LOGGER_LOGDEBUG:Boolean = false;
		public static const LOGGER_LOGWARNING:Boolean = false;
		public static const LOGGER_LOGERROR:Boolean = false;
		
		/**
		 * Debug settings
		 */
		public static const STATS_ENABLED:Boolean = false;
		
		
		/**
		 * Google Analytics settings
		 */
		public static const GA_ENABLED:Boolean = false;
		public static const GA_ACCOUNT:String = 'UA-111-222';
		public static const GA_DEBUG:Boolean = false;
		
		public static const BULKLOADER_ASSETS:String = "BULKLOADER_ASSETS";
		
		/*public static const IMAGES:Array = ['../resources/Fractal_logo_0.png'];
		public static const FRACTAL_ENGLISH:String = '../resources/Fractal_logo_1.png';*/

		/**
		 * App
		 */
		
		/*public static const VIEWPORT_3D_WIDTH:int = 640;
		public static const VIEWPORT_3D_HEIGHT:int = 480;
		public static const FRAMERATE:String = '30';*/
		
		public static const VIEWPORT_3D_WIDTH:int = 1024;
		public static const VIEWPORT_3D_HEIGHT:int = 640;
		
		/*public static const VIDEO_URL1:String = '../resources/AUDIT_low_sub.flv';
		public static const VIDEO_URL2:String = '../resources/CONSEIL_low_sub.flv';
		public static const VIDEO_URL3:String = '../resources/TRANSACTION_low_sub.flv';
		public static const VIDEO_URL4:String = '../resources/PARCOURS_low_sub.flv';*/
		
		public static const VIDEO_URL1:String = '../resources/default1.flv';
		public static const VIDEO_URL2:String = '../resources/default2.flv';
		public static const VIDEO_URL3:String = '../resources/default3.flv';
		public static const VIDEO_URL4:String = '../resources/default4.flv';
		
		//rouge
		public static const BG_COLOR1VIDEO1:String = '0xC73F0B';
		public static const BG_COLOR2VIDEO1:String = '0xED571E';
		//BLEU
		public static const BG_COLOR1VIDEO2:String = '0x0187C4';
		public static const BG_COLOR2VIDEO2:String = '0x157FAF';
		//maron
		public static const BG_COLOR1VIDEO3:String = '0xBCAA00';
		public static const BG_COLOR2VIDEO3:String = '0xD4C003';
		//Orange
		public static const BG_COLOR1VIDEO4:String = '0xFFA500';
		public static const BG_COLOR2VIDEO4:String = '0xFFBE48';
		
		public static const VIDEO_WIDTH:int = 350;
		public static const VIDEO_HEIGHT:int = 197;
		
	}
}