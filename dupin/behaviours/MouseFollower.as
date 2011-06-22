package dupin.behaviours
{ 
  import potato.core.IDisposable;
  import flash.events.Event;
  import flash.display.DisplayObject;
  public class MouseFollower implements IDisposable
  {
    protected var follower:DisplayObject;
    protected var ease:Number;
    protected var doRotation:Number;
    
    private const ROTATION_LIMIT:Number = 60;

    public function MouseFollower(follower:DisplayObject, ease:Number = 0.05, doRotation:Number=0)
    {
      this.follower = follower;
      this.ease = ease;
      this.doRotation = doRotation;
      
      follower.addEventListener(Event.ENTER_FRAME, update);
    }
    
    public function update(e:Event):void
    {
      if(follower.parent) {
        follower.x += (follower.parent.mouseX - follower.x) * ease;
        follower.y += (follower.parent.mouseY - follower.y) * ease;
        
        if (doRotation != 0)
        {
          //Calculate
          var rX:Number = (follower.x - follower.parent.mouseX) / doRotation;
          var rY:Number = (follower.y - follower.parent.mouseY) / doRotation;
          
          //Constraint
          if(rX > ROTATION_LIMIT) rX = ROTATION_LIMIT;
          else if(rX < -ROTATION_LIMIT) rX = -ROTATION_LIMIT;
          if(rY > ROTATION_LIMIT) rY = ROTATION_LIMIT;
          else if(rY < -ROTATION_LIMIT) rY = -ROTATION_LIMIT;

          //Apply rotation
          follower.rotationX += (-rY - follower.rotationX)*ease;
          follower.rotationY += ( rX - follower.rotationY)*ease;
          
        }
        
      }
    }
    
    public function dispose():void
    {
      follower.removeEventListener(Event.ENTER_FRAME, update);
    }

  }
}