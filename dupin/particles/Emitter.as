package dupin.particles
{ 
  import flash.display.Sprite;
  import potato.core.IDisposable;
  import flash.events.Event;
  import flash.display.Bitmap;
  import potato.display.safeRemoveChild;
  import flash.display.BitmapData;
  import dupin.particles.motion.IParticleMotion;
  import dupin.particles.motion.PerlinMotion;
  import flash.geom.Rectangle;
  import flash.geom.Vector3D;
  import flash.display.DisplayObject;
  import flash.utils.setInterval;
  import flash.geom.Point;
  import dupin.display.drawRect;
  import flash.utils.clearInterval;
  
  /**
   * Particle emmiter
   * config keys:
   * 
   * particleType:Class           Class of the DisplayObject do emit
   * creationInterval:int         Milis to wait before creating a new particle
   * maxParticles:int             Maximum number of particles
   * motion:IParticleMotion       Type of motion (Defaults to perlin)
   * bounds:Rectangle             Bounds of the emitter (Defaults to: 500, 500)
   * beforeKill:Function          Function called to execute custom code before particle destruction expected signature: beforeKill(particle:DisplayObject, callWhenDone:Functio):void
   * 
   * @langversion ActionScript 3
   * @playerversion Flash 9.0.0
   * 
   * @author Lucas Dupin
   * @since  08.03.2011
   */
  public class Emitter extends Sprite implements IDisposable
  {
    public static var RANDOM:String = "random";
    public static var BOTTOM:String = "bottom";
    
    //Config
    public var motion:IParticleMotion;
    protected var ParticleType:Class;
    protected var creationInterval:int;
    protected var maxParticles:int;
    protected var bounds:Rectangle;
    protected var beforeKill:Function;
    protected var initialPosition:String;
    
    // Internals
    private var _interval:int;
    protected var particles:Vector.<DisplayObject>;
    
    public function Emitter(config:Object=null)
    {
      config ||= {};
      
      //Setup
      ParticleType = config.particleType || DummyParticle;
      maxParticles = config.maxParticles || 50;
      creationInterval = config.creationInterval || 500;
      motion = config.motion || new PerlinMotion(maxParticles);
      bounds = config.bounds || new Rectangle(0, 0, 500, 500);
      beforeKill = config.beforeKill || _beforeKill;
      particles = new Vector.<DisplayObject>();
      initialPosition = config.initialPosition || BOTTOM;
      
      //Start emmiting
      addEventListener(Event.ENTER_FRAME, update, false, 0, true);
      //Create particles
      _interval = setInterval(createParticle, creationInterval);
      createParticle();
    }
    
    public function pause():void
    {
      removeEventListener(Event.ENTER_FRAME, update);
    }
    public function resume():void
    {
      addEventListener(Event.ENTER_FRAME, update, false, 0, true);
    }
    
    public function set boundsVisible(value:Boolean):void
    {
      if(value){
        with(graphics){beginFill(0xcc0000, 0.1), drawRect(bounds.x, bounds.y, bounds.width, bounds.height)};
      } else {
        graphics.clear();
      }
    }
    
    public function createParticle():void
    {
      if(particles.length >= maxParticles) return;
      
      //Create particle
      var p:DisplayObject = new ParticleType();
      addChild(p);
      //Positioning it
      if(initialPosition == BOTTOM){
        p.x = bounds.x + Math.random()*bounds.width;
        p.y = bounds.y + bounds.height - 1;
      } else if(initialPosition == RANDOM) {
        p.x = bounds.x + Math.random()*bounds.width;
        p.y = bounds.y + Math.random()*bounds.height;
      }
      
      
      particles.push(p);
    }
    
    public function update(e:Event):void
    {
      var pos:Vector3D;
      var p:DisplayObject;
      var i:Number=particles.length;
      while(--i > -1)
      {
        pos = motion.moveParticle(i);
        p = particles[i];
        p.x += pos.x;
        p.y += pos.y;
        p.z += pos.z;
        
        ////Kill?
        if(!bounds.containsPoint(new Point(p.x, p.y))){
          particles.splice(i, 1);
          tryToKill(p, i);
        }
      }
      motion.update();
    }
    public function tryToKill(p:DisplayObject, i:int):void
    {
      beforeKill(p, function():void{
        removeChild(p);
      })
    }
    
    public function dispose():void
    {
      removeEventListener(Event.ENTER_FRAME, update);
      clearInterval(_interval);
    }
    
    public function _beforeKill(p:DisplayObject, callback:Function):void
    {
      callback();
    }

  }
}
import flash.display.Shape;
internal class DummyParticle extends Shape
{
  public function DummyParticle()
  {
    with(graphics) beginFill(0xcc0000), drawCircle(0,0,10), endFill();
  }
}