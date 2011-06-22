package dupin.net {

import flash.events.Event;
public class AMFEvent extends Event {
	
	public static const NAME:String		= 'AMFEvent';  

    public static const LOADED:String   = NAME + 'Loaded';  
    public static const COMPLETE:String = NAME + 'Complete';  
    public static const ERROR:String    = NAME + 'Error';  

    public var data:Object;  

    public function AMFEvent(type:String, data:Object=null, bubbles:Boolean=true, cancelable:Boolean=false)  
    {  
        super( type, bubbles, cancelable );  

        this.data = data;  
    }
	
}

}