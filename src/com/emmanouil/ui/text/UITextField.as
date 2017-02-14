package com.emmanouil.ui.text {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.emmanouil.utils.ChangeColor;
	
	public class UITextField extends Sprite{

		//Input
		private var inputText:StageText;
		private var stageTextInitOptions
		private var editor:InputTextOptions;
		private var inputX:Number;
		private var inputY:Number;
		private var inputWidth:Number;
		private var inputHeight:Number;
		private var parentPosition:Point
		private var textImage:Bitmap;
		
		//placeholder
		private var placeHolder:TextField;
		
		private var graphQuad:Shape;
		private var graphLine:Shape;		
		private var graphAlpha:Number;
		private var graphLineAlpha:Number;
		
		private var _type:String;
		private var _width:Number = 400;
		private var _height:Number = 100;
		private var _backgroundColor:uint = 0xFFFFFF;
		private var _borderColor:uint = 0xCCCCCC;
		private var _focusColor:uint = 0xfafafa;
		private var _round:Number = 10;
		
		public var icone:MovieClip;
		
		public function UITextField(options:InputTextOptions, icon = null){
			// constructor code
			editor = options;
			
			_type = editor.inputTextType;
			
			graphQuad = new Shape();
			this.addChild(graphQuad);
			
			graphLine = new Shape();
			this.addChild(graphLine);
			
			if(icon){
				icone = icon;
				this.addChild(icone);
			}
			
			placeHolder = new TextField();
			placeHolder.mouseEnabled = false;
			placeHolder.alpha = 0.5;
			this.addChild(placeHolder);
			
			stageTextInitOptions = new StageTextInitOptions(editor.multiline);
			inputText = new StageText(stageTextInitOptions);
			inputText.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			inputText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			inputText.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			inputText.addEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
			inputText.addEventListener(Event.CHANGE, onChangeStatus);
			this.addEventListener(MouseEvent.CLICK, onFocusInClick);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}		
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
			
			inputText.stage = this.stage;
			inputText.visible = false;
			
			updateElements();			
			pauseStageText();
		}
		private function updateElements():void {
			
			//Determina alpha de acordo com o estilo
			if(_type == InputTextType.QUAD){
				graphAlpha = 1;
				graphLineAlpha = 1;
			}						
			if(_type == InputTextType.NONE || _type == InputTextType.LINE){
				graphAlpha = 0;
				graphLineAlpha = 0;
			}
			
			graphQuad.graphics.clear();
			graphQuad.graphics.beginFill(_backgroundColor, graphAlpha);
			if(_borderColor)
				graphQuad.graphics.lineStyle(1, _borderColor, graphLineAlpha);
			graphQuad.graphics.drawRoundRect(0,0, _width, _height, _round);
			graphQuad.graphics.endFill();			
			
			if(_type == InputTextType.LINE){
				graphLine.graphics.clear();
				graphLine.graphics.beginFill(_backgroundColor);
				graphLine.graphics.drawRect(0,0, _width, _height * 0.05);
				graphLine.graphics.endFill();
				graphLine.y = graphQuad.y + graphQuad.height - graphLine.height*3;				
			}
			
			if(icone){
				icone.height = _height * 0.45;
				icone.scaleX = icone.scaleY;
				icone.x = _width * 0.05;
				icone.y = (_height - icone.height)/2;				
			}
						
			updateStageText();
			updatePlaceHolder();
			
		}		
		public function  updatePlaceHolder():void {
			const textFormat:TextFormat = new TextFormat("Times New Roman", inputText.fontSize, editor.color);			
			textFormat.align = editor.textAlign;					
			
			placeHolder.setTextFormat(textFormat);
			
			if(icone){
				placeHolder.x = Math.round(icone.x + icone.width + _width * 0.02);
			}				
			else{
				if(_type == InputTextType.QUAD)
					placeHolder.x = Math.round(_width * 0.02);
				else
					placeHolder.x = Math.round(_width * 0.0);
			}				
			
			placeHolder.y = inputY - parentPosition.y;
			
			placeHolder.width = _width - placeHolder.x;
			placeHolder.height = _height * 0.5;			
			
		}
		public function  updateStageText():void {
			
			inputText.autoCapitalize = editor.autoCapitalize;
			inputText.autoCorrect = editor.autoCorrect;
			inputText.color = editor.color;
			inputText.displayAsPassword = editor.displayAsPassword;
			inputText.fontFamily = editor.fontFamily;
			inputText.fontPosture = editor.fontPosture;
			inputText.fontWeight = editor.fontWeight;
			inputText.restrict = editor.restrict;
			inputText.returnKeyLabel = editor.returnKeyLabel;
			inputText.softKeyboardType = editor.softKeyboardType;
			inputText.textAlign = editor.textAlign;
			inputText.maxChars = editor.maxChars;
			
			parentPosition = new Point(this.x, this.y);
			if(this.parent && stage){
				parentPosition = stage.localToGlobal(new Point(this.getBounds(stage).x, this.getBounds(stage).y));
			}			
			if(icone){
				inputX = Math.round(parentPosition.x + icone.x + icone.width + _width * 0.02);
			}				
			else{
				if(_type == InputTextType.QUAD)
					inputX = Math.round(parentPosition.x + _width * 0.02);
				else
					inputX = Math.round(parentPosition.x + _width * 0.0);
			}				
		
			if(editor.multiline == false){
				inputText.fontSize = _height * 0.35;
				inputY = Math.round(parentPosition.y + (_height - inputText.fontSize)/2);
			}
			else{
				inputText.fontSize = _height * 0.17;
				
				inputY = Math.round(parentPosition.y + _height * 0.04);
			}
			
			inputWidth = Math.round(_width - (inputX - parentPosition.x) - _width * 0.04);
			inputHeight = Math.round(_height - (inputY- parentPosition.y));
			
			inputText.viewPort = new Rectangle(inputX, inputY, inputWidth, inputHeight);
			
		}
		private function onFocusInClick(e:Event):void {			
			resumeStageText();
		}
		private function onFocusIn(e:FocusEvent):void {
			this.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN, e.bubbles, e.cancelable, e.relatedObject, e.shiftKey, e.keyCode, e.direction));
		}		
		private function onFocusOut(e:FocusEvent):void {			
			this.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT, e.bubbles, e.cancelable, e.relatedObject, e.shiftKey, e.keyCode, e.direction));
			pauseStageText();
		}
		private function resumeStageText():void {
			removeImageText();			
			
			checkPlaceHolder();
			
			inputText.visible = true;
			inputText.assignFocus();
			graphLine.height = _height * 0.05;
			ChangeColor.Change(focusColor, graphLine);
			
			updateStageText();
			
		}
		private function pauseStageText():void {			
			drawStageTextToBitmap();
			
			checkPlaceHolder();
			
			inputText.visible = false;
			
			graphLine.height = _height * 0.02;
			ChangeColor.Change(backgroundColor, graphLine);
		}
		private function drawStageTextToBitmap():void {
			removeImageText();
			
			const drawableSprite:Sprite = new Sprite();
			
			const bmd:BitmapData = new BitmapData(inputText.viewPort.width, inputText.viewPort.height, true, 0x00ff00ff);
			inputText.drawViewPortToBitmapData(bmd);			
			bmd.draw(drawableSprite);
			
			textImage = new Bitmap(bmd);
			textImage.x = inputText.viewPort.x - parentPosition.x;
			textImage.y = inputText.viewPort.y - parentPosition.y;
			
			this.addChild(textImage);
		}
		private function removeImageText():void {
			if(textImage){
				if(this.contains(textImage))
					this.removeChild(textImage);	
			}	
			textImage = null;
			
			
			
		}
		private function checkPlaceHolder():void {
			if(inputText.text.length > 0)
				placeHolder.visible = false;
			else
				placeHolder.visible = true;
		}
		private function onChangeStatus(e:Event):void{
			checkPlaceHolder();
		}
		private function onKeyboardDown(e:KeyboardEvent):void{
			
			this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, e.bubbles, e.cancelable, e.charCode, e.keyCode, e.keyLocation, e.ctrlKey, e.altKey, e.shiftKey));
		}
		private function onKeyboardUp(e:KeyboardEvent):void{
			if(e.keyCode == 13){
				if(!editor.multiline)
					pauseStageText();
			}
			this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, e.bubbles, e.cancelable, e.charCode, e.keyCode, e.keyLocation, e.ctrlKey, e.altKey, e.shiftKey));
		}		
		public function get type():String {return _type;}
		public function get text():String {return inputText.text;}
		public function set text(value:String):void {inputText.text = value;}
		
		public function get backgroundColor():uint {return _backgroundColor;}
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			updateElements();
		}
		public function get borderColor():uint {return _borderColor;}
		public function set borderColor(value:uint):void {
			_borderColor = value;
			updateElements();
		}
		public function get focusColor():uint {return _focusColor;}
		public function set focusColor(value:uint):void {
			_focusColor = value;
		}
		public function get placeholder():String {return placeHolder.text;}
		public function set placeholder(value:String):void {
			placeHolder.text = value;
			
		}
		public function get round():Number {return _round;}
		public function set round(value:Number):void {
			_round = value;
			updateElements();
		}		
		public override function set x(value:Number):void {
			super.x = value;
			updateElements();
		}
		public override function set y(value:Number):void {
			super.y = value;
			updateElements();
		}
		public override function set width(value:Number):void {
			_width = value;
			updateElements();
		}
		public override function get height():Number {return _height}
		public override function set height(value:Number):void {
			_height = value;
			updateElements();
		}
		
		public function assignFocus():void {
			resumeStageText();
		}
		public function clear():void {
			if(inputText)
				inputText.text  = "";
			
			removeImageText();
			checkPlaceHolder();
			
		}
		public override function set visible(value:Boolean):void {
			super.visible = value;
			inputText.visible = value;
		}

	}
	
}
