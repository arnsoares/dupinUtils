package dupin.math
{
 /**
   * Convenience function to map a value from one range
   * to another.  Can take a descending range.Taken from processing, just renamed the variables. :)
   * 
   * @param value The value in the range A.
   * @param startA The range (in which value is included)'s start.
   * @param endA The range (in which value is included)'s end.
   * @param startB The range's - to which you are mapping the value into - start.
   * @param endA The range's - to which you are mapping the value into - end.
   * @return The number between startB and endB with the same proportion as value to startA and startB.
   *    
   * @example Loading Progress: <listing version="3.0">
   * // this is the classic example, you have a percentage for bytes loaded and want to map into
   * // a regressive count down (from 10 to 0, ten is 0% and 0 is 100%)
   * var percentLoaded : Number = 0.50;
	 var countdownStart : Number = 10;
	 var countdownEnd : Number = 0;
	 trace ( map(0.9, 0, 1, countdownStart, countdownEnd)) ; // outputs "1"
   * </listing>
   */
   public function  map(   value : Number,
                                startA : Number,  endA : Number,
                                startB : Number,  endB : Number) : Number{
    return startB + (endB - startB) * ((value - startA) / (endA - startA));
  }
}