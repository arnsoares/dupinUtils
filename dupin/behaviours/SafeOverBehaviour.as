package dupin.behaviours
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class SafeOverBehaviour extends OverBehaviour
	{
		protected var overRunning:Boolean = false;
		protected var overCallback:Function;
		protected var outCallback:Function;
		
		public function SafeOverBehaviour(asset:MovieClip, overCallback:Function=null, outCallback:Function=null, target:MovieClip=null)
		{
			this.overCallback = overCallback;
			this.outCallback = outCallback;
			super(asset, target);
		}
		
		override public function onOver(e:MouseEvent):void
		{
			var t:MovieClip = target as MovieClip;
			
			if (!overRunning){
				if(overCallback != null) overCallback(e);
				t.gotoAndPlay("over");
				overRunning = true;
			}
			
		}
		
		override public function onOut(e:MouseEvent):void
		{
			if (overRunning)
			{
				if(outCallback != null) outCallback(e);
				(target as MovieClip).gotoAndPlay("out");
				overRunning = false;
			}
			
			
		}
		
	}

}