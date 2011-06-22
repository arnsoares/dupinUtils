package dupin.debug
{
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import potato.modules.log.log;

	public class RollOverDebuger extends Object
	{
		protected var stage:Stage;
		protected const SEPARATOR:String = " --> ";
	
		public function RollOverDebuger(stage:Stage)
		{
			this.stage = stage;
			stage.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			stage.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
		
		public function overHandler(e:MouseEvent):void
		{
			var tree:String="";
			var borderAlpha:Number=1;
			var current:DisplayObject = e.target as DisplayObject;
			while (current.parent != stage)
			{
				tree = current + SEPARATOR + tree;
				drawBorder(current, borderAlpha);
				current = current.parent;
				
				borderAlpha -= .3;
			}
			tree = tree.split(SEPARATOR).slice(0, -1).join(SEPARATOR);
			
			log("OVER DEBUG:", tree);
				
		}
		
		public function drawBorder(o:DisplayObject, alpha:Number):void
		{
			//Draw a nice border
			if(o.hasOwnProperty("graphics"))
			{
				var bounds:Rectangle = o.getBounds(o);
				with(o["graphics"]){
					lineStyle(2, 0x6600cc, alpha);
					drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
					endFill();
				}
			}
		}
		
		public function outHandler(e:MouseEvent):void
		{
			var current:DisplayObject = e.target as DisplayObject;
			while (current.parent != stage)
			{
				if(current.hasOwnProperty("graphics"))
					current["graphics"].clear();
				
				current = current.parent;
			}
		}
		
		public function dispose():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
			stage.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
	
	}

}