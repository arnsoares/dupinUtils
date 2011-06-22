// ActionScript file
package dupin.display {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	
	public function drawRect(target:Sprite, x:Number = 0, y: Number = 0, width:Number = 50, height:Number = 50, color:uint=0xcc0000, alpha:Number=1, pattern:BitmapData=null):void{
		if(!pattern)
		  target.graphics.beginFill(color, alpha);
		else
		  target.graphics.beginBitmapFill(pattern);
		  
		target.graphics.drawRect(
		  x, 
		  y, 
		  width == -1 ? target.width : width, 
		  height == -1? target.height : height
		);
		target.graphics.endFill();
	}
}
