package dupin.ui
{ 
  import flash.events.EventDispatcher;
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import com.greensock.easing.Quart;
  import com.greensock.TweenLite;
  import flash.display.Sprite;
  import flash.events.Event;
  import potato.modules.tracking.track;
  public class Visor extends EventDispatcher
  {
    public var container:DisplayObjectContainer;
    public var bounds:DisplayObject;
    public var items:Array;
    
    protected var currentIndex:int=0;
    protected var MARGIN:int=0; //Yes, VAR
    
    //Direction stuff
    protected var horizontal:Boolean;
    
    private var _moving:Boolean;
    
    public function Visor(bounds:DisplayObject, items:Array, margin:int=0, horizontal:Boolean=false)
    {
      this.container = new Sprite();
      this.bounds = bounds;
      this.items = items;
      this.horizontal = horizontal;
      MARGIN = margin;
      
      bounds.parent.addChild(container);
      container.x = bounds.x;
      container.y = bounds.y;
      
      //Mask
      container.mask = bounds;
      
      //Add and align
      var p:int = 0;
      for each (var item:DisplayObject in items)
      {
        if(horizontal){
          item.y = 0; item.x = p;
          p+=item.width;
        } else {
          item.x = 0; item.y = p;
          p+=item.height;
        }
        p+=MARGIN;
        
        container.addChild(item);
      }
    }
    
    public function next(...whatevah):void
    {
      track('footerRightArrowClick');
      
      if(_moving) return;
      if (++currentIndex >= items.length) currentIndex=0;
      move(true);
    }
    
    public function prev(...whatevah):void
    {
      track('footerLeftArrowClick');
      
      if(_moving) return;
      if (--currentIndex < 0) currentIndex=items.length-1;
      move();
    }
    
    public function get selectedItem():*
    {
      return items[currentIndex];
    }
    public function get selectedIndex():int
    {
      return currentIndex;
    }
    
    
    public function move(left:Boolean=false):void
    {
      _moving = true;
      for (var i:int = 0; i < items.length; i++)
      {
        var destIndex:int = i-currentIndex;
        if(destIndex < 0) {
          destIndex+=items.length;
        }
        destIndex = destIndex % items.length;
        
        if(left && destIndex == items.length-1){
          destIndex = -1;
        } 
        
        if (horizontal)
        {
          items[i].x = (items[i].width + MARGIN) * (destIndex + (left?1:-1));
          TweenLite.to(items[i], .5, {x: (items[i].width + MARGIN) * destIndex, ease: Quart.easeInOut});
        } else {
          items[i].y = (items[i].height + MARGIN) * (destIndex + (left?1:-1));
          TweenLite.to(items[i], .5, {y: (items[i].height + MARGIN) * destIndex, ease: Quart.easeInOut});
        }
        
      }
      TweenLite.delayedCall(.5,function():void{
        _moving = false;
      })
      dispatchEvent(new Event(Event.CHANGE))
    }
    

  }
}