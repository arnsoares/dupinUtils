package dupin.ui
{	
import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.events.Event;
import dupin.display.removeAllChildren;
public class Dock extends Sprite
{
	public var itemsMargin:Number;
	public var items:Array = [];
	public var minSize:Number;
	public var maxSize:Number;
	public var hitWidth:Number = 100;
	
	public function Dock(itemsMargin:Number, minSize:Number, maxSize:Number)
	{
		this.itemsMargin = itemsMargin;
		this.minSize = minSize;
		this.maxSize = maxSize;
		
		this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
	}
	
	public function addItem(item:DisplayObject):void
	{
		items[items.length] = item;
		addChild(item);
	}
	
	public function update(e:Event):void
	{
							
				// for all items inside hitTest
				var thisX:Number = 0;
				var radMaxSize:Number = Math.PI / maxSize;
				
				for(var i:Number = 0; i < items.length; i++){
					//log("Dock::update()", item);
					var item:DisplayObject = items[i];
					item.x = thisX;
					
					//How much to increase it in it's size?
					var toAdd:Number = 0;
					
					//Inside mouse's hit area?
					if(	mouseY > -height/2 && mouseY < height/2 &&
						item.x < mouseX + hitWidth/2 &&
						item.x + item.width > mouseX - hitWidth/2){
							
						//Calculate how much do we have to increase it in it's size
						var itemMiddle:Number = item.width/2;
						var mouseDist:Number = (hitWidth - Math.abs((mouseX - item.x) - itemMiddle)) / hitWidth;
						toAdd = (maxSize - minSize) * mouseDist;
					}
					
					item.height -= (item.height - (minSize+toAdd)) * 0.1;
					
					//Keep aspect ratio
					item.scaleX = item.scaleY;
					
					//Next item position
					thisX+=item.width + itemsMargin;

				}
				dispatchEvent(new Event(Event.RESIZE));
	}
	
	public function dispose():void
	{
		removeEventListener(Event.ENTER_FRAME, update)
		items.length = 0;
		
		removeAllChildren(this);
	}

}
}