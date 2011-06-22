// ActionScript file
package dupin.display{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	public function removeAllChildren(p_target:DisplayObjectContainer):void{
		//Null, nothing to do
		if(!p_target) return;
		
		//Loop in children
		var child:Object;
		for(var i:Number = 0; i < p_target.numChildren; i++){
			child = p_target.getChildAt(i);
			
			if(!child)
			    continue;
			
			//Trying to dispose
			if(child.hasOwnProperty("dispose")){
			    child.dispose();
				//log("it had a destroy!");
			}
			
			if(child is DisplayObjectContainer){
				//Remove it's children first
				//log('trying to remove children of ', child);
				removeAllChildren(child as DisplayObjectContainer);
			}
			
			//Stop MovieClips wich are playing
			if(child is MovieClip){
			    child.stop();
			    //log('movieclip ' , child, ' stopped');
			}
			    
			//Removing from screen
			if(child.parent && !child.parent is Loader){
				//log("you forgot to remove ", child);
				child.parent.removeChild(child);
			}
		}
	}
}
