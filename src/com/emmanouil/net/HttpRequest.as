package com.emmanouil.net {
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	public class HttpRequest extends EventDispatcher {
		
		public var dataResponse:String;		
		public function HttpRequest(serviceUrl:String, urlParams:Object = null, urlRequestMethod:String = "GET") {
		   
			const variables:URLVariables = new URLVariables();
			for(var k:String in urlParams){
				variables[k] = urlParams[k];
			}
			
			const urlReq:URLRequest = new URLRequest(serviceUrl);			
			urlReq.method = urlRequestMethod;			
			urlReq.data = variables;
			
			const loader:URLLoader = new URLLoader(urlReq);
			loader.addEventListener(Event.COMPLETE, loaderComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, error);
		}		
		private function loaderComplete(e:Event):void {
			dispatchEvent(new HttpRequestEvent(HttpRequestEvent.COMPLETE, e.target.data));			
		}
		private function error(e:IOErrorEvent):void {
			dispatchEvent(new HttpRequestEvent(HttpRequestEvent.ERROR, e.text));
		}

	}
	
}
