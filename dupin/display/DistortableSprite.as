package dupin.display
{ 
  import flash.display.Sprite;
  import flash.geom.Point;
  import flash.display.DisplayObject;
  import flash.display.BitmapData;
  public class DistortableSprite extends Sprite
  {
    public var container:DisplayObject;
    protected var cols:int;
    protected var rows:int;
    protected var points:Vector.<Number>;
    protected var uvs:Vector.<Number>;
    protected var indices:Vector.<int>;
    
    public function DistortableSprite(spr:DisplayObject, cols:int, rows:int)
    {
      container = spr;
      this.cols = cols;
      this.rows = rows;
      
      points=new Vector.<Number>(rows*cols*2);
      uvs=new Vector.<Number>(rows*cols*2);
      indices = new Vector.<int>();
      
      /**
       * UVs
       */
       var idx:int=0;
      for (var r:int = 0; r < rows; r++)
        for (var c:int = 0; c < cols; c++)
        {
           idx = pointIndex(r+1, c+1);
           uvs[idx] = c/(cols-1);
           uvs[idx+1] = r/(rows-1);
         }
      
    }
    
    public function getPoint(col:int, row:int):void
    {
      
    }
    
    public function setPoint(p:Point, col:int, row:int):void
    {
      var idx:int = pointIndex(row, col);
      points[idx] = p.x;
      points[idx+1] = p.y;
    }
    
    public function pointIndex(row:int, col:int):int
    {
      return (((row-1)*cols) + (col-1)) * 2;
    }
    public function triIndex(row:int, col:int):int
    {
      return (((row-1)*cols) + (col-1));
    }
    
    public function draw():void
    {
      var btmp:BitmapData = new BitmapData(container.width, container.height, true, 0x0);
      btmp.draw(container);
      
      //Cleaning indices
      indices = new Vector.<int>;
      
      //Looping to create indices
      for (var r:int = 1; r < rows; r++)
        for (var c:int = 1; c < cols; c++)
        {
          //1st tri
          indices.push(triIndex(r, c));
          indices.push(triIndex(r, c+1));
          indices.push(triIndex(r+1, c));
          //2st tri
          indices.push(triIndex(r+1, c));
          indices.push(triIndex(r+1, c+1));
          indices.push(triIndex(r, c+1));
          
          
        }
      
      graphics.clear();
      graphics.beginBitmapFill(btmp);
      
      graphics.drawTriangles(points, indices, uvs);
      
      graphics.endFill();
    }

  }
}