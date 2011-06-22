package dupin.display{

    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import flash.display.Stage;

    public function bitmapData(o:DisplayObject):BitmapData{
	
			if(!o is Stage){
				var oldX:Number=o.x
				var oldY:Number=o.y;
			
				o.x = o.y = 0;
			}
		
	    var b:BitmapData = new BitmapData(Math.max(o.width, 1), Math.max(o.height,1), true, 0x0);
	    b.draw(o);
	
			if (!o is Stage)
			{
				o.x = oldX;
				o.y = oldY;
			}
	    return b;
    }
}
