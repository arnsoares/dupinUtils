package dupin.ui{

	import flash.display.*;
	import flash.events.*;
	import potato.modules.log.log;

	public class Scroll extends Sprite{

		public var knob:DisplayObject;
		public var scrollBounds:DisplayObject;
		
		//Vertical or horizontal?
		public var mouseDirection:String; //mouseX, mouseY
		public var scrollDirection:String; //x, y
		public var sizeDirection:String; //height, width

		public var knobPressedOffset:Number = Number.MIN_VALUE;

		public var _value:Number;

		public function Scroll(knob:Sprite, scrollBounds:DisplayObject, vertical:Boolean=true){

			//What to scroll
			this.knob = knob;
			this.scrollBounds = scrollBounds;
			
			//In wich direction?
			this.mouseDirection = vertical ? "mouseY" : "mouseX";
			this.scrollDirection = vertical ? "y" : "x";
			this.sizeDirection = vertical ? "height" : "width";

			addEventListener(Event.ADDED_TO_STAGE, _onAddedtoStage, false, 0, true);
			scrollBounds.addEventListener(MouseEvent.CLICK, _onBoundsClick, false, 0, true);

			//Setup knob interaction
			knob.buttonMode = true;
			knob.addEventListener(MouseEvent.MOUSE_DOWN, _onKnobMouseDown, false, 0, true);
			if(knob.stage){
				_enableEvents();
			} else {
				knob.addEventListener(Event.ADDED_TO_STAGE, _enableEvents, false, 0, true);
			}

			//Hiding some stuff
			scrollBounds.alpha = 0;
		}
		
		public function get pressed():Boolean
		{
		  return knobPressedOffset != Number.MIN_VALUE;
		}
		
		public function _enableEvents(e:Event=null):void{
			if(e) e.target.removeEventListener(Event.ADDED_TO_STAGE, _enableEvents);
			
			knob.stage.addEventListener(MouseEvent.MOUSE_MOVE, _update, false, 0, true);
			knob.stage.addEventListener(MouseEvent.MOUSE_UP, _onKnobMouseUp, false, 0, true);
		}

		public function get value():Number{
			//Scroll percent
			return  _value;
		}
		public function set value(value:Number):void{
			if(knobPressedOffset != Number.MIN_VALUE) return; //Avoid bounce while dragging

			if(value < 0) value = 0;
			if(value > 1) value = 1;
			knob[scrollDirection] = scrollBounds[scrollDirection] + (scrollBounds[sizeDirection]*value);

			_value = value;
		}

		public function _onBoundsClick(e:Event):void{
			knob[scrollDirection] = scrollBounds[mouseDirection] + scrollBounds[scrollDirection];
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function _onAddedtoStage(e:Event):void{
			log("Do not add this class to the stage");
			parent.removeChild(this);
		}

		public function _onKnobMouseUp(e:MouseEvent):void{
			knobPressedOffset = Number.MIN_VALUE;
		}
		public function _onKnobMouseDown(e:MouseEvent):void{
			knobPressedOffset = knob[mouseDirection];
		}

		public function _update(e:MouseEvent):void{
			
			//We are holding the knob, move it now =)
			if(knobPressedOffset != Number.MIN_VALUE){
				knob[scrollDirection] = -knobPressedOffset + scrollBounds[mouseDirection] + scrollBounds[scrollDirection];

				//Keep inside the bounds
				if(knob[scrollDirection] < scrollBounds[scrollDirection])
					knob[scrollDirection] = scrollBounds[scrollDirection];
				else if (knob[scrollDirection] > scrollBounds[scrollDirection] + scrollBounds[sizeDirection])
					knob[scrollDirection] = scrollBounds[scrollDirection] + scrollBounds[sizeDirection];

				_value = (knob[scrollDirection] - scrollBounds[scrollDirection]) / (scrollBounds[sizeDirection]);

				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function dispose():void{
		  if (knob && knob.stage)
		  {
		    knob.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _update);
  			knob.stage.removeEventListener(MouseEvent.MOUSE_UP, _onKnobMouseUp);
		  }
		}

	}
	
}