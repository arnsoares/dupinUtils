package dupin.ui {

import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.display.MovieClip;
import flash.display.DisplayObject;
public class ButtonController extends EventDispatcher {
	
	public var _target:MovieClip;
	
	public function set target(value:MovieClip):void
	{
		_target = value;
		_target.buttonMode = true;
		_target.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
		_target.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
		_target.addEventListener(MouseEvent.CLICK, _onClick, false, 0, true);
	}
	
	public function onRollOut(e:MouseEvent):void{}
	public function onRollOver(e:MouseEvent):void{}
	public function onClick(e:MouseEvent):void{}
	
	public function _onClick(e:MouseEvent):void
	{
		onClick(e);
		
		dispatchEvent(e);
	}
	
	
	
	public function destroy():void
	{
		_target=null;
	}
	
}

}