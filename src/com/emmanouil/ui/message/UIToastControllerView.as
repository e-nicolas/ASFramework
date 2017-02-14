package com.emmanouil.ui.message
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import com.emmanouil.ui.types.ToastScreenAnimation;
	import com.emmanouil.core.Capabilities;
	
	public class UIToastControllerView extends Sprite
	{
		private var toast:UIToastView;
		
		private var _mensagem:String;
		private var _showSpinner:Boolean;
		
		private var currentAnimationType:String;
		
		public function UIToastControllerView()
		{			
			toast = new UIToastView(Capabilities.GetWidth() * 0.6, "", false);
			toast.x = -toast.width;
			toast.y = -toast.height;
			this.addChild(toast);
		}
		private function updateElements():void {
			toast.x = (Capabilities.GetWidth() - toast.width)/2;
			toast.y = (Capabilities.GetHeight() - toast.height)/2;
		}
		public function showWithTimer(animationTo:String, durationToHide:Number):void {			
			toast.visible = true;
			
			currentAnimationType = animationTo;
			
			//ponto de partida
			var origin:Point;
			//para onde vai
			var to:Point;
			
			switch(currentAnimationType) {
				
				case ToastScreenAnimation.MID_CENTER:
					origin = new Point(center.x, originBottom);					
					to = new Point(origin.x, center.y);
					break;
				case ToastScreenAnimation.TOP_CENTER:
					origin = new Point(center.x, originTop);					
					to = new Point(origin.x, top);
					break;
				case ToastScreenAnimation.BOTTOM_CENTER:
					origin = new Point(center.x, originBottom);					
					to = new Point(origin.x, bottom);
					break;
				case ToastScreenAnimation.MID_LEFT:
					origin = new Point(originLeft, center.y);					
					to = new Point(left, origin.y);
					break;
				case ToastScreenAnimation.MID_RIGHT:
					origin = new Point(originRight, center.y);					
					to = new Point(right, origin.y);
					break;
			}
			
			showWithTimerWhere(origin, to, durationToHide)
		}
		public function showWithTimerWhere(origin:Point, to:Point, durationToHide:Number):void {
			toast.x = origin.x;
			toast.y = origin.y;
			
			TweenLite.to(toast, 0.6, {x: to.x, y: to.y, ease: Back.easeOut, onComplete: onCompleteToastAnimation, onCompleteParams: [durationToHide, origin]});
		}
		private function onCompleteToastAnimation(delay:Number, origin:Point):void {
			if(delay == -1){
				return
			}
			hide(origin, 0.4, delay);
		}
		public function hide(to:Point, durationTime:Number = 0.4, delay:Number = 0):void {
			TweenLite.to(toast, durationTime, {delay: delay, x: to.x, y: to.y, ease: Back.easeIn, onComplete: onHideComplete});			
		}		
		public function onHideComplete():void {
			toast.visible = false;
		}
		public function set mensagem(value:String):void {
			toast.mensagem = value;
			updateElements();
		}
		public function set showActivityIndicator(value:Boolean):void {
			toast.showActivityIndicator = value;
			updateElements();
		}
		
		//positions
		//to go
		public function get center():Point { 
			const point:Point = new Point((Capabilities.GetWidth()- toast.width)/2, (Capabilities.GetHeight() - toast.height)/2);
			return point;
		}		
		public function get top():Number {
			return toast.height * 0.3;
		}
		public function get bottom():Number {
			return Capabilities.GetHeight() - toast.height * 1.3;
		}
		public function get left():Number { 
			return toast.width * 0.05;
		}
		public function get right():Number {
			return Capabilities.GetWidth() - toast.width * 1.005;
		}
		//origin
		public function get originTop():Number { 
			return -toast.height;
		}
		public function get originBottom():Number {
			return Capabilities.GetHeight();
		}
		public function get originLeft():Number { 
			return -toast.width;
		}
		public function get originRight():Number {
			return Capabilities.GetWidth();
		}
	}
}