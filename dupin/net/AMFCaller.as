package dupin.net {

import flash.events.NetStatusEvent;  
import flash.net.NetConnection;  
import flash.net.Responder;
import flash.events.Event;
import flash.events.ErrorEvent;
	
public class AMFCaller extends NetConnection {
	
	public var handleReady:Boolean = true;  

	public var data:Object;  
	public var gatewayURL:String;  
	public var responder:Responder;  

	public function AMFCaller(gatewayURL:String, encoding:uint=3)
	{
		this.gatewayURL = gatewayURL;  
        objectEncoding = encoding;  

        if ( gatewayURL )  
        {                         
            responder = new Responder( handleResponseResult, handleResponseFault );  
            addEventListener( NetStatusEvent.NET_STATUS, handleNetEvent );
            connect( gatewayURL );  
        }  else {
			throw new Error("no gateway given");
		}
		
	}
	
	public function send(method:String, ... args):void  
	{  
	    super.call.apply( null, [ method, responder ].concat( args ) );  
	}
	
	private function handleNetEvent(e:NetStatusEvent):void  
    {  
        dispatchEvent( new AMFEvent( AMFEvent.ERROR, e.info.code ) );  
    }  

    private function handleResponseResult(data:Object):void  
    {             
        dispatchEvent( new AMFEvent( AMFEvent.LOADED, data ) );   

        if ( handleReady )  
        {  
            handleLoaderDataReady( data );  
        }  
    }  

    public function handleLoaderDataReady(data:Object):void  
    {  
        this.data = data;  

        dispatchEvent( new AMFEvent( AMFEvent.COMPLETE, data ) );  
    }  

    private function handleResponseFault(data:Object):void  
    {  
        dispatchEvent( new AMFEvent( AMFEvent.ERROR, data ) );  
    }
	
}

}