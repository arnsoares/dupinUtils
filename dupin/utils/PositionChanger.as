package dupin.utils
{	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	public class PositionChanger extends Sprite
	{

		public function PositionChanger(what:DisplayObject)
		{
			var vx:ValueChanger = new ValueChanger(what, "x");
			addChild(vx);
			
			var vy:ValueChanger = new ValueChanger(what, "y");
			addChild(vy);
			
			var vsx:ValueChanger = new ValueChanger(what, "scaleX");
			addChild(vsx);
			
			var vsy:ValueChanger = new ValueChanger(what, "scaleY");
			addChild(vsy);
			
			vy.y += 30;
			vsx.y += 60;
			vsy.y += 90;
			
			x = y = 30;
		}

	}
}