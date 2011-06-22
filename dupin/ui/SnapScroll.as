package dupin.ui
{
	import flash.display.*;
	import flash.net.*;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Bounce;
	import flash.events.Event;
	
	public class SnapScroll extends Scroll
	{
		public var steps:int = 10;
		public static var SNAP:String = "snap";
		
		public function SnapScroll(knob:Sprite, scrollBounds:DisplayObject, vertical:Boolean=true)
		{
			super(knob, scrollBounds, vertical);
			value = 0;
		}
		
		public function get stepValue():Number
		{
			return Math.round(_value*(steps-1)) / (steps-1);
		}
		
		public function get step():Number
		{
			return Math.round(_value*(steps-1));
		}
		
		override public function _onKnobMouseUp(e:MouseEvent):void
		{
			super._onKnobMouseUp(e);
			
			if(stepValue != value)
				TweenMax.to(this, .3, {value: stepValue, ease: Bounce.easeOut, onUpdate: function():void{
					dispatchEvent(new Event(Event.CHANGE));
				}, onComplete: function():void{
					dispatchEvent(new Event(SNAP));
				}});
		}
		
		override public function _onBoundsClick(e:Event):void{
			
			var finalVal:Number = Math.round((scrollBounds[mouseDirection] / scrollBounds[sizeDirection])*(steps-1)) / (steps-1);
			
			if(finalVal != value)
				TweenMax.to(this, .4, {value: finalVal, ease: Bounce.easeOut, onUpdate: function():void{
					dispatchEvent(new Event(Event.CHANGE));
				}, onComplete: function():void{
					dispatchEvent(new Event(SNAP));
				}});
			
		}
	
	}

}
