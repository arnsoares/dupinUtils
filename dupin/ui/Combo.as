package dupin.ui{

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import patota.num.rangeMap;

	public class Combo extends Sprite{

		public var knob:DisplayObject;
		public var scrollBounds:DisplayObject;
		
		//Vertical or horizontal?
		public var mouseDirection:String; //mouseX, mouseY
		public var scrollDirection:String; //x, y
		public var sizeDirection:String; //height, width

		public var knobPressedOffset:Number = -1;

		public var selected:TextField;
		public var button:Sprite;
		public var _items:Array=[];

		public var scroll:TextScroller;
		public var content:DisplayObjectContainer;
		public var contentHolder:DisplayObjectContainer;

		public function Combo(selected:TextField, button:Sprite, content:DisplayObjectContainer, contentHolder:MovieClip){
	
			this.selected = selected;
			this.selected.mouseEnabled = false;
			this.button = button;
			this.button.buttonMode = true;
			this.button.addEventListener(MouseEvent.CLICK, _onButtonClick, false, 0, true);
			this.contentHolder = contentHolder;
			this.content = content;

			this.scroll = new TextScroller(content, contentHolder.scrollBounds, contentHolder.knob, contentHolder.scrollBarBounds);
			this.contentHolder.visible = false;
		}

		public function add(item:MovieClip):void{
			item.mouseChildren = false;
			item.y = scroll.content.height;
			content.addChild(item);
			_items.push(item);
			item.addEventListener(MouseEvent.CLICK, _onItemClick, false, 0, true);
			
			scroll.content = content;
		}

		public function _onItemClick(e:MouseEvent):void{
			contentHolder.visible = false;
			selected.text = e.currentTarget.field.text;
		}

		public function _onButtonClick(e:MouseEvent):void{
			contentHolder.visible = !contentHolder.visible;
		}

		public function get value():String{
			return selected.text;
		}

		public function dispose():void{
			_items = null;
			scroll.dispose();
		}

	}
	
}
