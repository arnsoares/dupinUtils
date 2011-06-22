package dupin.particles.motion
{ 
  import flash.geom.Vector3D;
  import dupin.particles.motion.IParticleMotion;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.BitmapDataChannel;
  import flash.geom.Point;
  public class PerlinMotion implements IParticleMotion
  {
    
    public var bitmap:Bitmap;
    public var speed:Number;
    protected var seed:int;
    protected var offset:Number;
    protected const SMOOTH:Number = 1;
    protected var lastVals:Array;
    
    public function PerlinMotion(particleNumber:int, speed:Number=0.5)
    {
      this.speed = speed;
      bitmap = new Bitmap(new BitmapData(3, particleNumber*3));
      bitmap.width = 50; //debug
      lastVals = new Array(particleNumber);
      seed = Math.random()*1000;
      offset = 0;
      
      update();
    }
    
    public function moveParticle(particleIndex:int):Vector3D{
      var lastVal:Vector3D = lastVals[particleIndex];
      var vec:Vector3D =  new Vector3D(
        ((bitmap.bitmapData.getPixel(1, particleIndex*3) & 0xff)-128)/SMOOTH,
        (bitmap.bitmapData.getPixel(2, particleIndex*3+1) & 0xff)/SMOOTH,
        ((bitmap.bitmapData.getPixel(3, particleIndex*3+2) & 0xff)-128)/SMOOTH
      );
      lastVals[particleIndex] = vec;
      if(!lastVal)
        return new Vector3D();
      else
        return new Vector3D(lastVal.x - vec.x, -Math.abs(lastVal.y - vec.y), lastVal.z - vec.z);
    }
    
    public function update():void
    {
      var p:Point = new Point(offset, 0);
      bitmap.bitmapData.perlinNoise(25, 11, 1, seed, false, true, BitmapDataChannel.RED, true, [p, p, p]);
      offset+=speed;
    }

  }
}