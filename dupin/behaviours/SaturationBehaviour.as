package dupin.behaviours
{ 
  import dupin.behaviours.MouseBehaviour;
  import flash.events.MouseEvent;
  import com.greensock.TweenMax;
  import flash.filters.ColorMatrixFilter;
  import flash.geom.Matrix;
  import flash.display.Sprite;
  public class SaturationBehaviour extends MouseBehaviour
  {
    private var begin:Number;
    private var end:Number;
    
    public function SaturationBehaviour(asset:Sprite, begin:Number=0, end:Number=1, target:Sprite=null)
    {
      this.begin = begin;
      this.end = end;
      
      super(asset, target);
      TweenMax.to(this.target, 0, {colorMatrixFilter: {saturation: begin}});
    }
    
    override public function onOver(e:MouseEvent):void
    {
      TweenMax.to(target, .25, {colorMatrixFilter: {saturation: end}});
    }
    
    override public function onOut(e:MouseEvent):void
    {
      TweenMax.to(target, .25, {colorMatrixFilter: {saturation: begin}});
    }

  }
}