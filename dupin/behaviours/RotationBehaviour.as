package dupin.behaviours
{	
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	public class RotationBehaviour extends MouseBehaviour
	{
		protected var initialRotation:Number;
		protected var endingRotation:Number;
		
		protected var _speed:Number = .1;
		protected var _ease:Function;
		
		public function RotationBehaviour(asset:Sprite, rotation:Number=90, rotationTarget:Sprite=null)
		{
			super(asset, rotationTarget);
			
			_ease = Circ.easeOut;
			this.initialRotation = this.target.rotation;
			this.endingRotation  = rotation;
		}
		
		public function setTransition(speed:Number, ease:Function=null):void
		{
			_speed = speed;
			_ease = ease;
		}
		
		override public function onOver(e:MouseEvent):void
		{
				TweenMax.to(target, _speed, {rotation: endingRotation, ease: _ease});
		}
		
		override public function onOut(e:MouseEvent):void
		{
				TweenMax.to(target, _speed, {rotation: initialRotation, ease: _ease});
		}

	}
}