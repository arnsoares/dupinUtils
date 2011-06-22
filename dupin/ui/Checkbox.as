package dupin.ui
{ 
  import flash.events.EventDispatcher;
  import flash.display.DisplayObject;
  import dupin.behaviours.MouseBehaviour;
  import flash.events.MouseEvent;
  import com.greensock.TweenLite;
  import flash.events.Event;
  public class Checkbox extends MouseBehaviour
  {
    private var _selected:Boolean=true;
    
    public function Checkbox(asset:DisplayObject, checkmark:DisplayObject)
    {
      super(asset, checkmark);
      selected = false;
    }
    
    override public function onClick(e:MouseEvent):void
    {
      selected = !selected;
    }
    
    public function get selected():Boolean
    {
      return _selected;
    }

    public function set selected(value:Boolean):void
    {
      if (value !== _selected)
      {
        TweenLite.to(target, .35, {autoAlpha: value?1:0});
        _selected = value;
        dispatchEvent(new Event(Event.CHANGE));
        dispatchEvent(new Event(MouseEvent.CLICK));
      }
    }

  }
}