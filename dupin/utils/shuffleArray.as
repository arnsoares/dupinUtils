package dupin.utils {

public function shuffleArray(arr:Array):Array {
	var arr2:Array = [];

	while (arr.length > 0) {
	arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
	}
	arr = arr2;
	return arr;
	
}

}

