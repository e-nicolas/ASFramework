package com.emmanouil.utils {
	
	public class UnixUtils {

		public static function GetUnixTime():Number {
			var date:Date = new Date();
			var unixTime:Number = date.valueOf();
			return unixTime;
		}
		public static function GetDate(unixTime:Number = NaN):String {
			var unix:Number = !unixTime ? Number(GetUnixTime()) : unixTime;
			
			var date:Date = new Date(unix);
			
			var dia:String = toDoubleNumber(date.date);
			var mes:String = toDoubleNumber(date.month + 1);
			var ano:String = String(date.fullYear);
			
			return dia + "/" + mes + "/" + ano;
		}
		public static function GetTime(unixTime:Number = NaN):String {
			var unix:Number = !unixTime ? Number(GetUnixTime()) : unixTime;
			
			var date:Date = new Date(unix);
			
			var hora:String = toDoubleNumber(date.hours);
			var minutos:String = toDoubleNumber(date.minutes);
			
			return hora + ":" + minutos;
		}
		public static function toDoubleNumber(value:int):String {
			var formatado:String = String(value);
			
			if(value < 10){
				 formatado = "0" + formatado;
			}
			
			return formatado;
		}
		
		//format = 00:00
		public static function numberToMinutes(time:int):String {
			var minutes = Math.floor(time / 60);
			var seconds = time - minutes * 60;
			
			if(seconds < 10){
				return String(minutes + ":0" + seconds);
			}
			
			return String(minutes + ":" + seconds);
		}
		
		public static function monthPortuguese(month:int):String {
			month = Mathf.Clamp(month, 0, 11);
			const array = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];
			return array[month];
		}

	}
	
}
