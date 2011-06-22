package dupin.utils
{
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	public function extractFromMovieClip(source:MovieClip, className:String):*
	{
		if(!source) {
			return null;
		}
		
		var klass : Class = source.loaderInfo.applicationDomain.getDefinition(className) as Class;
		var myReturnObject : * = new klass();
		return myReturnObject;
	}
}