package com.emmanouil.ui {
	
	/*
	 * author Emmanouil Nicolas Papadimitropoulos
	 * UISwitch based on Apple iOS SDK (Swift 2.0)
	 */
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;	

	import flash.filters.DropShadowFilter;

	TweenPlugin.activate([TintPlugin]);
	
	public class UISwitcher extends Sprite{

		private var _width:Number;
		private var _height:Number;
		private var _round:Number;
		private var _enabledColor:uint = 0x2ECC71;
		private var _disabledColor:uint = 0xCCCCCC;			
		
		private var bg:Shape;
		private var ball:Shape;
		private var diffBall:Number = 2;
		
		private var textFormat:TextFormat;
		private var textField:TextField;
		
		public var isActive:Boolean = true;
		
		public function UISwitcher(width:Number, isRound:Boolean = false) {
			// constructor code
			
			_width = width;
			_height = Math.round(_width/1.777777);
			
			_round = isRound ? _height : _height * 0.1;
			
			bg = new Shape();
			bg.graphics.beginFill(_enabledColor);
			bg.graphics.drawRoundRect(0, 0, _width, _height, _round);
			bg.graphics.endFill();
			this.addChild(bg);
			
			ball = new Shape();
			ball.graphics.beginFill(0xFFFFFF);
			ball.graphics.drawRoundRect(0, 0, _height - diffBall * 2, _height - diffBall * 2, _round);
			ball.graphics.endFill();
			ball.x = (bg.x + bg.width) - ball.width - diffBall;
			ball.y = bg.y + (bg.height - ball.height)/2;
			ball.filters = [new DropShadowFilter(5, 180, 0x000000, 0.3, 5, 5, 1.0, 3),new DropShadowFilter(5, 0, 0x000000, 0.3, 5, 5, 1.0, 3)];
			ball.cacheAsBitmap = true;
			
			textFormat = new TextFormat("Times New Roman", _height * 0.3, 0xFFFFFF);
			textField = new TextField();
			textField.text = "ON";
			textField.autoSize = "left"			
			textField.setTextFormat(textFormat);
			textField.defaultTextFormat = textFormat;
			textField.x = ((bg.x + ball.x) - textField.width) /2;
			textField.y = bg.y + (bg.height - textField.height)/2;
			textField.mouseEnabled = false;			
			
			this.addChild(textField);
			this.addChild(ball);			
			
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		private function onClick(e:MouseEvent):void {
			toggleActive();
		}
		private function toggleActive():void {
			if(isActive)
				off();
			else
				on();			
		}
		private function off():void {
			isActive = false;			
			TweenLite.to(bg, 0.2, {tint: _disabledColor});
			TweenLite.to(ball, 0.2, {x: bg.x + diffBall, onComplete:function(){
				textField.text = "OFF";
				textField.x = ((ball.x + ball.width) + (bg.x + bg.width) - textField.width)/2;
			}});			
		}
		private function on():void {
			isActive = true;
			
			TweenLite.to(bg, 0.2, {tint: _enabledColor});
			TweenLite.to(ball, 0.2, {x: (bg.x + bg.width) - ball.width - diffBall, onComplete: function(){
				textField.text = "ON";
				textField.x = ((bg.x + ball.x) - textField.width) /2;
			}});
		}
		
		public function get enabledColor():uint {return _enabledColor; }
		public function set enabledColor(value:uint):void {
			_enabledColor = value;
		}
		public function get disabledColor():uint {return _disabledColor; }
		public function set disabledColor(value:uint):void {
			_disabledColor = value;
		}
		public function get showLabels():Boolean { return textField.visible; }
		public function set showLabels(value:Boolean):void {
			textField.visible = value;
		}

	}
	
}
