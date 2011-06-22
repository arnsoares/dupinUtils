package dupin.behaviours
{	
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import flash.display.DisplayObject;
	
	public class ScaleBehaviour extends MouseBehaviour
	{
		public var initialScale:Number;
		public var endingScale:Number;
		
		public var _speed:Number = .1;
		public var _ease:Function;
		
		public function ScaleBehaviour(asset:DisplayObject, scale:Number=1.2, scaleTarget:Sprite=null)
		{
			super(asset, scaleTarget);
			
			_ease = Circ.easeOut;
			initialScale = this.target.scaleX;
			endingScale  = this.target.scaleX*scale;
		}
		
		public function setTransition(speed:Number, ease:Function=null):ScaleBehaviour
		{
			_speed = speed;
			_ease = ease;

			return this;
		}
		
		override public function onOver(e:MouseEvent):void
		{
			TweenMax.to(target, _speed, {scaleX: endingScale, scaleY: endingScale, ease: _ease});
		}
		
		override public function onOut(e:MouseEvent):void
		{
			TweenMax.to(target, _speed, {scaleX: initialScale, scaleY: initialScale, ease: _ease});
		}

	}
}