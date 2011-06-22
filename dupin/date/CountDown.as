package dupin.date
{	
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	public class CountDown extends EventDispatcher
	{
		protected var _timer:Timer;
		protected var _startDate:Date;
		protected var _endDate:Date;
		protected var _countDownDate:Date;
		
		protected var _hours:int;
		protected var _minutes:int;
		protected var _seconds:int;
		
		public function CountDown(endDate:Date, currentDate:Date=null)
		{
			currentDate ||= new Date();
			
			_endDate   = endDate;
			_startDate = currentDate || new Date();
			//Used to calculate the timespan
			_countDownDate = new Date();
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTick, false, 0, true);
			_timer.start();
		}
		
		public function get hours():int
		{
			return _hours;
		}
		
		public function get endDate():Date
		{
			return _endDate;
		}
		public function set endDate(value:Date):void
		{
			_endDate = value;
			if(!_timer.running)
				_timer.start();
		}
		
		public function get minutes():int
		{
			return _minutes;
		}
		
		public function get seconds():int
		{
			return _seconds;
		}
		
		public function get currentDate():Date
		{
			//Calculate timespan from the time the counter was created
			var timespan:int = (new Date()).time - _countDownDate.time;
			//Add it to the currentDate, so will have the actual time
			var currentTime:Number = _startDate.time + timespan;// + _startDate.getTimezoneOffset()*1000*60;
			return new Date(currentTime);
		}
		
		public function get remainingMilis():int
		{
		  //Calculate timespan from the time the counter was created
			var timespan:int = (new Date()).time - _countDownDate.time;
			//Add it to the currentDate, so will have the actual time
			var currentTime:Number = timespan + _startDate.time;// + _startDate.getTimezoneOffset()*1000*60;
			
		  return _endDate.time - currentTime;
		}
		
		public function onTick(e:TimerEvent):void
		{
			//Timespan relative the endDate of the countdown (time remaining in milis)
			var remaining:Number = remainingMilis;
			
			if(remaining <= 0){
				_timer.stop();
				
				_seconds = _minutes = _hours = 0;
				dispatchEvent(new Event(Event.CHANGE));
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			//Update with the current values
			_seconds = (remaining / 1000) % 60;
			_minutes = (remaining / (1000*60)) % 60;
			_hours = (remaining / (1000*60*60)) % 24;
			
			//Tell it changed
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function dispose():void
		{
			try
			{
				_timer.stop();
			} 
			catch (e:Error){} //No need to worry
		}

	}
}