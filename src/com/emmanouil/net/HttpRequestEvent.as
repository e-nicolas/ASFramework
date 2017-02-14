package com.emmanouil.net
{
	import flash.events.Event;

	public class HttpRequestEvent extends Event {
		
		public static const COMPLETE:String = 'complete';
		public static const ERROR:String = 'error';
		
		public var data:String;
		public var error:String;
		public function HttpRequestEvent(type:String, response:String) {
			
			if(type == COMPLETE)
				this.data = response;
			if(type == ERROR)
				this.error = response;
			
			super(type, false, false);
		}

	}

}
