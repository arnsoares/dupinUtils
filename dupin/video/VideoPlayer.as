package dupin.video {

import flash.net.NetStream;
import flash.net.NetConnection;
import dupin.display.safeRemoveChild;
import flash.display.Sprite;
import flash.media.Video;
import flash.events.NetStatusEvent;
import flash.events.Event;
import flash.media.SoundTransform;
import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.BitmapData;
public class VideoPlayer extends Sprite {
	
	public var _video:Video;
	public var _url:String;
	public var _connection:NetConnection;
	public var _stream:NetStream;
	public var _client:Object;
	public var _playing:Boolean;
	public var _bufferTime:Number = 5;
	public var _duration:Number;
	
	public var _overlay:Shape;
	public var _tile:BitmapData;
	
	public var _width:Number = 320, _height:Number = 240;
	
	public static const BUFFER_EMPTY:String = "buffer_empty";
	public static const BUFFER_FULL:String = "buffer_full";
	public static const PLAY:String = "play";
	
	public function VideoPlayer(url:String = null, tile:BitmapData = null)
	{
		//video
		_video = new Video(_width, _height);
		_video.smoothing = true;
		addChild(_video);
		
		//Cliet for metadata and cuepoints
		_client = {};
		_client.onMetaData = metaDataHandler;
		
		//Connecting to a stream if a url is given
		if(url){
			_url = url;
			_connection = new NetConnection();
			_connection.connect(null);
		}
		
		_overlay=new Shape();
		_tile = tile;
	}
	
	public function set url(value:String):void
	{
		_url = value;
		if(stream){
			stream.close();
			setStream(null)
		}
	}
	
	public function play():void
	{
		if(!stream){
			if(!_url) throw new Error("No url givven");
			
			setStream(new NetStream(_connection));
			stream.bufferTime = _bufferTime;
			stream.play(_url);
		} else {
			stream.resume();
		}
		
		_playing = true;
	}
	
	public function pause():void
	{
		_stream.pause();
		_playing = false;
	}
	
	public function stop():void
	{
		pause();
		_stream.seek(0);
	}
	
	public function createTile():void
	{
		if(_tile){
			_overlay.graphics.clear();
			_overlay.graphics.beginBitmapFill(_tile);
			_overlay.graphics.lineTo(width, 0);
			_overlay.graphics.lineTo(width, height);
			_overlay.graphics.lineTo(0, height);
			_overlay.graphics.lineTo(0, 0);
			_overlay.graphics.endFill();
			addChild(_overlay);
		}
	}
	
	public function set bufferTime(value:Number):void
	{
		_bufferTime = value;
		
		if(_stream)
			_stream.bufferTime = value;
	}
	
	public function onNetStatus(event:NetStatusEvent):void
	{
		switch(event.info.code){
			case "NetStream.Unpause.Notify":
				_playing = true;
				break;
			
			case "NetStream.Pause.Notify":
				_playing = false;
				break;
			case "NetStream.Play.Start" :
				_playing = true;
				dispatchEvent(new Event(PLAY));
			break;
			
			case "NetStream.Buffer.Empty" :
				dispatchEvent(new Event(BUFFER_EMPTY));
			break;
			
			case "NetStream.Buffer.Full" :
				dispatchEvent(new Event(BUFFER_FULL));
			break;
				
			case "NetStream.Play.Stop" :
				dispatchEvent(new Event(Event.COMPLETE));
			break;
		}
		//log("VideoPlayer::onNetStatus()", event.info.code, stream.time, _duration);
	}
	public function seek(val:Number):void
	{
		if(stream)
			stream.seek(val);
	}
	
	override public function set width(value:Number):void
	{
		_width = value
		_video.width = value;
		createTile();
	}
	override public function get width():Number
	{
		return _video.width;
	}
	override public function set height(value:Number):void
	{
		_height = value;
		_video.height = value;
		createTile();
	}
	override public function get height():Number
	{
		return _video.height;
	}
	
	//Getter and setter for netstream
	public function get stream():NetStream
	{
		return _stream;
	}
	public function setStream(value:NetStream, metaData:Object=null):void
	{
		_stream = value;
		if(value){
			
			if(!_video){
				_video = new Video(_width, _height);
				_video.smoothing = true;
				addChild(_video);
			}
			
			_stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus)
			_stream.client = _client;
			_video.attachNetStream(_stream);
			
			if(metaData) metaDataHandler(metaData);
		}
	}
	
	//Getter for playing
	public function get playing():Boolean
	{
		return _playing;
	}
	
	//Getter and setter for volume
	public function get volume():Number{
		return stream.soundTransform.volume;
	}
	public function set volume(value:Number):void
	{
		var st:SoundTransform = stream.soundTransform;
 		st.volume=value;
		stream.soundTransform=st;
	}
	
	public function metaDataHandler(o:Object):void
	{
		if(!o) return;
		//Set width and height based on metadata
		if (o.hasOwnProperty("width"))
		{
		  _video.width = o.width;
		  _video.height = o.height;
		}
		
		//when not specifying a width or height
		_duration = o.duration;
		
		dispatchEvent(new Event(Event.INIT));
	}
	
	public function dispose():void
	{
		try
		{
			stop();
		} catch(err:Error){}
		safeRemoveChild(_video);
		_video = null;
		_stream = null;
	}
}

}
