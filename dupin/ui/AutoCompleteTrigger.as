package dupin.ui{
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.events.EventDispatcher;
	import potato.core.IDisposable;
	public class AutoCompleteTrigger extends EventDispatcher implements IDisposable {
		
		public var field:TextField;
		private var updateInterval:int;
		private var oldText:String="";

		public function AutoCompleteTrigger(field:TextField)
		{
			this.field = field;
			field.addEventListener(FocusEvent.FOCUS_IN, onFocus);
			field.addEventListener(FocusEvent.FOCUS_OUT, onBlur);
		}

		protected function onFocus(e:FocusEvent):void
		{
			if(field.text != ""){
				dispatch();
			}

			setInterval(dispatch, 1000);
		}
		protected function onBlur(e:FocusEvent):void
		{
			clearInterval(updateInterval);
			dispatch();
		}

		protected function dispatch():void
		{
			if(oldText == field.text) return;

			oldText = field.text
			dispatchEvent(new Event(Event.CHANGE)); // CHANGE
		}

		public function dispose():void
		{
			field.removeEventListener(FocusEvent.FOCUS_IN, onFocus);
			field.removeEventListener(FocusEvent.FOCUS_OUT, onBlur);
		}


	}
}