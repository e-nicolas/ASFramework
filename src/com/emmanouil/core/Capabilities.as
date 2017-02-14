package com.emmanouil.core {
	import flash.desktop.NativeApplication;
	import flash.system.Capabilities;
	
	public class Capabilities {

		//MARK: - Technical Configuration
		public static const NATIVE_SOFTWARE_VERSION:String = flash.system.Capabilities.os;		
		public static const OS_VERSION:String = flash.system.Capabilities.manufacturer.replace("Adobe", "");		
		public static const SCREEN_DPI:Number = flash.system.Capabilities.screenDPI;
		
		//MARK: - Screen	
		public static function GetWidth():Number {
			if(OS_VERSION.indexOf("Windows") >=0)
				return 550;
			else
				return flash.system.Capabilities.screenResolutionX;			
		}
		public static function GetHeight():Number {
			if(OS_VERSION.indexOf("Windows") >=0)
				return 400;
			else
				return flash.system.Capabilities.screenResolutionY;
		}
		public static function GetDPI():Number {
			if(OS_VERSION.indexOf("Windows") >=0)
				return 1;
			const iphone5DPI:Number = 326;
			const currentDPI:Number = flash.system.Capabilities.screenDPI;
			return currentDPI/iphone5DPI;
		}
		public static function GetApplicationVersion():String {
			var appXML:XML =  NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			var myVersion:String = appXML.ns::versionNumber;
			return myVersion;
		}
		
		
		//MARK: - Mobile
		public static function isAndroid():Boolean {
			if(OS_VERSION.indexOf("Android") != -1){
				return true;
			}
			return false;
		}
		public static function isiOS():Boolean {
			if(OS_VERSION.indexOf("iOS") != -1){
				return true;
			}
			return false;
		}
		public static function isIPhone4():Boolean {			
			if(GetHeight() > 960)
				return false;
			else
				return true;
			
			return isiOS();
		}
		
	}
	
}
