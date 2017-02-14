package com.emmanouil.ui {
	
	/*
	 * author Emmanouil Nicolas Papadimitropoulos
	 * UIImageView v0.0
	 */
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.emmanouil.ui.types.UIImageViewScaleMode;
	import com.emmanouil.utils.ChangeColor;
	import com.emmanouil.utils.Mathf;
	import com.emmanouil.net.ImageDownloader;
	
	public class UIImageView extends Sprite {

		private var _width:Number;
		private var _height:Number;
		private var _scale:Number = 1;
		private var _scaleMode:String;
		
		private var _mask:Shape;
		private var _background:Shape;
		private var _backgroundColor:uint = 0xFAFAFA;
		
		private var imageLayer:Sprite;
		private var _image:Bitmap;
		
		public var onComplete:Function;
		public var onLoadImage:Function;
		
		public function UIImageView(width:Number, height:Number) {
			
			this._width = width;
			this._height = height;
			
			_scaleMode = UIImageViewScaleMode.ScaleToFill;
			
			_background = new Shape();
			_background.graphics.beginFill(_backgroundColor);
			_background.graphics.drawRect(0, 0, _width, _height);
			_background.graphics.endFill();
			this.addChild(_background);
			
			_mask = new Shape();
			_mask.graphics.beginFill(0, 1);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
			this.addChild(_mask);	
			this.mask = _mask;
			
			imageLayer = new Sprite();
			this.addChild(imageLayer);
			
		}
		private function loadImage(path:String):void {
			if(path != "" && path != null){
				const imageDownloader:ImageDownloader = new ImageDownloader();
				imageDownloader.download(path, onCompleteDownload);
			}
			else{
				dispose();
			}
			
		}
		private function onCompleteDownload(responseImage:Bitmap):void {			
			image = responseImage;
			if(onLoadImage != null)
				onLoadImage();
		}
		private function updateElements():void {
			
			_background.width = _width;
			_background.height = _height;
			
			if(_image){
				
				_image.smoothing = true;
				_image.cacheAsBitmap = true;
				
				switch(_scaleMode){
					case UIImageViewScaleMode.ScaleToFill:
						_image.width = _background.width;
						_image.height = _background.height;
					break
					case UIImageViewScaleMode.AspectFit:
						const relacaoWidth: Number = (_background.width) / _image.width * _scale;
						const relacaoHeight:Number = (_background.height) / _image.height * _scale;
							
						const ratio:Number = (relacaoWidth < relacaoHeight) ? relacaoWidth : relacaoHeight;
						
						_image.width *= ratio;
						_image.height *= ratio;				
					break;
					case UIImageViewScaleMode.AspectFill:
						
						if(image.width > image.height){
							image.height = _background.height;
							image.scaleX = image.scaleY;
						}
						else {
							image.width = _background.width;
							image.scaleY = image.scaleX;
						}
						
						if(image.width < _background.width){
							image.width = _background.width;
							image.scaleY = image.scaleX;
						}
						if(image.height < _background.height){
							image.height = _background.height;
							image.scaleX = image.scaleY;
						}
					break;
				}
				
				_image.x = (_background.width - _image.width)/2;
				_image.y = (_background.height - _image.height)/2;
			}
			
			if(onComplete != null)
				onComplete();
			
		}
		public function get showBackground():Boolean { return _background.visible; }
		public function set showBackground(value:Boolean):void {
			_background.visible = value;
		}
		public override function get width():Number { return _width; }
		public override function set width(value:Number):void {
			_width = value;
			updateElements();
		}
		public override function get height():Number { return _height; }
		public override function set height(value:Number):void {
			_height = value;
			updateElements();
		}
		public function set imagePath(value:String):void {
			loadImage(value);
		}
		
		public function get image():Bitmap { return _image;}
		public function set image(value:Bitmap):void {
			if(value != null){
				if(value != _image){
					_image = value;				
					
					while(imageLayer.numChildren > 0){
						imageLayer.removeChildAt(0);
					}
					
					imageLayer.addChild(_image);
					
					updateElements();
				}
			}
			
		}
		public function get backgroundColor():uint { return _backgroundColor;}
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;			
			ChangeColor.Change(_backgroundColor, _background);
		}
		public function get scaleMode():String { return _scaleMode;}
		public function set scaleMode(value:String):void {
			_scaleMode = value;
			updateElements();
		}
		public function set scale(value:Number):void {
			_scale = Mathf.Clamp(value, 0, 1);
			updateElements();			
		}
		
		public function dispose():void {
			while(imageLayer.numChildren > 0){
				imageLayer.removeChildAt(0);
			}
			
			_image = null
		}

	}
	
}
