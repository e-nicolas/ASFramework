package com.emmanouil.ui.message  {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.emmanouil.ui.UIActivityIndicatorView;
	import com.emmanouil.utils.ChangeColor;
	
	public class UIToastView extends Sprite{
		
		private var _width:Number;
		private var _text:String;
		private var _showActivityIndicator:Boolean;
		
		private var background:Shape;
		private var textField:TextField;		
		private var textFormat:TextFormat;
		private var activityIndicator:UIActivityIndicatorView;
		
		public function UIToastView(width:Number, mensagem:String, showActivityIndicator:Boolean = false) {
			
			this._width = width;
			this._text = mensagem;
			this._showActivityIndicator = showActivityIndicator;
			
			activityIndicator = new UIActivityIndicatorView(_width * 0.08);
			ChangeColor.Brightness(1, activityIndicator);
			
			textFormat = new TextFormat("Times New Roman", null, 0xFFFFFF);
			textField = new TextField();
			textField.wordWrap = true;
			textField.multiline = true;
			textField.mouseEnabled = false;
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);
			textField.autoSize = "center";
			
			background = new Shape();
			
			this.addChild(background);
			this.addChild(textField);
			this.addChild(activityIndicator);
			
			updateElements();
		}
		
		private function updateElements():void {			
			var bgHeight:Number;
			
			textFormat.size = _width * 0.07;
			textFormat.align = "center";
			textField.defaultTextFormat = textFormat;
			textField.width = _width - _width * 0.1;
			textField.text = _text;
			textField.x = (_width - textField.width)/2;
			
			bgHeight = textField.height * 2;
			
			if(_showActivityIndicator){
				activityIndicator.visible = true;
				activityIndicator.play();
				
				textField.y = activityIndicator.height/2;
				
				activityIndicator.x = _width/2;
				activityIndicator.y = textField.y + textField.height + activityIndicator.height/2;
				
				bgHeight = activityIndicator.y + activityIndicator.height;
			}
			else{
				
				textField.y = textField.height/2;
				activityIndicator.visible = false;
				activityIndicator.stop();				
			}			
			
			background.graphics.clear();
			background.graphics.beginFill(0x333333, 0.85);
			background.graphics.drawRoundRect(0, 0, _width, bgHeight, 25);
			background.graphics.endFill();			
		}
		public function stop():void {
			activityIndicator.stop();
		}
		public function get mensagem():String { return _text;}
		public function set mensagem(value:String):void {
			this._text = value;
			updateElements();
		}
		public function set showActivityIndicator(value:Boolean):void {
			_showActivityIndicator = value;
			updateElements();
		}
		
	}//end Class
}//end Package
