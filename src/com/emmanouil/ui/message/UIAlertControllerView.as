package com.emmanouil.ui.message {
	
	import flash.display.Sprite;
	import flash.display.Shape;	
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;	
	import com.emmanouil.core.Capabilities;
	
	public class UIAlertControllerView extends Sprite {

		private var background:Shape;
		private var alert:UIAlertView;
		
		public function UIAlertControllerView() {
			// constructor code
			
			background = new Shape;
			this.addChild(background);
			
			alert = new UIAlertView(Capabilities.GetWidth() * 0.85, Capabilities.GetHeight() * 0.35);
			alert.visible = false;
			alert.onDismiss = onDismiss;
			this.addChild(alert);
			
		}
		private function onDismiss():void {
			background.visible = false;
			background.alpha = 0;
		}
		public function show():void {
			background.visible = true;
			TweenLite.to(background, 0.4, {alpha: 1, ease: Expo.easeOut});
			
			alert.show();
			alert.x = (Capabilities.GetWidth() - alert.width)/2;
			alert.y = (Capabilities.GetHeight() - alert.height)/2;
			
			background.graphics.clear();
			background.graphics.beginFill(0, 0.45);
			background.graphics.drawRect(0, 0, Capabilities.GetWidth(),  alert.y);//header
			background.graphics.drawRect(0, alert.y, alert.x,  alert.height);//esquerda
			background.graphics.drawRect(alert.x + alert.width, alert.y, Capabilities.GetWidth() - (alert.x + alert.width),  alert.height);//direita
			background.graphics.drawRect(0, alert.y + alert.height, Capabilities.GetWidth(),  Capabilities.GetHeight() - (alert.y + alert.height));//baixo
			background.graphics.endFill();
			
		}
		public function get title():String { return alert.title; }
		public function set title(value:String):void {
			alert.title = value;
		}
		public function get message():String { return alert.message; }
		public function set message(value:String):void {
			alert.message = value;
		}
		//buttons
		public function get button1Text():String { return alert.button1Text; }
		public function set button1Text(value:String):void {
			alert.button1Text = value;
		}
		public function get button2Text():String { return alert.button2Text; }
		public function set button2Text(value:String):void {
			alert.button2Text = value;
		}
		//callbacks
		public function get funcao1():Function { return alert.funcao1; }
		public function set funcao1(value:Function):void {
			alert.funcao1 = value;
		}
		public function get funcao2():Function { return alert.funcao2; }
		public function set funcao2(value:Function):void {
			alert.funcao2 = value;
		}
		
		public function get textInputText():String { return alert.inputTextText; }
		
		public function get alertType():String { return alert.alertType; }
		public function set alertType(value:String):void {
			alert.alertType = value;
		}

	}
	
}
