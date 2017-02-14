package  com.emmanouil.utils{

	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import flash.filters.ColorMatrixFilter;
		
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	TweenPlugin.activate([TintPlugin]);
	
	public class ChangeColor {

		public static function Change(color:uint, object:DisplayObject, duration:Number = 0):void {
			const saveAlpha:Number = object.alpha;
			
			if(duration > 0){
				TweenLite.to(object, duration, {tint: color});				
			}
			else {
				const my_color: ColorTransform = new ColorTransform();
				my_color.color = color;
				object.transform.colorTransform = my_color;
			}			
			
			object.alpha = saveAlpha;
		}
		
		//retorna a cor com o brilho colocado de -1 até 1 0=sem alteração -1 = +preto 1 = +branco
		public static function MakeBrightness(value:Number, color:uint):uint {
			
			value *= 255; //para escala de cor
			value = int(value); //positivo
			
			const red:int = Mathf.Clamp(extractRed(color) + value, 0, 255);
			const green:int = Mathf.Clamp(extractGreen(color) + value, 0, 255);
			const blue:int = Mathf.Clamp(extractBlue(color) + value, 0, 255);
			
			return concatColorsToHex(red,green,blue);
			
			
		}
		//desaturação das cores em escala de 0-1, 0 = 0% saturado e 1 = cor original
		public static function MakeSaturation(value:Number, color:uint):uint {
			value = value - 1; //para inverter valor
			value *= 255; //para escala de cor
			value = Math.abs(int(value)); //positivo			
						
			var red:int = extractRed(color);
			var green:int = extractGreen(color);
			var blue:int = extractBlue(color);	
			
			const scale:int = Mathf.MaxValue([red, green, blue]);
			
			red = (red == scale) ? scale : Mathf.Clamp(red + value, 0, scale);
			green = (green == scale) ? scale : Mathf.Clamp(green + value, 0, scale);
			blue = (blue == scale) ? scale : Mathf.Clamp(blue + value, 0, scale);
			
			return concatColorsToHex(red,green,blue);
		}
		private static function extractRed(c:uint):uint {
			return (( c >> 16 ) & 0xFF);
		}		 
		private static function extractGreen(c:uint):uint {
			return ( (c >> 8) & 0xFF );
		}		 
		private static function extractBlue(c:uint):uint {
			return ( c & 0xFF );
		}
		private static function concatColorsToHex(red:Number, green:Number, blue:Number):uint {
			const intVal:int = red << 16 | green << 8 | blue;
			var hexVal:String = intVal.toString(16);
			return uint("0x" + ((hexVal.length) < 6 ? "0" + hexVal : hexVal));
		}
		
		public static function GetDominantColor(sourceImage:Bitmap):uint {
			var m: Matrix = new Matrix();
			m.scale( 1 / sourceImage.width, 1 / sourceImage.height);
			var averageColorBmd:BitmapData = new BitmapData(1, 1);
			averageColorBmd.draw(sourceImage, m);
			
			return averageColorBmd.getPixel(0,0);
		}
		
		public static function AverageColour(sourceImage:Bitmap):uint
		{
			/*
			 * Optimized
			 *
			 */
			/*
			var m: Matrix = new Matrix();
			m.scale( 10 / sourceImage.width, 10 / sourceImage.height);
			
			var source:BitmapData = new BitmapData(10, 10);
			source.draw(sourceImage, m);
			*/
			
			const source:BitmapData = sourceImage.bitmapData;
			
			var red:Number = 0;
			var green:Number = 0;
			var blue:Number = 0;

			var count:Number = 0;
			var pixel:Number;

			for (var x:int = 0; x < source.width; x++)
			{
				for (var y:int = 0; y < source.height; y++)
				{
					pixel = source.getPixel(x, y);

					red += pixel >> 16 & 0xFF;
					green += pixel >> 8 & 0xFF;
					blue += pixel & 0xFF;

					count++
				}
			}

			red /= count;
			green /= count;
			blue /= count;

			return red << 16 | green << 8 | blue;
		}
		
		

	}
	
}
