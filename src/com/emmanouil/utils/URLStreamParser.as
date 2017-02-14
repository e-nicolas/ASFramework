package com.emmanouil.utils{
	
	/*
	 *	@author Emmanouil Nicolas Papadimitropoulos
	 *
	 */
	
	public class URLStreamParser {
		
		public static function Parse(uri: String): Object {
			const obj:Object = new Object();
			if (uri != "") {

				obj.protocol = getProtocol(uri);
				obj.urlStream = getUrl(uri);
				obj.stream = getStreamName(uri);
				obj.fileType = getStreamFileType(obj.stream);
				
				if(obj.fileType)
					obj.onDemand = true;
				else
					obj.onDemand = false;
				
				return obj;
			}			
			return null;			
		}
		private static function getUrl(uri:String):String {
			if (uri.lastIndexOf("/") > 0) {
				return uri.substring(0, uri.lastIndexOf("/") + 1);
			}
			return null;				
		}
		private static function getStreamName(uri:String):String {
			if (uri.lastIndexOf("/") > 0) {
				return uri.substring(uri.lastIndexOf("/") + 1);
			}
			return null;				
		}
		private static function getStreamFileType(streamName:String):String {
			if (streamName.indexOf(".") > 0) {
				return streamName.substring(streamName.indexOf("."));
			}
			return null;
		}
		private static function getProtocol(uri:String):String {
			if (uri.indexOf("://") != -1) {
				return uri.substr(0, uri.indexOf("://"));
			}
			return null;
		}

	}
	
}
