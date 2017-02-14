package com.emmanouil.ui.message {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;	
	
	import com.emmanouil.core.Capabilities;
	import com.emmanouil.utils.Text;
	import com.emmanouil.ui.UIButton;
	import com.emmanouil.ui.text.UITextField;
	import com.emmanouil.ui.text.InputTextOptions;
	import com.emmanouil.ui.text.InputTextType;
	
	public class UIAlertView extends Sprite{
		
		private var _width:Number;
		private var _height:Number;
		
		private var _title:String = "";
		private var _message:String = "";
		private var _button1Text:String = "OK";
		private var _button2Text:String;
		
		private var _alertType:String;
		
		private var bgBlock:Shape;
		private var bg:Shape;
		
		private var tituloField:TextField;
		private var mensagemField:TextField;
		
		private var inputText:UITextField;
		
		private var button1:UIButton;
		private var button2:UIButton;
		
		//callbakcs
		public var funcao1:Function;
		public var funcao2:Function;
		
		public var onDismiss:Function;
		
		public function UIAlertView(width:Number, height:Number) {
			// constructor code			
					
			_width = width;
			_height = height;
			
			bg = new Shape();
			var shadow:GlowFilter = new GlowFilter(0x000000, 0.7, 15, 15, 1, 3);
			bg.filters = [shadow];
			this.addChild(bg);
			
			tituloField = new TextField();
			tituloField.autoSize = "left";					
			tituloField.multiline = true;
			tituloField.wordWrap = true;			
			tituloField.mouseEnabled = false;
			this.addChild(tituloField);
			
			mensagemField = new TextField();		
			mensagemField.autoSize = "left";	
			mensagemField.multiline = true;
			mensagemField.wordWrap = true;					
			mensagemField.mouseEnabled = false;
			this.addChild(mensagemField);
			
			const options:InputTextOptions = new InputTextOptions(InputTextType.QUAD, false);
			options.color = 0xffffff;
			options.textAlign = "left";
			options.fontFamily = "Times New Roman";
			
			inputText = new UITextField(options);
			inputText.backgroundColor = 0x282828;
			inputText.borderColor = 0xffffff;
			inputText.round = 0;
			inputText.width = _width * 0.8;
			inputText.height = _height * 0.17;
			inputText.x = (_width - inputText.width)/2;
			this.addChild(inputText);
			
			button1 = new UIButton(bg.width, _height * 0.25, 0);			
			button1.backgroundColor = 0x282828;
			button1.labelColor = 0xCCCCCC;						
			button1.addEventListener(MouseEvent.CLICK, handlerClick);
			this.addChild(button1);
						
			button2 = new UIButton(bg.width, _height * 0.25, 0);	
			button2.backgroundColor = 0x282828;
			button2.labelColor = 0xCCCCCC;							
			button2.addEventListener(MouseEvent.CLICK, handlerClick);
			button2.visible = false;
			this.addChild(button2);
			
			alertType = UIAlertType.DEFAULT;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		private function onAddedToStage(e:Event):void {
			updateElements();
		}
		private function updateElements():void {
			
			bg.graphics.clear();
			bg.graphics.beginFill(0x333333, 0.99);
			bg.graphics.drawRoundRect(0, 0, _width, _height, 0);
			bg.graphics.endFill();
			
			var textFormat:TextFormat = new TextFormat("Times New Roman", _height * 0.1, 0xFFFFFF);
			textFormat.align = "center";
			tituloField.width = bg.width  * 0.75;
			tituloField.text = _title;
			tituloField.setTextFormat(textFormat);
			tituloField.x = bg.x + (bg.width - tituloField.width)/2;
			tituloField.y = bg.y + Capabilities.GetWidth() * 0.025;
			
			textFormat = new TextFormat("Times New Roman", _height * 0.09, 0xFFFFFF);
			textFormat.align = "center";
			mensagemField.width = bg.width  * 0.75;	
			mensagemField.text = _message;
			mensagemField.setTextFormat(textFormat);
			mensagemField.x = bg.x + (bg.width - mensagemField.width)/2;
			mensagemField.y = tituloField.y + tituloField.height + Capabilities.GetWidth() * 0.05;
			
			if(_alertType == UIAlertType.INPUT){
				inputText.clear();
				inputText.visible = true;
				inputText.y = mensagemField.y + mensagemField.height + Capabilities.GetWidth() * 0.05;
				bg.height = inputText.y + inputText.height + Capabilities.GetWidth() * 0.075 + _height * 0.25;
			}
			else{
				inputText.visible = false;
				bg.height = mensagemField.y + mensagemField.height + Capabilities.GetWidth() * 0.075 + _height * 0.25;
			}
			
			
			button1.label = _button1Text;
			button1.width = bg.width;
			button1.x = bg.x + (bg.width - button1.width)/2;
			button1.y = bg.y + bg.height - button1.height;
			button2.visible = false;
			if(button2Text){
				button1.x = bg.x;
				button1.width = bg.width * 0.5;
				
				button2.label = _button2Text;
				button2.width = bg.width * 0.5;
				button2.x = button1.x + button1.width;
				button2.y = bg.y + (bg.height - button2.height);
				
				button2.visible = true;
			}
			
		}
		public function show():void {
			updateElements();
			this.visible = true;
			
			TweenLite.to(this, 0.4, {alpha: 1, ease: Expo.easeOut});
		}
		public function hide():void {
			this.visible = false;
			this.alpha = 0;
		}
		private function handlerClick(e:MouseEvent):void {
			if(_alertType == UIAlertType.INPUT && inputText.text == ""){
				return;
			}
			
			hide();
		
			if(onDismiss != null)
				onDismiss();
			
			if(e.target == button1){
				if(funcao1 != null)
				funcao1();
			}
			else if(e.target == button2){
				if(funcao2 != null)
					funcao2();
			}	
			
					
		}
		
		public override function set width(value:Number):void {
			_width = value;
		}
		public override function set height(value:Number):void {
			_height = value;
		}
		
		public function get title():String { return _title; }
		public function set title(value:String):void {
			_title = value;
			_title = Text.limitText(_title, 25);
		}
		public function get message():String { return _message; }
		public function set message(value:String):void {
			_message = value;
			_message = Text.limitText(_message, 80);
		}
		//buttons
		public function get button1Text():String { return _button1Text; }
		public function set button1Text(value:String):void {
			_button1Text = value;
		}
		public function get button2Text():String { return _button2Text; }
		public function set button2Text(value:String):void {
			_button2Text = value;
		}
		
		public function get alertType():String { return _alertType; }
		public function set alertType(value:String):void {
			_alertType = value;
		}
		
		public function get inputTextText():String { return inputText.text; }

	}//end class
	
}//end package
