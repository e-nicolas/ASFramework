package com.emmanouil.ui {
	
	/*
	 * author Emmanouil Nicolas Papadimitropoulos
	 * UIView v0.0
	 */
	
	import flash.display.Sprite;
	
	public class UIView extends Sprite{
		
		public var id:String;
		public var page:int = -1;
		public var segues:Array;
		private var _orientationMode:String = "normal";
		
		//guarda a view anterior executada em um subViewController
		public var subViewParent:UIView;
		
		public var performSegueWithIdentifierHandler:Function;
		
		public function UIView():void {
			segues = new Array();
		}
		
		public function addSegues(id:String, toView:UIView):void {
			//se não existir ainda
			if(GetSegueAtIndex(id) == -1){
				segues.push([id, toView]);
			}
			else{
				trace("[UIView] - Já existe um segue com o id: " + id);
			}			
		}		
		protected function performSegueWithIdentifier(id:String):void {
			if(performSegueWithIdentifierHandler != null){
				const index:int = GetSegueAtIndex(id);
				const destinationView:UIView = segues[index][1];
				performSegueWithIdentifierHandler(id, this, destinationView);				
			}			
		}
		private function GetSegueAtIndex(id:String):int {
			for(var i:int; i < segues.length; i++){
				if(id == segues[i][0]){
					return i;
				}
			}
			return -1;
		}
		
		public function prepareForSegue(segueIdentifier:String, destination:UIView):void {}
		
		public function StartAwake():void {}
		public function Start():void {}
		public function Resume():void {}
		public function Pause():void {}
		public function StopAwake():void {}
		public function Stop():void {}
		public function GoHome():void {
			StartAwake();
			Start();
		}
		
		public function get orientationMode():String { return _orientationMode; }
		public function set orientationMode(value:String):void {
			_orientationMode = value;
			if(stage){
				if(value == "normal"){
					stage.autoOrients = true;
				}else{
					stage.autoOrients = false;
				}
			}
				
		}

	}
	
}
