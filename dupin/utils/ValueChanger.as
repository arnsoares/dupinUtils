package dupin.utils {

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldType;
import dupin.display.drawRect;
import flash.events.Event;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
public class ValueChanger extends Sprite {
	
	public var obj:Object;
	public var property:String;
	public var input:TextField;
	public var label:TextField;
	
	public function ValueChanger(obj:Object,property:String)
	{
		this.obj = obj;
		this.property = property;
		
		label = new TextField();
		label.text = obj + ":" + property;
		label.autoSize = TextFieldAutoSize.LEFT;
		label.y = 3;
		label.setTextFormat(new TextFormat("Arial", 12, 0x0));
		addChild(label);
		
		input = new TextField();
		input.type = TextFieldType.INPUT;
		input.defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
		input.width = 100;
		input.height = 20;
		input.x = label.width + 5;
		addChild(input);
		drawRect(this, input.x, input.y, input.width, input.height, 0x444444);
		input.addEventListener(Event.CHANGE, onValueChanged);
	}
	public function onValueChanged(e:Event):void
	{
		try{
			obj[property] = input.text;
		} catch (e:Error)
		{
			trace("Error: invalid value for ", property, ": ", input.text);
		}
		
	}
	
}

}
