package dupin.behaviours
{ 
  import dupin.behaviours.MouseBehaviour;
  import com.greensock.TweenMax;
  import flash.events.MouseEvent;
  import flash.display.DisplayObject;
  public class TintBehaviour extends MouseBehaviour
  {
    protected var overC:uint;
    protected var outC:uint;
    protected var overB:Boolean;
    protected var outB:Boolean;
    
    public function TintBehaviour(asset:DisplayObject, over:int=-1, out:int=-1, target:DisplayObject=null)
		{
			super(asset, target);
			
			overC = over != -1 ? over : 0;
			outC = out != -1 ? out : 0;
			overB = over != -1;
			outB = out != -1;
			
			//Reset
			TweenMax.to(this.target, 0, {colorTransform: {tint: outC, tintAmount: outB ? 1:0}});
		}
		
		override public function onOver(e:MouseEvent):void
		{
			TweenMax.to(target, .2, {colorTransform: {tint: overC, tintAmount: overB ? 1:0 }});
		}
		
		override public function onOut(e:MouseEvent):void
		{
			TweenMax.to(target, .2, {colorTransform: {tint: outC, tintAmount: outB ? 1:0}});
		}

  }
}