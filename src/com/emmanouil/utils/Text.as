package com.emmanouil.utils {
	
	/* author Emmanouil Nicolas Papadimitropoulos
	 *
	 */
	
	public class Text{

		public static function limitText(text:String, limit:Number):String {
			var textLimited:String = ''
			if(text != ''){				
				if(text.length > limit){
					textLimited = text.slice(0, limit - 3);
					textLimited += '...';							
					
				} else {
					textLimited = text;
				}
			}
			return textLimited;
		}
		
		public static function IsValidEmail(email:String):Boolean {
			var emailExpression:RegExp = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/;
			return emailExpression.test(email);
		}

	}
	
}
