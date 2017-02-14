package com.emmanouil.assets {
	
	import flash.text.Font;
	
	public class Assets {

		/**
		 * Font Example
		 */
		//[Embed(source="/assets/fonts/Lato/Lato-Regular.ttf", fontName="Lato", fontFamily="Lato", mimeType="application/x-font-truetype", embedAsCFF="false")]
		//public static const Lato:Class;
		
		
		//Images
		[Embed(source = "/com/emmanouil/assets/UIActivityIndicatorView.png")]
		public static var UIActivityIndicatorViewPNG:Class;
		
		[Embed(source = "/com/emmanouil/assets/Icon_Close.png")]
		public static var Icon_ClosePNG:Class;
		
		[Embed(source = "/com/emmanouil/assets/Icon_Left_Arrow.png")]
		public static var Icon_Left_ArrowPNG:Class;
		
		
		//----------------------------------------------------------------
		//methods
		public static function getFonts(name:String):Font {
			for (var i:int =0; i < Font.enumerateFonts(true).length; i++){
				//se achar
				if(name == Font.enumerateFonts(true)[i].fontName){
					return Font.enumerateFonts(true)[i];
				}
				//procura alguma relacionada
				if(name.indexOf(Font.enumerateFonts(true)[i].fontName) != -1){
					return Font.enumerateFonts(true)[i];
				}				
			}
			//se não achar nenhuma
			//throw new Error("Não achou a fonte com nome: " + name);
			return null;
		}
		public static function getFontsNames():void {
			for (var i:int =0; i < Font.enumerateFonts(true).length; i++){
				trace(Font.enumerateFonts(true)[i].fontName);
			}
		}
		
		
	}
	
}
