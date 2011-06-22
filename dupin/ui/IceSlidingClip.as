package dupin.ui
{
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.events.*;

	public class IceSlidingClip extends EventDispatcher
	{
		public var target:DisplayObject;
		public var into:Stage;
		public var accel:Number=0;
		
		public var SPEED:Number=1;
		public var FRICCTION:Number=1.12;
		public var ignoreRatio:Number = .4;
	
		public function IceSlidingClip(target:DisplayObject, into:Stage)
		{
			this.target = target;
			this.into = into;
			
			target.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function update(e:Event):void
		{
			doHorizontal();
			//doVertical();
		}

		public function doVertical():void
		{
			//Check screen ratio: -1..1
			var screenRatio:Number = (into.mouseY-into.stageHeight/2)/(into.stageHeight/2);
			
			//Avoid strange behaviour when focus is lost
			if(target.mouseX < 0 || target.mouseX > target.width || target.mouseY < 0 || target.mouseY > target.height)
				screenRatio = 0;
			
			//Calculate acceleration
			if(screenRatio > ignoreRatio)
				accel += (screenRatio-ignoreRatio)*SPEED;
			if(screenRatio < -ignoreRatio)
				accel += (screenRatio+ignoreRatio)*SPEED;
			
			//Fricction
			accel/=FRICCTION;
			
			//Move
			target.y -= accel;
			
			//Keep bounds
			if(target.y > 0) 
				target.y = 0;
			if(target.y < -target.height + into.stageHeight) 
				target.y = -target.height + into.stageHeight;
			
			//Checking if it moved
			if(accel != 0)
				dispatchEvent(new Event(Event.CHANGE));
		}
		

		
		public function doHorizontal():void
		{
			//Check screen ratio: -1..1
			var screenRatio:Number = (into.mouseX-into.stageWidth/2)/(into.stageWidth/2);
			
			//Avoid strange behaviour when focus is lost
			if(target.mouseX < 0 || target.mouseX > target.width || target.mouseY < 0 || target.mouseY > target.height)
				screenRatio = 0;
			
			//Calculate acceleration
			if(screenRatio > ignoreRatio)
				accel += (screenRatio-ignoreRatio)*SPEED;
			if(screenRatio < -ignoreRatio)
				accel += (screenRatio+ignoreRatio)*SPEED;
			
			//Fricction
			accel/=FRICCTION;
			
			//Move
			target.x -= accel;
			
			//Keep bounds
			if(target.x > 0) 
				target.x = 0;
			if(target.x < -target.width + into.stageWidth) 
				target.x = -target.width + into.stageWidth;
			
			//Checking if it moved
			if(accel != 0)
				dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function dispose():void
		{
			target.removeEventListener(Event.ENTER_FRAME, update);
			target = null;
			into = null;
		}
	
	}

}