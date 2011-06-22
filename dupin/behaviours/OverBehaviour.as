package dupin.behaviours
{	
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	public class OverBehaviour extends MouseBehaviour
	{
	  public function OverBehaviour(asset:MovieClip, target:MovieClip=null)
		{
			super(asset, target);
		}
		
		override public function onOver(e:MouseEvent):void
		{
			(target as MovieClip).gotoAndPlay("over");
		}
		
		override public function onOut(e:MouseEvent):void
		{
			(target as MovieClip).gotoAndPlay("out");
		}
		
		public function set selected(value:Boolean):void
		{
			value ? (target as MovieClip).gotoAndPlay("over") : (target as MovieClip).gotoAndStop(1);
			enabled = !value;
		}
	}
}