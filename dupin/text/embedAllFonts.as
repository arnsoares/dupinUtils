package dupin.text
{
	import flash.display.DisplayObjectContainer;
	import dupin.text.embedFonts;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	public function embedAllFonts(font:Class, haystack:DisplayObjectContainer):void
	{
		//Function used to fill with text and traverse the display list
		var traverseDisplayTree:Function = function(where: DisplayObject, maxDepth:int):void {
			
			//Did we reach the max depth?
			if(maxDepth <= 0) return;
			
			//Check if it's a TextField
			if (where is TextField)
			{
				embedFonts(font, where as TextField);
			} 
			//No let's loop through the children
			else if (where is DisplayObjectContainer)
			{
				var c:DisplayObjectContainer = where as DisplayObjectContainer;
				//Going deeper
				for (var i:int = 0; i < c.numChildren; i++)
					traverseDisplayTree(c.getChildAt(i), maxDepth-1)
			}
		}
		traverseDisplayTree(haystack, 6);
	}
}