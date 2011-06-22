package dupin.ui{

	import flash.display.*;
	import flash.events.*;
	import dupin.math.map;

	public class TextScroller extends EventDispatcher{

		public var _content:DisplayObject;
		public var bounds:DisplayObject;
		public var hideWhenNotNeeded:Boolean;

		public var scroll:Scroll;

		public function TextScroller(content:DisplayObject, bounds:DisplayObject, knob:Sprite, scrollBounds:DisplayObject, hideWhenNotNeeded:Boolean = true){
			this.bounds = bounds;
			this.bounds = bounds;
			this.hideWhenNotNeeded = hideWhenNotNeeded;
			
			this.scroll = new Scroll(knob, scrollBounds);
			
			this.content = content;
			content.mask = bounds;
			
			this.scroll.value = 0;
			this.scroll.addEventListener(Event.CHANGE, _onScrollChange, false, 0, true);

			
		}

		public function _onScrollChange(e:Event):void{
			
			if(content.height < bounds.height) return; //There is nothing to scroll

			//Scroll percent
			var destY:Number = map(scroll.value, 0, 1, 0, content.height - bounds.height);
			content.y = bounds.y - destY;
		}

		public function get content():DisplayObject{
			return _content;
		}
		public function set content(value:DisplayObject):void{
			_content = value;
			if(hideWhenNotNeeded && content.height < bounds.height)
			{
				scroll.scrollBounds.visible = scroll.knob.visible = false;
			} else {
				scroll.scrollBounds.visible = scroll.knob.visible = true;
			}
		}

		public function dispose():void{
			scroll.dispose();
		}

	}
	
}
