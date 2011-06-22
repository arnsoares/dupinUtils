package dupin.math
{	
	public function addZero(n:Number):String
	{
		if (n >= 0)
		{
			return n < 10 ? "0"+n : n+"";
		} else {
			n = Math.abs(n);
			return "-" + (n < 10 ? "0"+n : n+"");
		}
	}
}
