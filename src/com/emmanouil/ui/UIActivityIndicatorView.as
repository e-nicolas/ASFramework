package com.emmanouil.ui {
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import com.emmanouil.utils.ChangeColor;
	import com.emmanouil.assets.Embed;
	
	public class UIActivityIndicatorView extends Sprite {

		private var angle:Number = 0;
		private const fps:int = 12;
		private const velocity:Number = 0.6;
		
		private var _size:Number;
		
		private var indicator:Bitmap;
		private var indicatorContent:Sprite;
		
		public function UIActivityIndicatorView(size:Number) {
			_size = size;
			indicatorContent = new Sprite();
			this.addChild(indicatorContent);
			
			indicator = (new Assets.UIActivityIndicatorViewPNG() as Bitmap);
			indicatorContent.addChild(indicator);			
			
			updateElements();			
			animate();		
		}
		private function updateElements():void {
			indicator.width = _size;
			indicator.scaleY = indicator.scaleX;
			indicator.x = -indicator.width/2;
			indicator.y = -indicator.height/2;
			indicatorContent.x = indicator.width/2;
			indicatorContent.y = indicator.height/2;
		}
		private function animate():void {
			angle += 360/fps;
			TweenMax.to(indicatorContent, 0, {rotationZ: angle,ease:Linear.ease, onComplete: onComplete});
		}
		private function onComplete():void {
			TweenMax.to(indicatorContent, (1/fps) * velocity, {rotationZ: angle, onComplete: animate});
		}
		public function play():void {
			animate();
		}
		public function stop():void {
			angle = 0;
			TweenLite.killTweensOf(indicatorContent);
		}		
		public function set color(value:uint):void {
			ChangeColor.Change(value, indicator);
		}
		
		

	}
	
}
