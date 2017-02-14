package com.emmanouil.ui {
	
	/*
	 * author Emmanouil Nicolas Papadimitropoulos
	 * UISubView v0.0
	 */
	
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.geom.Matrix;	
	
	import com.emmanouil.managers.SubViewController;
	import com.emmanouil.utils.AnglesUtils;
	import com.emmanouil.core.Capabilities;
	
	public class UISubView extends UIView {		
		
		public var navigationBar:UINavigationBar;
		public var shadow:Shape;
		public var subViewController:SubViewController;
		
		public function UISubView() {
			// constructor code
			super();
			
			const matrix:Matrix = new Matrix();
			matrix.createGradientBox(Capabilities.GetWidth() * 0.3, Capabilities.GetHeight(), AnglesUtils.ToRad(0));
			shadow = new Shape();
			shadow.graphics.beginGradientFill(GradientType.LINEAR, [0, 0], [0, 1], [0,255], matrix);
			shadow.graphics.drawRect(0, 0, Capabilities.GetWidth() * 0.025, Capabilities.GetHeight());
			shadow.graphics.endFill();
			shadow.x = -shadow.width;
			this.addChild(shadow);
			
		}
		public function ReadyToBuildView():void {}
		public function willMoveToParentViewController(parent: UIView):void {}
		
		public override function get width():Number {
			return this.width - shadow.width;
		}
	}
	
}
