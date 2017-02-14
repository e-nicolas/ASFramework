package views {
	
	import com.emmanouil.ui.UISubView;
	
	public class SecondViewSubView extends UISubView{
		
		private var _width:Number;
		private var _height:Number;		
		
		public function SecondViewSubView(width:Number, height:Number) {
			
			_width = width;
			_height = height;
			
			// constructor code
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0,0,_width, _height);
			this.graphics.endFill();
		}
		
		public override function ReadyToBuildView():void {
			
		}			
		public override function StartAwake():void {}		
		public override function Start():void {}
		public override function Resume():void {}
		public override function Pause():void {}
		public override function StopAwake():void {}
		public override function Stop():void {}

	}
	
}
