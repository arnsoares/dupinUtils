package dupin.video
{	
import dupin.display.safeRemoveChild;
import com.greensock.TweenMax;
import flash.events.Event;
import flash.display.Sprite;
import dupin.display.drawRect;
import flash.utils.setTimeout;
import potato.core.IDisposable;
import potato.modules.log.log;
	public class VideoLooper extends Sprite implements IDisposable
	{
		protected var initial:VideoPlayer;
		protected var loops:Vector.<VideoPlayer> = new Vector.<VideoPlayer>;
		protected var out:VideoPlayer;
		
		protected var current:VideoPlayer;
		
		public static const OUT_START:String = "outStart";

		public function VideoLooper(initial:VideoPlayer, loops:Array, out:VideoPlayer=null)
		{
		  for (var i:int = 0; i < loops.length; i++)
			{
				var p:VideoPlayer = loops[i];
				p.stop(); //Netstream bug (caching first frame and waiting)
				this.loops.push(p);
			}
			if(out){
				this.out = out;
				this.out.stop(); //Netstream bug
				this.out.addEventListener(Event.COMPLETE, onOutComplete, false, 0, true);
			}
			
			if(initial){
		    this.initial = initial;
  			this.initial.addEventListener(Event.COMPLETE, onInitialComplete, false, 0, true);
  			setCurrentVideo(initial);
		  } else
		  {
		    onInitialComplete();
		  }
		}
		
		protected function setCurrentVideo(p:VideoPlayer):void
		{
			if(current){
				safeRemoveChild(current);
				current.stop();
			}
			
			current = p;
			addChild(current);
			current.play();
			
			//drawRect(this, 0, 0, width, height);
		}
		
		public function play():void
		{
			current.play();
		}
		
		public function pause():void
		{
			//stackTrace();
			current.pause();
		}
		
		public function hide():void
		{
			if(current == out) return; //Already hiding
			
			if(loops.length == 0)
			{
				dispatchEvent(new Event(OUT_START));
				setCurrentVideo(out);
			}
			else if(current == initial || !out)
			{
				log("VideoLooper::hide()", "INITIAL...");
				current.pause();
				TweenMax.to(initial, .3, {alpha: 0, onComplete: onOutComplete});
			} 
			else
			{
				log("VideoLooper::hide()", "LOOP... wait");
				//Wait for loop and play out
				current.removeEventListener(Event.COMPLETE, onLoopComplete);
				current.addEventListener(Event.COMPLETE, function(...args):void{
					log("VideoLooper::hide()", "SETTING OUT VIDEO");
					dispatchEvent(new Event(OUT_START));
					setCurrentVideo(out);
				}, false, 0, true);
			}
		}
		
		private function onInitialComplete(...ignore):void
		{
			if(loops.length > 0)
			{
				loops[0].addEventListener(Event.COMPLETE, onLoopComplete, false, 0, true);
				setCurrentVideo(loops[0]);
			}
		}
		
		private function onLoopComplete(...ignore):void
		{
			//Remove current
			current.removeEventListener(Event.COMPLETE, onLoopComplete);
			
			//Next index
			var next:int = loops.indexOf(current) + 1;
			if(next == loops.length) next = 0;
			//set
			loops[next].addEventListener(Event.COMPLETE, onLoopComplete, false, 0, true);
			setCurrentVideo(loops[next]);
		}
		
		override public function get width():Number
		{
			return current.width;
		}
		override public function get height():Number
		{
			return current.height;
		}
		
		private function onOutComplete(...ignore):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
		public function dispose():void
		{
			if(initial){
				initial.dispose();
				safeRemoveChild(initial);
				initial = null;
			}
			
			for each (var p:VideoPlayer in loops)
			{
				if(p){
					p.dispose();
					safeRemoveChild(p);
					p = null;
				}
			}
			
			if(out){
				out.dispose();
				safeRemoveChild(out);
				out = null;
			}
		}

	}
}