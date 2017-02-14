package  com.emmanouil.ui {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.emmanouil.utils.ChangeColor;
	import flash.display.DisplayObject;
	import flash.text.TextFieldAutoSize;
	import com.greensock.TweenLite;
	
	public class UIButton extends Sprite{

		private var line:Shape;
		private var bg:Shape;
		private var textField:TextField;
		private var textFormat:TextFormat;
		
		private var _backgroundColor:uint;
		private var _disabledColor:uint = 0xCCCCCC;
		private var _backgroundAlpha:Number = 1;
		
		private var _width:Number;
		private var _height:Number;		
		private var _estimatedHeight:Number;		
		private var _round:Number;
		
		private var _label:String;
		private var _labelFont:String;
		private var _labelSize:Number;	
		private var _labelColor:uint;
		
		private var _borderColor:uint;
		
		private var _enabled:Boolean;
		
		private var _imageContainer:UIMovieClipView;
		private var _image:DisplayObject;
		
		private var _align:String = "center";
		
		public function UIButton(width:Number, height:Number, round:Number) {
			// constructor code
			
			_width = width;
			_height = height;
			_round = round;
			_estimatedHeight = _height;
			
			_label = "Button";
			_labelFont = "Times New Roman";
			_labelSize = _estimatedHeight * 0.35;
			_labelColor = 0x007aff;
			
			line = new Shape();
			this.addChild(line);
			
			bg = new Shape();			
			this.addChild(bg);
			
			textFormat = new TextFormat(_labelFont, _labelSize, _labelColor);
			textFormat.align = _align;
			textField = new TextField();
			textField.text = _label;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.setTextFormat(textFormat);
			textField.defaultTextFormat = textFormat;
			textField.mouseEnabled = false;
			this.addChild(textField);
			
			_imageContainer = new UIMovieClipView(_width * 0.4, _height);
			_imageContainer.mouseChildren = false;
			_imageContainer.mouseEnabled = false;
			_imageContainer.showBackground = false;
			this.addChild(_imageContainer);
			
			updateElements();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			this.addEventListener(MouseEvent.MOUSE_UP, onRelease);
			this.addEventListener(MouseEvent.RELEASE_OUTSIDE, onRelease);
		}
		private function updateElements():void {
			
			line.graphics.clear();			
			if(_borderColor){
				line.graphics.beginFill(_borderColor);
				line.graphics.drawRoundRect(0, 0, _width, _height, _round);
				line.graphics.drawRoundRect(1, 1, _width-2, _height-2, _round);
				line.graphics.endFill();
			}
			
			bg.graphics.clear();			
			bg.graphics.beginFill(0);			
			bg.graphics.drawRoundRect(0, 0, _width-2, _height-2, _round);			
			bg.graphics.endFill();
			bg.x = (_width - bg.width)/2;
			bg.y = (_height - bg.height)/2;
			bg.alpha = 0;
			
			if(_backgroundColor){
				ChangeColor.Change(_backgroundColor, bg);
				bg.alpha = 1;
			}			
			
			_imageContainer.width = _width * 0.1;
			_imageContainer.height = _height;
			
			updateTextField();
		}
		private function onClick(e:MouseEvent):void {
			if(textField){				
				TweenLite.killTweensOf(textField, false, {alpha: true});
				textField.alpha = 0.4;
			}
			if(_imageContainer){
				TweenLite.killTweensOf(_imageContainer, false, {alpha: true});
				_imageContainer.alpha = 0.4;
			}
			if(_backgroundColor){
				TweenLite.killTweensOf(bg, false, {alpha: true});
				bg.alpha = 0.8;
			}
		}
		private function onRelease(e:MouseEvent):void {
			if(textField){				
				TweenLite.to(textField, 0.3, {alpha: 1});
			}
			if(_imageContainer){				
				TweenLite.to(_imageContainer, 0.3, {alpha: 1});
			}
			if(_backgroundColor){				
				TweenLite.to(bg, 0.3, {alpha: 1});
			}
		}
		private function updateTextField():void {
			if(textField){
				textFormat = new TextFormat(_labelFont, _labelSize, _labelColor);
				textField.text = _label;
				textField.setTextFormat(textFormat);
				textField.y = (_height - textField.height)/2;								
				
				if(_image){
					if(_align == "center"){
						textField.x = ((_width + _imageContainer.width) - textField.width)/2;
					}
					else if(_align == "left"){
						textField.x = 0 + _imageContainer.width;
					}
					_imageContainer.x = textField.x - _imageContainer.width;													
				}
				else{
					if(_align == "center"){
						textField.x = (_width - textField.width)/2;
					}
					else if(_align == "left"){
						textField.x = 0;
					}
				}
				
				//se o texto estourar o limite do width reajusta o layout
				if(textField.x + textField.width > _width){
					_width = textField.x + textField.width;
					updateElements();
				}
			}
		}
		//Label
		public function get label():String {return _label}
		public function set label(value:String):void {
			_label = value;
			
			updateTextField();
			
		}
		//
		public function get labelPosition():Number {return textField.x}
		//
		public function get labelSize():Number {return _labelSize}
		public function set labelSize(value:Number):void {
			_labelSize = value;			
			updateTextField();
		}
		//
		public function get labelFont():String {return _labelFont}
		public function set labelFont(value:String):void {
			_labelFont = value;
			updateTextField();
		}
		//
		public function get labelColor():uint {return _labelColor}
		public function set labelColor(value:uint):void {
			_labelColor = value;
			updateTextField();
		}
		public function get disabledColor():uint {return _disabledColor}
		public function set disabledColor(value:uint):void {
			_disabledColor = value;
		}
		//
		public function get backgroundColor():uint {return _backgroundColor}
		public function set backgroundColor(value:uint):void {			
			_backgroundColor = value;
			updateElements();
		}
		public function get backgroundAlpha():uint {return _backgroundAlpha}
		public function set backgroundAlpha(value:uint):void {			
			_backgroundAlpha = value;
			updateElements();
		}
		public function get borderColor():uint {return _borderColor}
		public function set borderColor(value:uint):void {			
			_borderColor = value;
			updateElements();
		}
		public function get enabled():Boolean {return _enabled}
		public function set enabled(value:Boolean):void {
			_enabled = value;
			
			TweenLite.killTweensOf(textField);
			TweenLite.killTweensOf(_imageContainer);
			TweenLite.killTweensOf(bg);
			
			if(_enabled){
				if(textField){		
				textField.alpha = 1;
				}
				if(_imageContainer){
					_imageContainer.alpha = 1;
				}
				if(_backgroundColor){
					bg.alpha = 1;
				}
				this.mouseEnabled = true;
				this.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
				this.addEventListener(MouseEvent.MOUSE_UP, onRelease);
				this.addEventListener(MouseEvent.RELEASE_OUTSIDE, onRelease);
			}
			else{
				if(textField){				
					textField.alpha = 0.4;
				}
				if(_imageContainer){
					_imageContainer.alpha = 0.4;
				}
				if(_backgroundColor){
					bg.alpha = 0.6;
				}
				this.mouseEnabled = false;
				this.removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
				this.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
				this.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onRelease);
			}
			
		}
		public override function set width(value:Number):void {
			_width = value;
			updateElements();
		}
		public override function set height(value:Number):void {
			_height = value;
			updateElements();
		}	
		
		public function get image():DisplayObject { return _image;}
		public function set image(value:DisplayObject):void {
			_image = value;
			
			_imageContainer.movieClip = _image;
			updateTextField();
		}
		public function get imageScale():Number { return _imageContainer.scale;}
		public function set imageScale(value:Number):void {
			_imageContainer.scale = value;
		}
		public function get align():String { return _align; }
		public function set align(value:String):void {
			_align = value;
			updateTextField();
		}

	}
	
}
