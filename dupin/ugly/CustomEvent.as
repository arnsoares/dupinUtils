package dupin.ugly
{	
	import flash.events.Event;
	dynamic public class CustomEvent extends Event
	{
		public var _obj:Object;
		
		public function CustomEvent(type:String, custom:Object)
		{
			_obj = custom;
			super(type);
		}
		
		public function get custom():Object
		{
			return _obj;
		}
		public function set custom(value:Object):void
		{
			_obj = value;
		}

	}
}