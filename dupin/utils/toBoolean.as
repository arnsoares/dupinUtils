package dupin.utils {

public function toBoolean(s:String):Boolean {
	if(s && s.toLowerCase() == "true")
		return true;
		
	return false;
}

}