package com.emmanouil.utils {
	
	public class Mathf {

		public static function Clamp(value:Number, min:Number, max:Number):Number {
			if(value <= min){
				return min
			}
			if(value >= max){
				return max
			}
			
			return value;
		}
		public static function MaxValue(values:Array):Number {
			return Math.max.apply(null, values);
		}
		public static function MinValue(values:Array):Number {
			return Math.min.apply(null, values);
		}
	}
	
}
