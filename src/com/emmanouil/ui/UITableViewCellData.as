package com.emmanouil.ui {
	
	/*
	 * author Emmanouil Nicolas Papadimitropoulos
	 * UITableViewCell based on Apple iOS SDK (Swift 2.0)
	 */
	
	
	public class UITableViewCellData extends Object {
				
		public static const DefaultReusableIdentifier:String = "__Default";
				
		public var reusableIdentifier:String = DefaultReusableIdentifier;
		
		internal var selected:Boolean = false;
		internal var allowsSelection:Boolean = false;
		
		public function UITableViewCellData() {
			super();
		}
		public function applyCell(cell:UITableViewCell):void {
			selected = cell.selected;
			allowsSelection = cell.allowsSelection;
		}
		protected var _rowHeight:int;
		public final function get rowHeight():int{ return _rowHeight; }
		public final function set rowHeight(value:int):void{
			_rowHeight = value;
		}
			
		
	}
	
}
