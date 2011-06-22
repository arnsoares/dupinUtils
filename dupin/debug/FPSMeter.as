package dupin.debug
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
  
  /**
   * Based on the FPSMeter class by Mauro de Tarso, Fernando França.
   * 
   * @langversion ActionScript 3
   * @playerversion Flash 10.0.0
   * 
   * @author Mauro de Tarso, Fernando França
   * @since  14.02.2011
   */
	public class FPSMeter extends Sprite
	{
	  protected static var _instance:FPSMeter;
		protected var _caption:TextField;
		protected var _frames:int;
		protected var _lastFrameTime:int;
		
		
		/**
		 * Starts FPS / memory measurement
		 */
		public static function start(container:DisplayObjectContainer):FPSMeter
		{
			if(!_instance)
				_instance = new FPSMeter(new SingletonEnforcer());
			
			container.addChild(_instance); 
			
			return _instance;
		}
    
		public function FPSMeter(singleton:SingletonEnforcer) 
		{
			x = y = 3;
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0x33005B, .7);
			shape.graphics.drawRoundRect(0, 0, 150, 20, 8);
			shape.graphics.endFill();
			addChild(shape);
			
			_frames = 0;
			_lastFrameTime = getTimer();
			_caption = new TextField();
			_caption.defaultTextFormat = new TextFormat("Arial Black", 11, 0xffffff);
			_caption.autoSize = TextFieldAutoSize.LEFT;
			_caption.selectable = false;
			_caption.x = 3;
			addChild(_caption);

      addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_frames++;
			var time:int = getTimer();
			if (time - _lastFrameTime >= 1000)
			{
				var mem:Number = System.totalMemory/(1024*1024);
				var memTxt:String = "MEM: "+Math.round(mem)+"M";
				var fpsTxt:String = "FPS: "+String(_frames);
				_caption.htmlText = fpsTxt+" - "+memTxt;
				_frames = 0;
				_lastFrameTime = time;
      }
		}
	} 
}

/**
 * Enforces the Singleton design pattern.
 */
internal class SingletonEnforcer{}

