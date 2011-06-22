package dupin.text{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
    import flash.utils.getTimer;     
	import flash.display.Stage;
	
	[Event(name="key_down", type="flash.events.Event")]          
	[Event(name="key_up", type="flash.events.Event")]
                 
    /**                       
    * Wrapper for Keyboard events and key sequences.
    *  @example Basic usage:<listing version="3.0">  
    * var o:KeyManager = new KeyManager(stage);
    * o.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    * o.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    *
    * o.isDown("c");
    * o.isDown(Keyboard.CONTROL);
    * o.areKeysDown(Keyboard.CONTROL, "c");
    * o.watchSequence([Keyboard.UP, Keyboard.DOWN, Keyboard.LEFT], sequenceIsDone);
    *
    * //keys are only considered down with an interval of 5 seconds 
    * o.defaultDelay = 5000; 
    *
    * //key "c" is only considered down with an interval of 10 seconds
    * o.setKeyDelay("c", 10*1000);                                                                                                    
    *
    * //using static shortcuts
    * KeyManager.isDown("w");
    * KeyManager.areKeysDown("w", "e");
    * KeyManager.events.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    * KeyManager.watchSequence("help", showHelpInfo, 1000);
    * </listing>
    * @author Gabriel Laet    
    */
    
	public class KeyManager extends EventDispatcher
	{    
		public static const DEFAULT_DELAY:Number = 10;
		public static var instances:Dictionary = new Dictionary(true);
		public static var events:EventDispatcher = new EventDispatcher();                                           
		  
		/**
		* Defines a default delay for all keys.
		* @see #setKeyDelay
		*/
		public var defaultDelay:Number;
		
		/**
		* Types that will be ignored from KEY_DOWN/KEY_UP events
		* @example
		* var o:KeyManager = new KeyManager(stage);
		* o.ignoreEventsFromTypes = [TextField];
		*/

		public var ignoreEventsFromTypes:Array;
		
		/**
		* @private
		*/
		public var _target:IEventDispatcher;
		
		/**
		* @private
		*/
		public var _keysDown:Dictionary;
		
		/**
		* @private
		*/
		public var _keysUp:Dictionary;
		
		/**
		* @private
		*/
		public var _keysDelay:Dictionary;
		
		/**
		* @private
		*/
		public var _keysFixedDelay:Dictionary;                   
		
		/**
		* @private
		*/
		public var _sequences:Array;
		
		public function KeyManager(targetToListen:IEventDispatcher, delayBetweenKeys:Number=DEFAULT_DELAY)
		{
			target = targetToListen;
			defaultDelay = delayBetweenKeys;
			KeyManager.instances[targetToListen] = this;
		}
		
		/**
		* Defines the target which will sent KEY_DOWN and KEY_UP events.     
		* For removing a target, simply set as null.
		* @param targetToListen Mostly likely this will be a DisplayObject - but you can set any IEventDispatcher
		*/                    
		
		public function set target(targetToListen:IEventDispatcher):void
		{
			if(_target != null){
				_target.removeEventListener(KeyboardEvent.KEY_DOWN, keyEvent);
				_target.removeEventListener(KeyboardEvent.KEY_UP, keyEvent);
			}
			
			_target = targetToListen;	
			_keysDown = new Dictionary(true);
			_keysUp = new Dictionary(true);
			_keysDelay = new Dictionary(true);
			_keysFixedDelay = new Dictionary(true);        
			_sequences = [];
				
			if(_target != null){
				_target.addEventListener(KeyboardEvent.KEY_DOWN, keyEvent);
				_target.addEventListener(KeyboardEvent.KEY_UP, keyEvent);
			}
		}	         
		                               
		/**
		* Returns the target used for listening keyboard events.
		* This value can also be null if a target is not defined.
		*/
		
		public function get target():IEventDispatcher
		{
			return _target;
		}
		                                               
		/** 
		* @private        
		* Internal method for converting char (String) into key-code (uint)                     
		*/                                           
		
		public function getKeyCode(key:*):uint
		{
			if(key is String){
				return String(key).toUpperCase().charCodeAt();
				
			}else{
				return uint(key);
			}                                                        
		}
		                                      
 		/** 
 		* @private       
 		* Internal listener for keyboard events
 		*/                                     
 		
		public function keyEvent(e:KeyboardEvent):void
		{
			//Will check if event.target type 
			//is defined at #ignoreEventsFromTypes
			if(ignoreEventsFromTypes != null){
				var index:int = ignoreEventsFromTypes.length;
				while(index--){
					if(e.target is ignoreEventsFromTypes[index]){
						return;
					}
				}
			}
			
			
			switch(e.type){
				case KeyboardEvent.KEY_DOWN:  
					_keysDown[e.keyCode] = true;
					_keysUp[e.keyCode] = null;
					delete _keysUp[e.keyCode];      
					
					if(keyIsAvailable(e.keyCode)){
					    checkSequences(e.keyCode);
				    }
				    
					break;
					
				case KeyboardEvent.KEY_UP:
					_keysUp[e.keyCode] = true;
					_keysDown[e.keyCode] = null;
					delete _keysDown[e.keyCode];
					break;
			}	
			
			KeyManager.events.dispatchEvent(e.clone());
			dispatchEvent(e.clone());
			
		}
	   
	    /**
	    * Returns an array with all the keys which are pressed.
	    * This array will contain only uint values.
	    */
	    
		public function get keysDown():Array
		{
			var keys:Array = [];
			for(var k:String in _keysDown) keys.push(k);
			return keys;
		}
                 
        /**
        * Checks whether a key is pressed or not.
        * @param key An uint or String (char)
        */
        
        public function isDown(key:*):Boolean
		{
			key = getKeyCode(key);                 
			if(Boolean(key in _keysDown)){
				if(!keyIsAvailable(key)){
					return false;
				}
				
				_keysDelay[key] = getTimer();
				return true;
				
			}else{
				return false;
			}
		}    
		  
	    /**
	    * Checks whether multiple keys are pressed together.
	    * @param keys List with uint or String (char) values
	    */                                                  
	    
		public function areKeysDown(...keys):Boolean
		{       
			var down:Boolean;
			for(var i:int = 0; i<keys.length; i++){
				down = isDown(keys[i]);
			}                          
			
			return down;
		}   
		
		/**
		* Checks if there is any key pressed.
		*/
		public function hasKeysDown():Boolean
		{
			var count:int = 0;
			for each(var o:* in _keysDown){
				count++;
			}	
			
			return count > 0;
		}                                       
		   
		/**
		* Cleanup the keys pressed list
		*/
		      
        public function resetDownKeys():void
        {
            for (var key:Object in _keysDown) {
                delete _keysDown[key];
            }  
        }
        
        /**
        * Checks whether a key is up or not.   
        * Up keys are keys which were pressed before.
        * @param key An uint or String (char)  
        */
        
		public function isUp(key:*):Boolean
		{
			key = getKeyCode(key);
			
			if(Boolean(key in _keysUp)){
				delete _keysUp[key];
				return true;
				
			}else if(isDown(key)){
				return false;
				
			}else{
			    return true;
			}
			
		}
		    
	   /**
	   * Cleanup the keys up list
	   */
	   
	   public function resetUpKeys():void
	   {
           for (var key:Object in _keysUp) {
               delete _keysUp[key];
           }
	   }   
	   
	   /**
        * You can specify an specific delay for an specific key-code.   
        * If you never set a delay for a key, the class will use #defaultDelay
        * @param key The key code. String (char) or uint.      
        * @param keyDelay Interval between key presses
        */

		public function setKeyDelay(key:*, keyDelay:Number):void 
		{
			key = getKeyCode(key);
			_keysFixedDelay[key] = keyDelay;
		}
        
        /**
        * Returns the current delay for a key. If the delay was never defined,
        * the value will be #defaultDelay
        */
        
		public function getKeyDelay(key:*):Number
		{
			key = getKeyCode(key);
			return key in _keysFixedDelay ? _keysFixedDelay[key] : defaultDelay;
		}
		
		/**
		* @private
		* Internal method for checking if the key is available based on
		* the defined delay
		*/
		
		public function keyIsAvailable(key:*):Boolean
		{
		    return !((getTimer() - _keysDelay[key]) < getKeyDelay(key));
		}
		      
          
  		/**
  		* Watch for a key sequence. You can register a callback that will
  		* be called when the sequence is completed.
  		* @param keySequence A String or an array of strings (char) and/or uint (key-code) values.
  		* @param callback A function to be called when then sequence is completed.
  		* The function doesn't have any arguments.
  		* @param maxTime Maximum time for "typing" the sequence.
  		*/
        
		public function watchSequence(keySequence:*, callback:Function, maxTime:Number=NaN):void
		{                
		    var sequence:Object = getSequence(keySequence);
		                  
			if(sequence == null){       
			    sequence = {};
			    _sequences.push(sequence);
            }                             
            
            sequence.keys = keySequence;
            sequence.callback = callback;
            sequence.maxTime = maxTime;      
            sequence.pointer = -1;  
            sequence.timer = -1;
		}   
		           
		/**
		* Stop watching a sequence. You can either unregister an specific function or
		* unregister all the functions if listener is null.
		* @param keySequence A String or an array of strings (char) and/or uint (key-code) values.     
		* @listener A Function that will un registar that specific sequence and function, or 
		* an null object so that all notifications for this sequence are removed.
		*/
		
		public function unwatchSequence(keySequence:*, callback:Function=null):void
		{                                                                                    
		    var callbackIsEqual:Boolean;
		    
            for(var i:int = 0; i<_sequences.length; i++){                               
                callbackIsEqual = callback == null || (callback == _sequences[i].callback);
                if(sequencesAreEqual(_sequences[i].keys, keySequence) && callbackIsEqual){
                    _sequences[i] = null;
                    _sequences.splice(i, 1);
                }
            }
		}           
		                                                                     
		/**
		* @private
		* Internal method for checking if sequences are completed.
		* This method is called everytime we have a KEY_DOWN event (@see #keyEvent)
		*/                                                                         
		
		public function checkSequences(key:*):void
		{                      
		    var hasTimer:Boolean;
		    
		    for(var i:int = 0; i<_sequences.length; i++)
		    {
		        hasTimer = _sequences[i].timer > -1 && !isNaN(_sequences[i].maxTime);
		        
                if(hasTimer && getTimer()-_sequences[i].timer > _sequences[i].maxTime){
		            _sequences[i].pointer = -1;
		            _sequences[i].timer = -1;
                }
		        
		        if(sequenceNextKey(_sequences[i]) == key){                    
                    if(_sequences[i].timer == -1){
                       _sequences[i].timer = getTimer();
                        
                    }

                    _sequences[i].pointer++;                                                 
		            
                    if(sequenceIsDone(_sequences[i])){     
                        _sequences[i].pointer = -1;
                        _sequences[i].callback.apply(null);
                    }                           
		        }
	        }
		}             
		                                            
		/**                                         
		* @private
		* Returns the next key-code in the sequence.
        */                          
		public function sequenceNextKey(sequence:Object):uint
		{
		    if(sequence.keys is Array){
                return getKeyCode(sequence.keys[sequence.pointer+1]);
                
		    }else{
		        return getKeyCode(sequence.keys.charAt(sequence.pointer+1));
		    }
		}
        
        /**
        * @private
        * Checks whether a sequence is completed or not
        */
        
		public function sequenceIsDone(sequence:Object):Boolean
		{
            return sequence.pointer == sequence.keys.length-1;
		}   
		
		/**
		* @private
		* Returns the sequence object
		*/
		
		public function getSequence(keySequence:*):Object
		{		      
            for(var i:int = 0; i<_sequences.length; i++){
                if(sequencesAreEqual(_sequences[i].keys, keySequence)){
                   return _sequences[i];
                   break; 
                }
            }            
            
            return null;
		}                      
		
		/**
		* @private
		* Checks if two sequences are the same. This is necessary since 
		* sequences could be Strings or Arrays
		*/           
		
		public function sequencesAreEqual(sequenceA:*, sequenceB:*):Boolean
		{
			if(typeof(sequenceA) == typeof(sequenceB)){
			   if(sequenceA is String){
			       return sequenceA == sequenceB;
			   }                                 
			   
               if(sequenceA is Array)
               {
                   if(sequenceA.length == sequenceB.length){
				       for(var i:int = 0; i<sequenceA.length; i++)
				       {
					  		if(sequenceA[i] != sequenceB[i]){
						    	return false;
							}
					   }
					
					   return true;
					}                            
				}
			}

			return false;
		}
		
		 
		/**
		* Static shortcuts. Every instance of KeyManager you create is added
		* to the #KeyManager.instances Dictionary. We have all the public API
		* available on KeyManager instances as static methods, as a shortcut
		* for your instances. All the shortcut methods will loop through this list
		* and call the methods until it finds a good value. 
		* Instances with Stage as target are prioritized.
		*/
		
        public static function get all():Array
        {       
            var objs:Array = [];
            
            for each(var m:KeyManager in KeyManager.instances){
                if(m.target is Stage){
                    return [m];  
                    
                }else{
                    objs.push(m);
                }
            }       
            
            return objs;
        }   
        
        /**
        * Returns a KeyManager instance based on a target.
        * @param target Object used for listening keyboard events
        */
		public static function getByTarget(target:IEventDispatcher):KeyManager
		{ 
            return instances[target] 
        };
               
		
      	/**  
      	* Static shortcut.
      	* @see #all
        * @see #isDown
        */  			
		public static function isDown(key:*):Boolean
		{
			for each(var m:KeyManager in KeyManager.all){
				if(m.isDown(key)){
					return true;
				}
			}	
			
			return false;
		} 
		
	  	/**  
      	* Static shortcut.
      	* @see #all
        * @see #areKeysDown
        */  			
		public static function areKeysDown(...keys):Boolean
		{
			for each(var m:KeyManager in KeyManager.all){
				if(m.areKeysDown.apply(m, keys)){
					return true;
				}
			}	
			
			return false;
		}
			
      	/**     
      	* Static shortcut.
      	* @see #all
        * @see #isUp
        */  	
		
		public static function isUp(key:*):Boolean
		{
			for each(var m:KeyManager in KeyManager.all){
				if(m.isUp(key)){
					return true;
				}
			}	
			
			return false;
		}
    	
    	/** 
    	* Static shortcut.
    	* @see #all
        * @see #resetUpKeys
        */
         	
		public static function resetUpKeys():void
		{			
			for each(var m:KeyManager in KeyManager.all){
                m.resetUpKeys();
			}
		}  
 	    
 	    /**        
 	    * Static shortcut.
 	    * @see #all
        * @see #resetDownKeys
        */
           	
	   	public static function resetDownKeys():void
		{			
			for each(var m:KeyManager in KeyManager.all){
                m.resetDownKeys();
			}
		}  
	   
	    /**  
        * Static shortcut.  
        * @see #all 
        * @see #hasKeysDown
        */
                      
		public static function hasKeysDown():Boolean
		{
			for each(var m:KeyManager in KeyManager.all){
				if(m.hasKeysDown()){
					return true;
				}
			}
			
			return false;
		}
  
        /**       
        * Static shortcut.  
        * @see #all
        * @see #keysDown
        */
  	
		public static function get keysDown():Array
		{
			var keys:Array = [];
			
			for each(var m:KeyManager in KeyManager.all){
				keys = keys.concat(m.keysDown);
			}
			
			return keys;
		}
                                    

        /**     
        * Static shortcut.  
        * @see #all  
        * @see #watchSequence
        */
        
        public static function watchSequence(keySequence:*, callback:Function, maxTime:Number=NaN):void      
        {
            for each(var m:KeyManager in KeyManager.all){ 
                m.watchSequence(keySequence, callback, maxTime);
            }
        }     
                                           
        /**  
        * Static shortcut.
        * @see #all
        * @see #unwatchSequence
        */
        public static function unwatchSequence(keySequence:*, callback:Function=null):void      
        {
            for each(var m:KeyManager in KeyManager.all){ 
                m.unwatchSequence(keySequence, callback);
            }
        }
                               
	}
}