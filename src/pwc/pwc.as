package pwc
{
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.display.StageDisplayState;
	import flash.display.StageAlign;
	import flash.ui.Mouse;
	
	import pwc.config.*;

	
	[SWF(width='1920', height='1080', backgroundColor='#00000', frameRate='30')]
	//[SWF(width='640', height='480', frameRate='30')]
	
	public class pwc extends Sprite
	{
			
		public function pwc():void
		{
			addChild(new PWC_Away3D());

			// init generic stuff (including debug)
			Presets.init(this);
			
			stage.quality = StageQuality.HIGH;
			stage.align     = StageAlign.TOP_LEFT;
			Mouse.hide();
		}
		
	}
}