package com.emmanouil.ui {
	
	/*
	 * author Emmanouil Nicolas Papadimitropoulos
	 * UITableView based on Apple iOS SDK (Swift 2.0)
	 */
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import com.freshplanet.lib.ui.scroll.mobile.ScrollController;
	import flash.geom.Rectangle;
	import com.emmanouil.utils.ChangeColor;
	import flash.utils.Dictionary;
	import com.greensock.TweenLite;
	import flash.utils.setInterval;
	import flash.events.Event;
	import com.emmanouil.utils.Mathf;
	
	public class UITableView extends Sprite{

		private var _width:Number;
		private var _height:Number;
		private var _listWidth:Number = 0;
		private var _listHeight:Number = 0;
		
		private var _paddingTop:Number = 0;
		private var _paddingBottom:Number = 0;
		
		private var _backgroundColor = 0xffffff;
		
		private var scrollRemoved:Boolean = true;
		
		//Scrolls
		private var scrollContainer: Sprite;
		private var scrollMask:Sprite;
		private var scroll: ScrollController;
				
		private var cells:Dictionary;
		
		public var allowMultipleSelection:Boolean = false;
		
		//delegate properties
		//		
		private var _numberOfRowsInSection:int = 0;
		//
		//callbacks events
		public var didSelectRowAtIndexPath:Function;		
		//
		//delegates
		public var numberOfRowsInSection:Function;
		public var cellForRowAtIndexPath:Function;
				
		//delegate editing cell
		public var didCommitEditingRowAtIndexPath:Function;
		public var willBeginEditingRowAtIndexPath:Function;//when start drag
		public var didEndEditingRowAtIndexPath:Function;//when stop drag
		public var didStopEditingRowAtIndexPath:Function;//when return the cell		
		
		//fo9r reuse
		private var _cacheElementsBounds:Vector.<Rectangle>;
		private var _cacheContentBounds:Rectangle;
		
		private var _currentElements:Array;
		private var _cellDatas:Array;
		
		//Pool
		private var _pooledCells:Array;
		private var _activeCells:Array;
		
		public function UITableView(width:Number, height:Number) {
			// constructor code
			
			_width = width;
			_height = height;
			
			scroll = new ScrollController();			
			scroll.horizontalScrollingEnabled = false;
			scrollMask = new Sprite();
			
			scrollContainer = new Sprite();
			scrollContainer.addChild(scrollMask);
			
			//adiciona gráfico pra permitir scroll fora dos elementos
			const rect:Rectangle = new Rectangle(0, 0, _width, _height);
			addScroll();
			this.addChild(scrollContainer);
			
			updateScrollContainer();
			
			cells = new Dictionary();
		}
		private function updateScrollContainer():void {
			scrollContainer.graphics.clear();
			scrollContainer.graphics.beginFill(_backgroundColor, 1);
			scrollContainer.graphics.drawRect(0, 0, _width, _height);
			scrollContainer.graphics.endFill();
			scroll.containerViewport = new Rectangle(0, 0, _width, _height);
		}
		private function onScroll(e:Event):void {
			redraw();
		}
		private var startIndex:int = 0;
		private function redraw():void {			
			
			var displayedBounds:Rectangle = bounds.clone();
			displayedBounds.y += scroll.scrollPosition.y;
			
			for (var i:int = startIndex; i < _currentElements.length; ++i) {
				
				if (_currentElements[i] == undefined)
					continue;
				
				var elementBounds:Rectangle = _currentElements[i].getBounds(scrollMask);
				
				if(elementBounds.bottom < displayedBounds.top || elementBounds.top > displayedBounds.bottom){
					poolCell(_currentElements[i]);
					
					const cellData:UITableViewCellData = new UITableViewCellData();
					cellData.applyCell(_currentElements[i]);
					_cellDatas[i] = cellData;
					
					delete _currentElements[i]; // delete the reference in the array but keep the indexes of other elements intact	
					
					if (elementBounds.top > displayedBounds.bottom){
						startIndex = 0;						
					}
				}
			}
			
			//TODO FOR A PARTIR DOS ELEMENTOS VISIVEIS
			for (i = startIndex; i < _cacheElementsBounds.length; ++i )
			{
				if ( _currentElements[i] == undefined) // if it's not currently displayed
				{	
					
					elementBounds = _cacheElementsBounds[i];
					
					//verifica se está visível
					if (elementBounds.bottom < displayedBounds.top){// + _scrollController.speed
						if(displayedBounds.y + displayedBounds.height < scroll.contentRect.height){
							startIndex = i;
							startIndex = Mathf.Clamp(startIndex, 0, _cacheElementsBounds.length);
						}							
						continue ; // too high, skip to the next
					}					
					else if (elementBounds.top > displayedBounds.bottom){
						break ; // too low, next are not relevant					
					}
					
					const cell:UITableViewCell = cellForRowAtIndexPath({row: i});
					cell.y = elementBounds.y;
					cell.x = elementBounds.x;
					cell.onUpdateRowData = onUpdateRowData;
					cell.onClick = onSelectRow;
					cell.didStartDragging = startCellDrag;
					cell.didEndDragging = endCellDrag;
					cell.didReturnCell = onReturnCell;
					cell.didCommitEditing = onClickDelete;
					cell.canDrag = (didCommitEditingRowAtIndexPath != null) ? true : false;;
					cell.allowMultipleSelection = allowMultipleSelection;
					
					//cell data
					if(_cellDatas[i] != null){
						cell.selected = _cellDatas[i].selected;
						cell.allowsSelection = _cellDatas[i].allowsSelection;
					}					
					scrollMask.addChild(cell);
					_currentElements[i] = cell;					
				}
				
			}
		}
		//add a cell to be used in tableView
		public function AddReusableCellWithIdentifier(id:String, cell:UITableViewCell):void {		
			cells[id] = cell;
			
			_pooledCells = new Array();
			for(var i:int = 0; i < 10; i++){
				_pooledCells.push(cell);
			}
		}
		//get a ReusabelCell added in AddReusableCellWithIdentifier
		public function dequeueReusableCellWithIdentifier(id:String):UITableViewCell {			
			if(_pooledCells.length > 0){
				return _pooledCells.pop();
			}
			return createCellWith(id);
		}
		public function createCellWith(id:String):UITableViewCell {
			const cellClass:Class = Object(cells[id]).constructor;
			const defaultCell:UITableViewCell = cells[id] as UITableViewCell;
			return new cellClass(defaultCell.width, defaultCell.height);
		}
		//get all data in delegates and build all cells
		public function reloadData():void {
			
			clear();
			scroll.addEventListener(ScrollController.SCROLL_POSITION_CHANGE, onScroll);				
			
			_numberOfRowsInSection = (numberOfRowsInSection != null) ? numberOfRowsInSection() : 0;
			if(_numberOfRowsInSection == 0)
				return;
			
			if(cellForRowAtIndexPath == null){
				throw new Error("Não segue a implementação: [cellForRowAtIndexPath]");
				return;				
			}
			
			//for editing cell
			//if it has delegate, means that the user need this functionality
			const canEditCell:Boolean = (didCommitEditingRowAtIndexPath != null) ? true : false;
			
			var estimateBounds:Rectangle = new Rectangle(0, 0, 0, 0);
			var posY:Number = _paddingTop;
			for(var i :int = 0; i < _numberOfRowsInSection; i++){
				
				var cell:UITableViewCell = cellForRowAtIndexPath({section: 0, row: i});
				
				if(scrollRemoved){
					cell.y = posY;
					posY += cell.height;
					scrollMask.addChild(cell);
					_currentElements.push(cell);
				}
				
				//callbacks
				cell.onUpdateRowData = onUpdateRowData;
				cell.onClick = onSelectRow;
				cell.didStartDragging = startCellDrag;
				cell.didEndDragging = endCellDrag;
				cell.didReturnCell = onReturnCell;
				cell.didCommitEditing = onClickDelete;
				cell.canDrag = canEditCell;
				cell.allowMultipleSelection = allowMultipleSelection;
				
				const elementBounds:Rectangle = getElementBounds(cell);
				elementBounds.y += estimateBounds.height;
				estimateBounds.height += elementBounds.height;				
				_cacheElementsBounds.push(elementBounds);
				
				//se for o último
				if(i + 1 == _numberOfRowsInSection){
					cell.showLine = false;
				}
				
			}
			
			_listWidth = cell.x + cell.width;
			_listHeight = (cell.y + cell.height) + _paddingBottom;
			
			if(!scrollRemoved){
				scroll.scrollToTop(false);
				
				_cacheContentBounds = estimateBounds;
				scroll.setContentRect(_cacheContentBounds);
				redraw();
			}
		}		
		private function onUpdateRowData(sender:UITableViewCell):void {
			var index:int = -1;
			const indexPath:Object = createIndexPath(sender);
			if(indexPath.row == -1){
				index = sender.index;
			}else{
				index = indexPath.row;
			}
			if(_cellDatas[index] != null){
				_cellDatas[index].selected = sender.selected;
				_cellDatas[index].allowsSelection = sender.allowsSelection;
			}
			
		}
		private function onSelectRow(sender:UITableViewCell):void {
			if(didSelectRowAtIndexPath != null){
				didSelectRowAtIndexPath(createIndexPath(sender));
			}	
		}
		//when start the dragging event
		private function startCellDrag(sender:UITableViewCell):void {			
			scroll.pauseScrolling();
			sender.allowsSelection = false;
			
			//callback
			if(willBeginEditingRowAtIndexPath != null){
				willBeginEditingRowAtIndexPath(sender);
			}
		}
		//when the cell is totaly showing the delete button
		private function endCellDrag(sender:UITableViewCell):void {			
			for(var i:int = 0; i < _currentElements.length; i++){
				if(_currentElements[i] == undefined)
					continue;
				
				const cell:UITableViewCell = _currentElements[i];
				if(cell != sender){
					cell.canDrag = false;
					cell.allowsSelection = false;					
				}
			}
			//callback
			if(didEndEditingRowAtIndexPath != null){
				didEndEditingRowAtIndexPath(createIndexPath(sender));
			}
		}
		//when the cell was returned of a dragging event
		private function onReturnCell(sender:UITableViewCell):void {
			for(var i:int = 0; i < _currentElements.length; i++){
				if(_currentElements[i] == undefined)
					continue;
				
				const cell:UITableViewCell = _currentElements[i];
				cell.allowsSelection = true;
				cell.canDrag = true;
			}
			scroll.resumeScrolling();
			
			//callback
			if(didStopEditingRowAtIndexPath != null){
				didStopEditingRowAtIndexPath(createIndexPath(sender));
			}
		}
		//when the button delete was clicked on a cell
		private function onClickDelete(sender:UITableViewCell):void {			
			if(didCommitEditingRowAtIndexPath != null){
				didCommitEditingRowAtIndexPath(createIndexPath(sender));
			}
		}
		//delete a row at an indexPath and reajust tableView layout and tableViewData
		public function deleteRowAtIndexPath(indexPath:Object):void {
			
			var deletedCell:UITableViewCell = _currentElements[indexPath.row] as UITableViewCell;
			
			const diffaux:int = _currentElements.length - indexPath.row;
			var actualY:Number = 0;
			for (var i:int = 0; i < diffaux; i++){
				if(_currentElements[indexPath.row + i] == undefined)
					continue;
				
				const nextItem:UITableViewCell = _currentElements[indexPath.row + i] as UITableViewCell;
				if(i > 1){
					const lastItem:UITableViewCell = _currentElements[indexPath.row + i -1]  as UITableViewCell;
					actualY = actualY + lastItem.height;
				}
				else{
					actualY = deletedCell.y;
				}
				TweenLite.to(nextItem, 0.3, {y : actualY});
			}
			
			poolCell(deletedCell);
			
			_currentElements.removeAt(indexPath.row);
			_cellDatas.removeAt(indexPath.row);
			_cacheElementsBounds.removeAt(indexPath.row);
			_cacheContentBounds = updateEstimateContentBounds();
			
			startIndex = 0;
			
			scroll.setContentRect(_cacheContentBounds);
			redraw();
			
		}
		private function poolCell(cell:UITableViewCell):void {
			scrollMask.removeChild(cell);
			_pooledCells.push(cell);
		}
		public function getCellAtIndexPath(indexPath:Object):UITableViewCell {
			var cell:UITableViewCell;
			if(_currentElements[indexPath.row] == undefined){
				cell = cellForRowAtIndexPath(indexPath);	
				cell.onUpdateRowData = onUpdateRowData;
			}
			else{
				cell = _currentElements[indexPath.row];
			}
			
			cell.index = indexPath.row;
			if(_cellDatas[indexPath.row] != null){				
				cell.selected = _cellDatas[indexPath.row].selected;
				cell.allowsSelection = _cellDatas[indexPath.row].allowsSelection;
			}
			return cell;
		}
		public function getIndexPathForCell(cell:UITableViewCell):Object {
			return createIndexPath(cell);
		}
		private function createIndexPath(sender:UITableViewCell):Object {
			return {row: _currentElements.indexOf(sender)};
		}
		public function addScroll():void {
			if(scrollRemoved){
				scrollRemoved = false;
				scroll.addScrollControll(scrollMask, scrollContainer, new Rectangle(0, 0, _width, _height));
				scroll.setContentRect(new Rectangle(0, 0, _listWidth, _listHeight));
			}
		}
		public function removeScroll():void {
			if(!scrollRemoved){
				scrollRemoved = true;
				scroll.removeScrollControll();
			}
		}
		//clear all elements and datas
		public function clear():void {
			while(scrollMask.numChildren > 0){
				scrollMask.removeChildAt(0);
			}
			
			_cacheElementsBounds = new <Rectangle>[];
			_cellDatas = new Array();
			_currentElements = null;
			_currentElements = new Array();
			
			startIndex = 0;
			
		}
		public function dispose():void {
			clear();
			scroll.removeEventListener(ScrollController.SCROLL_POSITION_CHANGE, onScroll);			
		}
		
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			updateScrollContainer();
		}
		
		public override function get width():Number { return _width; }
		public override function set width(value:Number):void {
			_width = value;
			updateScrollContainer();
		}
		public override function get height():Number { return _height; }
		public override function set height(value:Number):void {
			_height = value;
			updateScrollContainer();
		}
		public function get listWidth():Number {
			return _listWidth;
		}
		public function get listHeight():Number {
			return _listHeight;
		}
		
		public function get bounds():Rectangle
		{
			return scroll.containerViewport;
		}		
		private function updateEstimateContentBounds():Rectangle {
			var estBounds:Rectangle = new Rectangle(0, 0, 0, 0);
			for(var i:int = 0; i < _cacheElementsBounds.length; i++){
				_cacheElementsBounds[i].y = estBounds.height;
				estBounds.height += _cacheElementsBounds[i].height;
			}
			return estBounds;
		}
		private function getElementBounds(cell:UITableViewCell):Rectangle {
			return new Rectangle(cell.x, cell.y, cell.width, cell.height);
		}
	}
	
}
