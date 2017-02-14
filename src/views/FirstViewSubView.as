package views {
	
	import com.emmanouil.ui.UISubView;
	import com.emmanouil.ui.UIButton;
	import com.emmanouil.ui.UIView;
	
	import flash.events.MouseEvent;	
	
	public class FirstViewSubView extends UISubView{
		
		private var _width:Number;
		private var _height:Number;		
		
		public function FirstViewSubView(width:Number, height:Number) {
			
			_width = width;
			_height = height;
			
			// constructor code
			this.graphics.beginFill(0xf0f0f0);
			this.graphics.drawRect(0,0,_width, _height);
			this.graphics.endFill();
		}
		
		public override function ReadyToBuildView():void {
			var myButton:UIButton = new UIButton(_width * 0.2, 100, 0);
			myButton.label = "Click me!";
			myButton.x = (_width - myButton.width)/2;
			myButton.y = (navigationBar.y + navigationBar.height) + 100;
			this.addChild(myButton);
			myButton.addEventListener(MouseEvent.CLICK, onClickButton);
		}			
		public function onClickButton(e:MouseEvent):void {
			this.performSegueWithIdentifier("gotosecond");			
		}		
		public override function prepareForSegue(segueIdentifier:String, destination:UIView):void {
			trace("Performing segue: " + segueIdentifier);
		}
		public override function StartAwake():void {}		
		public override function Start():void {}
		public override function Resume():void {}
		public override function Pause():void {}
		public override function StopAwake():void {}
		public override function Stop():void {}

	}
	
}
