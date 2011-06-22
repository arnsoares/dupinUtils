package dupin.particles.motion
{ 
  import flash.geom.*
  public interface IParticleMotion
  {
    function moveParticle(particleIndex:int):Vector3D;
    function update():void;
  }
}