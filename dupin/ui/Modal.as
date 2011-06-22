package dupin.ui {
	import flash.filters.*;
	import flash.display.*;
	import flash.events.*;
	import dupin.display.*;
	import potato.core.IDisposable;
	import com.greensock.*;
	
	public class Modal implements IDisposable{

		protected var blocker:Sprite
		protected var window:DisplayObject;
		protected var blur:Number;
		protected var color:uint;
		protected var alpha:Number;

		public function Modal(window:DisplayObject, blur:Number=5, color:uint=0, alpha:Number=0){
			this.window = window;
			this.color = color;
			this.blur = blur;
			this.alpha = alpha;

			blocker = new Sprite();

			//Add blocker behind our window
			if(!window.parent)
				window.addEventListener(Event.ADDED, added, false, 0, true);
			else
				added();

			if(!window.stage)
				window.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			else
				addedToStage();

		}

		protected function added(e:Event=null):void{
			//Add the blocker just behind the window
			window.parent.addChildAt(blocker, window.parent.getChildIndex(window));
		}
		protected function addedToStage(e:Event=null):void{
			//Prepare for resizes
			window.stage.addEventListener(Event.RESIZE, resize);
			generateBlocker();

			/////////
			show();
		}
		protected function resize(e:Event):void{
			if(!window) {
				e.target.removeEventListener(Event.RESIZE, resize);
				return;
			}
			generateBlocker();
		}
		protected	function generateBlocker():void{
			//Cleanup
			blocker.graphics.clear();
			removeAllChildren(blocker);

			//Recreate
			if(alpha > 0)
				with(blocker.graphics){
					beginFill(color, alpha);
					drawRect(0, 0, window.stage.stageWidth, window.stage.stageHeight);
				}

			if(blur > 0){
				window.visible = false;

				var bmp:Bitmap = new Bitmap(bitmapData(window.stage));
				bmp.filters = [new BlurFilter(blur, blur)];
				blocker.addChild(bmp);

				window.visible = true;
			}
				
		}

		public function show():void{
			TweenMax.from(blocker, .5, {alpha: 0})
		}
		public function hide(callback:Function):void{
			TweenMax.to(blocker, .5, {alpha: 0, onComplete: callback})
		}

		public function dispose():void{
			if(window)
			hide(function():void{
			
				safeRemoveChild(window);
				window=null;

				safeRemoveChild(blocker);
				blocker = null;
			});

		}
	}
}

