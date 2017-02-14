package com.emmanouil.net {
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Bitmap;
	
	public class ImageDownloader extends Loader {

		private var _onCompleteDownload:Function;		
		public function download(imagePath:String, onComplete:Function):void {
			_onCompleteDownload = onComplete;
			this.load(new URLRequest(imagePath));
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
		}
		public function onCompleteHandler(e:Event):void {
			const image:Bitmap = e.target.content;
			if(_onCompleteDownload != null)
				_onCompleteDownload(image);
		}

	}
	
}
