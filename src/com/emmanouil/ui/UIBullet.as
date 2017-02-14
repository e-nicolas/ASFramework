package com.emmanouil.ui {
	import flash.display.Sprite;
	
	public class UIBullet extends Sprite {
		
		public function UIBullet(size:Number, color:uint) {
			// constructor code			
			this.graphics.beginFill(color);
			this.graphics.drawCircle(0,0, size);
			this.graphics.endFill();			
		}
	}
	
}
