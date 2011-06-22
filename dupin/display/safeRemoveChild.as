package dupin.display {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;

public function safeRemoveChild(obj:DisplayObject):void
{
        if(obj && obj["parent"] && obj["parent"] is DisplayObjectContainer && obj["parent"].contains(obj) ) obj["parent"].removeChild(obj);
}
	
}

