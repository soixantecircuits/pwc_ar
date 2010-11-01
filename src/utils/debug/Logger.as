package utils.debug {
	
	import pwc.config.Config;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import gs.TweenLite;
	import utils.Maths;
	
	/**
	 * Tracer.as
	 * @author Adrien Felsmann
	 */
	public class Logger extends Sprite {
		
		/*********************************** VARIABLES *******************************************/
		
		private static var _instance:Logger = new Logger();
		
		private static var _posX:Number;
		private static var _posY:Number;
		private static var _alpha:Number;
		private static var _width:Number;
		private static var _height:Number;
		private static var _textColor:uint;
		private static var _infoColor:uint;
		private static var _debugColor:uint;
		private static var _warningColor:uint;
		private static var _errorColor:uint;
		
		private static var _currentBarColor:uint;
		
		private var _mask:Sprite;
		private var _stack:Sprite;
		private var _currentHeight:Number = 0;
		
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		public function Logger():void {
			if (_instance) throw new Error('Logger can only be accessed through Logger.instance');
		}
		
		/*********************************** STATIC FUNCTIONS ************************************/
		
		/**
		 * Return the Logger singleton
		 */
		public static function get instance():Logger {
			return _instance;
		}
		
		/**
		 * Init the UI logger
		 * @param	posX
		 * @param	posY
		 * @param	alpha
		 * @param	row
		 * @param	barColor
		 * @param	textColor
		 */
		public static function init(
					posX:Number = 0,
					posY:Number = 0,
					alpha:Number = .7,
					width:Number = 500,
					height:Number = 500,
					textColor:uint = 0xffffff,
					infoColor:uint = 0x7ba400,
					debugColor:uint = 0x000000,
					warningColor:uint = 0xdd7a19,
					errorColor:uint = 0xd52727
				):void {
			
			_posX = posX;
			_posY = posY;
			_alpha = alpha;
			_width = width;
			_height = height;
			_textColor = textColor;
			_infoColor = infoColor;
			_debugColor = debugColor;
			_warningColor = warningColor;
			_errorColor = errorColor;
			
			instance.initUI();
			instance.initEvents();
		}
		
		/**
		 * Trace an info log
		 * @param	... arguments
		 */
		public static function info(... arguments):void {
			if (Config.LOGGER_LOGINFO) {
				_currentBarColor = _infoColor;
				instance.log('INFO', arguments);
			}
		}
		
		/**
		 * Trace a debug log
		 * @param	... arguments
		 */
		public static function debug(... arguments):void {
			if (Config.LOGGER_LOGDEBUG) {
				_currentBarColor = _debugColor;
				instance.log('DEBUG', arguments);
			}
		}
		
		/**
		 * Trace a warning log
		 * @param	... arguments
		 */
		public static function warning(... arguments):void {
			if (Config.LOGGER_LOGWARNING) {
				_currentBarColor = _warningColor;
				instance.log('WARN', arguments);
			}
		}
		
		/**
		 * Trace an error log
		 * @param	... arguments
		 */
		public static function error(... arguments):void {
			if (Config.LOGGER_LOGERROR) {
				_currentBarColor = _errorColor;
				instance.log('ERR', arguments);
			}
		}
		
		/**
		 * Parse and trace the given arguments
		 * @param	... arguments
		 */
		private function log(type:String, args:Array):void {
			var log:String = '';
			for (var i:int = 0; i < args.length; i++) {
				log += args[i] + ' ';
			}
			
			if (Config.LOGGER_TEXT_ENABLED) instance.logText(type, log);
			if (Config.LOGGER_UI_ENABLED) if (instance._stack) instance.logUI(log);
		}
		
		
		/*********************************** PRIVATE FUNCTIONS ***********************************/
		
		/**
		 * Build the UI logger UI elements
		 */
		private function initUI():void {
			this.x = _posX;
			this.y = _posY;
			this.alpha = _alpha;
			
			_mask = new Sprite();
			_mask.graphics.beginFill(0x00ff00);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
			addChild(_mask);
			
			_stack = new Sprite();
			_stack.mask = _mask;
			addChild(_stack);
		}
		
		/**
		 * Init the events for the UI logger
		 */
		private function initEvents():void {
			addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
		}
		
		/**
		 * Trace the given arguments in the console
		 * @param	log
		 */
		private function logText(type:String, log:String):void {
			trace(getTimestamp(), '[' + type + ']', log);
		}
		
		/**
		 * Trace the given arguments on the stage
		 * @param	log
		 */
		private function logUI(log:String):void {
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 9;
			format.color = _textColor;
			
			var tf:TextField = new TextField();
			tf.text = getTimestamp() + ' ' + log;
			tf.setTextFormat(format);
			tf.selectable = false;
			tf.wordWrap = true;
			tf.multiline = true;
			tf.width = _width;
			
			var barWidth:Number;
			//if (tf.textWidth < _width) barWidth = tf.textWidth + 3;
			//else barWidth = _width;
			barWidth = _width;
			
			var bar:Sprite = new Sprite();
			bar.graphics.beginFill(_currentBarColor);
			bar.graphics.drawRect(0, 0, barWidth, tf.textHeight + 10);
			bar.graphics.endFill();
			bar.y = _currentHeight;
			
			_currentHeight += bar.height;
			
			bar.addChild(tf);
			_stack.addChild(bar);
			
			if (_currentHeight > _height) {
				TweenLite.to(_stack, .3, { y: _height - _currentHeight } );
			}
		}
		
		/**
		 * Return the current timestamp
		 * @return
		 */
		private function getTimestamp():String {
			var date:Date = new Date();
			return '[' + Maths.formatTime(date.hours, 2) + ':' + Maths.formatTime(date.minutes, 2) + ':' + Maths.formatTime(date.seconds, 2) + ':' + Maths.formatTime(date.milliseconds, 3) + ']';
		}
		
		
		/*********************************** EVENT HANDLERS **************************************/
		
		/**
		 * Start dragging the UI logger stack
		 * @param	e
		 */
		private function startDragHandler(e:MouseEvent):void {
			this.startDrag();
		}
		
		/**
		 * Stop dragging the UI logger stack
		 * @param	e
		 */
		private function stopDragHandler(e:MouseEvent):void {
			this.stopDrag();
		}
	}
}