package views {
	
	import com.emmanouil.ui.UIView;
	import com.emmanouil.managers.SubViewController;
	import com.emmanouil.core.Capabilities;
	
	public class MasterView extends UIView {
		
		private var subViewController:SubViewController;
		
		public function MasterView()  {
			
			subViewController = new SubViewController();
			this.addChild(subViewController);
			
			const first:FirstViewSubView = new FirstViewSubView(Capabilities.GetWidth(), Capabilities.GetHeight());
			first.name = "First";
			first.orientationMode = "portrait";
			
			const second:SecondViewSubView = new SecondViewSubView(Capabilities.GetWidth(), Capabilities.GetHeight());
			second.name = "Second";
			second.orientationMode = "portrait";
			
			subViewController.AddViews(first, "first");
			subViewController.AddViews(second, "second");
			
			subViewController.AddSegues("gotosecond", first, second);
		}
		public override function StartAwake():void {
			subViewController.StartAwake();
		}
		public override function Start():void {
			subViewController.Start();
		}
		public override function StopAwake():void {
			subViewController.StopAwake();
		}
		public override function Stop():void {
			subViewController.Stop();
		}
		public override function Pause():void {
			subViewController.Pause();			
		}
		public override function Resume():void {
			subViewController.Resume();
		}
		public override function GoHome():void {
			subViewController.ReturnToParent();
		}
	}
	
}
