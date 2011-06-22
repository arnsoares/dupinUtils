package dupin.ui
{	
import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.text.TextField;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
	public class StretchTextButton extends EventDispatcher
	{
		public var _base:DisplayObject;
		public var _text:TextField;
		public var margin:Number;
		public var posX:Number;
		
		public function StretchTextButton(base:Sprite, text:TextField, margin:Number=5)
		{
			base.mouseChildren = false;
			base.buttonMode = true;
			
			_base = base;
			_text = text;
			_text.selectable = false;
			this.margin = margin;
			
			base.addChild(text);
			base.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
			update();
		}
		
		public function onClick(e:MouseEvent):void
		{
			dispatchEvent(e.clone());
		}
		
		public function set text(value:String):void
		{
			_text.text = value;
			update();
		}
		
		public function set htmlText(value:String):void
		{
			_text.htmlText = value;
			update();
		}
		
		public function update():void
		{
			_text.x = margin;
			_text.y = _base.height/2 - _text.height/2;
			_base.width = _text.width + margin*2;
		}

	}
}