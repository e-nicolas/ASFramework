package com.emmanouil.ui
{
	
	/*
	 * author Emmanouil Nicolas Papadimitropoulos
	 * UIMovieClipView v0.0
	 */
	
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import com.emmanouil.utils.ChangeColor;
	import com.emmanouil.utils.Mathf;
	import com.emmanouil.ui.types.UIImageViewScaleMode;
	
	
	public class UIMovieClipView extends Sprite
	{		
		private var _width:Number;
		private var _height:Number;
		private var _scale:Number = 1;
		private var _scaleMode:String;
		private var _movieClip:DisplayObject;		
		
		private var _mask:Shape;
		private var _background:Shape;
		private var _backgroundColor:uint = 0xFAFAFA;
		
		public function UIMovieClipView(width:Number, height:Number, movieClip:DisplayObject = null)
		{
			_width = width;
			_height = height;	
			
			_background = new Shape();
			_background.graphics.beginFill(_backgroundColor);
			_background.graphics.drawRect(0, 0, _width, _height);
			_background.graphics.endFill();
			this.addChild(_background);
			showBackground = false;
			
			_mask = new Shape();
			_mask.graphics.beginFill(0, 0);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
			this.addChild(_mask);	
			this.mask = _mask;
			
			_scaleMode = UIImageViewScaleMode.AspectFit;
			
			if(movieClip != null)
				this.movieClip = movieClip;
		}
		private function updateElements():void {
			
			_background.width = _width;
			_background.height = _height;
			
			_mask.width = _width;
			_mask.height = _height;
			
			if(_movieClip){
				
				switch(_scaleMode){
					case UIImageViewScaleMode.ScaleToFill:
						_movieClip.width = _background.width;
						_movieClip.height = _background.height;
					break
					case UIImageViewScaleMode.AspectFit:
						const relacaoWidth: Number = (_background.width) / _movieClip.width * _scale;
						const relacaoHeight:Number = (_background.height) / _movieClip.height * _scale;
							
						const ratio:Number = (relacaoWidth < relacaoHeight) ? relacaoWidth : relacaoHeight;
						
						_movieClip.width *= ratio;
						_movieClip.height *= ratio;				
					break;
					case UIImageViewScaleMode.AspectFill:
						if(_movieClip.width > _movieClip.height){
							_movieClip.height = _background.height;
							_movieClip.scaleX = _movieClip.scaleY;
						}							
						else {
							_movieClip.width = _background.width;
							_movieClip.scaleY = _movieClip.scaleX;
						}
						
						
						if(_movieClip.width < _background.width){
							_movieClip.width = _background.width;
							_movieClip.scaleY = _movieClip.scaleX;
						}
						if(_movieClip.height < _background.height){
							_movieClip.height = _background.height;
							_movieClip.scaleX = _movieClip.scaleY;
						}
					break;
				}
				
				_movieClip.x = (_background.width - _movieClip.width)/2;
				_movieClip.y = (_background.height - _movieClip.height)/2;
			}
			
		}
		public function get showBackground():Boolean { return _background.visible; }
		public function set showBackground(value:Boolean):void {
			_background.visible = value;
		}
		public override function set width(value:Number):void {
			_width = value;
			updateElements();
		}
		public override function set height(value:Number):void {
			_height = value;
			updateElements();
		}
		public function get movieClip():DisplayObject { return _movieClip;}
		public function set movieClip(value:DisplayObject):void {
							
			if(_movieClip){
				this.removeChild(_movieClip);
			}
			
			_movieClip = value;
			if(_movieClip != null){
				this.addChild(_movieClip);
				_scale = 1;
				updateElements();
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
		public function get scale():Number { return _scale; }
		public function set scale(value:Number):void {
			_scale = Mathf.Clamp(value, 0, 1);
			updateElements();
		}
	}
}