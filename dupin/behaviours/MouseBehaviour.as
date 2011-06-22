package dupin.behaviours
{ 
  import potato.core.IDisposable;
  import flash.display.MovieClip;
  import flash.events.MouseEvent;
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.events.EventDispatcher;
  public class MouseBehaviour extends EventDispatcher implements IDisposable
  {

    public var asset:DisplayObject;
		public var target:DisplayObject;
		protected var _enabled:Boolean = true;
		public function MouseBehaviour(asset:DisplayObject, target:DisplayObject=null)
		{
			asset.addEventListener(MouseEvent.ROLL_OVER, _onOver);
			asset.addEventListener(MouseEvent.ROLL_OUT, _onOut);
			asset.addEventListener(MouseEvent.CLICK, _onClick);
			if (asset is Sprite)
			{
			  asset["mouseChildren"] = false;
  			asset["buttonMode"] = true;
			}
			
			
			
			this.asset = asset;
			this.target = target;
			this.target ||= asset;
		}
		
		public function set enabled(value:Boolean):void
		{
		  if(asset is Sprite)
			  asset["buttonMode"] = value;
			_enabled = value;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		protected function _onOver(e:MouseEvent):void{  if(_enabled) onOver(e); }
		protected function _onOut(e:MouseEvent):void{	if(_enabled) onOut(e);	}
		protected function _onClick(e:MouseEvent):void{ if(_enabled) onClick(e); }
		
		public function onOver(e:MouseEvent):void
		{
		  
		}
		public function onOut(e:MouseEvent):void
		{
		  
		}
		public function onClick(e:MouseEvent):void
		{
		  
		}
		
		public function dispose():void
		{
			asset.removeEventListener(MouseEvent.ROLL_OVER, _onOver);
			asset.removeEventListener(MouseEvent.ROLL_OUT, _onOut);
			asset.addEventListener(MouseEvent.CLICK, _onClick);
			this.asset = null;
			this.target = null;
		}

  }
}