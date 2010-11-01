package utils.debug {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	/**
	 * Stats.as
	 * @author Adrien Felsmann
	 */
	public class Stats extends MovieClip {
		
		/*********************************** VARIABLES *******************************************/
		
		private var _posX:Number;
		private var _posY:Number;
		private var _alpha:Number;
		private var _maxWidth:Number;
		private var _barColor:uint;
		private var _textColor:uint;
		private var _backgroundColor:uint;
		
		private var _fps:Number = 0;
		private var _mem:Number = 0;
		
		private var _fpsbar:Sprite;
		private var _membar:Sprite;
		
		private var _fpstf:TextField;
		private var _memtf:TextField;
		
		private var _time:Number;
		private var _secondTime:Number;
		private var _prevSecondTime:Number = getTimer();
		private var _frames:Number = 0;
		private var _maxMem:Number = 0;
		
		
		/*********************************** CONSTRUCTOR *****************************************/
		
		/**
		 * Create a new statistic graph
		 * @param	posX
		 * @param	posY
		 * @param	alpha
		 * @param	maxWidth
		 * @param	color
		 * @param	textColor
		 * @param	backgroundColor
		 */
		public function Stats(
					posX:Number = 0,
					posY:Number = 0,
					alpha:Number = .7,
					maxWidth:Number = 100,
					barColor:uint = 0x000000,
					textColor:uint = 0xffffff,
					backgroundColor:uint = 0x999999
				) {
			
			_posX = posX;
			_posY = posY;
			_alpha = alpha;
			_maxWidth = maxWidth;
			_barColor = barColor;
			_textColor = textColor
			_backgroundColor = backgroundColor;
			
			initUI();
			initEvents();
		}
		
		
		/*********************************** PRIVATE FUNCTIONS ***********************************/
		
		/**
		 * Build the graph UI elements
		 */
		private function initUI():void {
			this.alpha = _alpha;
			
			var background:Sprite = new Sprite();
			background.graphics.beginFill(_backgroundColor);
			background.graphics.drawRect(0, 0, _maxWidth, 32);
			background.x = _posX;
			background.y = _posY;
			addChild(background);
			
			
			
			_fpsbar = new Sprite();
			_fpsbar.graphics.beginFill(_barColor);
			_fpsbar.graphics.drawRect(0, 0, 100, 16);
			_fpsbar.x = _posX;
			_fpsbar.y = _posY;
			addChild(_fpsbar);
			
			_membar = new Sprite();
			_membar.graphics.beginFill(_barColor);
			_membar.graphics.drawRect(0, 0, 100, 16);
			_membar.x = _posX;
			_membar.y = _posY + _fpsbar.height;
			addChild(_membar);
			
			
			
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 9;
			format.color = _textColor;
			
			
			
			_fpstf = new TextField();
			_fpstf.text = '*';
			_fpstf.selectable = false;
			_fpstf.x = _posX + 2;
			_fpstf.y = _posY - 1;
			_fpstf.defaultTextFormat = format;
			addChild(_fpstf);
			
			_memtf = new TextField();
			_memtf.text = '*';
			_memtf.selectable = false;
			_memtf.x = _posX + 2;
			_memtf.y = _posY - 1 + _fpsbar.height;
			_memtf.defaultTextFormat = format;
			addChild(_memtf);
		}
		
		/**
		 * Init the graph events
		 */
		private function initEvents():void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
		}
		
		
		/*********************************** EVENT HANDLERS **************************************/
		
		/**
		 * Refresh the graph data
		 * @param	e
		 */
		private function enterFrameHandler(e:Event):void {
			_time = getTimer();
			_secondTime = _time - _prevSecondTime;
			
			if (_secondTime >= 1000) {
				_fps = _frames;
				_frames = 0;
				_prevSecondTime = _time;
			}
			else {
				_frames++;
			}
			
			_mem = Number( ( System.totalMemory / (1024 * 1024) ).toFixed(2) );
			if (_maxMem < _mem) { _maxMem = _mem; }
			
			
			_fpstf.autoSize = TextFieldAutoSize.LEFT;
			_memtf.autoSize = TextFieldAutoSize.LEFT;
			
			_fpstf.text = _fps + ' | ' + stage.frameRate + ' fps';
			_memtf.text = _mem + ' | ' + _maxMem + ' mb';
			
			_fpsbar.width = int(_fps) * _maxWidth / stage.frameRate;
			_membar.width = _mem * _maxWidth / _maxMem;
		}
		
		/**
		 * Start dragging the graph
		 * @param	e
		 */
		private function startDragHandler(e:MouseEvent):void {
			this.startDrag();
		}
		
		/**
		 * Stop dragging the graph
		 * @param	e
		 */
		private function stopDragHandler(e:MouseEvent):void {
			this.stopDrag();
		}
	}
}