package com.emmanouil.ui {
	
	/*
	 * author Emmanouil Nicolas Papadimitropoulos
	 * UITableViewCell based on Apple iOS SDK (Swift 2.0)
	 */
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import com.emmanouil.utils.ChangeColor;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import com.emmanouil.ui.UIButton;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	
	public class UITableViewCell extends Sprite{

		public var index:int = -1;
		
		private var _width:Number;
		private var _height:Number;
		private var _estimatedHeight:Number;
		private var _allowsSelection:Boolean = true;
		private var _selected:Boolean = false;
		public var allowMultipleSelection:Boolean = false;
		
		public var autoSize:Boolean = false;
				
		private var _backgroundColor:uint = 0xFFFFFF;
		private var _backgroundColorDown:uint = 0xD9D9D9;
		
		private var messageContainer:Sprite;
		private var _background:Shape;		
		private var _textLabel:TextField;		
		private var _textFormat:TextFormat;		
		public var line:Shape;
		private var _accessory:UIMovieClipView;
		
		//delete
		public var canDrag:Boolean = true;
		private var dragging:Boolean = false;
		private var editing:Boolean = false;
		private var btDelete:UIButton;
		
		private var firstTouch:Point;		
				
		//delegates
		//quando as propriedades selected e allowsSelection forem atualizadas
		public var onUpdateRowData:Function;
		public var onClick:Function;
		public var onUpdateSize:Function;
		public var didStartDragging:Function;//when start drag
		public var didEndDragging:Function;//when stop drag
		public var didReturnCell:Function;//when return the cell
		public var didCommitEditing:Function;//when click delete
				
		public function UITableViewCell(width:Number, height:Number) {
			
			_width = width;
			_height = height;
			_estimatedHeight = height;
			
			btDelete = new UIButton(Math.floor(_width * 0.3), _height, 0);
			btDelete.label = "Apagar";
			btDelete.backgroundColor = 0xff3b30;
			btDelete.labelColor = 0xFFFFFF;
			btDelete.x = _width - btDelete.width;			
			btDelete.addEventListener(MouseEvent.MOUSE_UP, OnMouse);
			super.addChild(btDelete);
			
			messageContainer = new Sprite();
			super.addChild(messageContainer);
			
			_background = new Shape();
			_background.graphics.beginFill(0xFFFFFF);
			_background.graphics.drawRect(0, 0, _width, _height);
			_background.graphics.endFill();
			messageContainer.addChild(_background);
			
			_textFormat = new TextFormat("Times New Roman", _height * 0.35, 0x444444);
			_textLabel = new TextField();
			_textLabel.autoSize = "left";
			_textLabel.text = "Title";
			_textLabel.setTextFormat(_textFormat);
			_textLabel.defaultTextFormat = _textFormat;
			_textLabel.height = _height * 0.8;
			_textLabel.x = _width * 0.05;
			_textLabel.y = (_height - _textLabel.height)/2;
			_textLabel.width = _width - _textLabel.x*2;		
			_textLabel.mouseEnabled = false;
			messageContainer.addChild(_textLabel);
			
			line = new Shape();
			line.graphics.beginFill(0xC8C7CC);
			line.graphics.drawRect(0, 0, _width * 0.95, 2);
			line.graphics.endFill();
			line.x = _width - line.width;
			line.y = _background.height - line.height;
			messageContainer.addChild(line);			
						
			messageContainer.addEventListener(MouseEvent.MOUSE_DOWN, OnMouse);			
		}
		private function updateElements():void {
			
			if(autoSize){
				if(_textLabel.height > _height)
					_height = _textLabel.height;
			}else{
				_textLabel.height = _height * 0.8;				
			}
			
			_textLabel.x = _width * 0.05;
			_textLabel.y = (_height - _textLabel.height)/2;
			
			_background.width = _width;
			_background.height = _height;
			
			if(_accessory){
				_accessory.height = _background.height * 0.35;
				_accessory.width = _background.height * 0.35;
				_accessory.x = _background.width - _accessory.width - _width * 0.05;
				_accessory.y = (_background.height - _accessory.height)/2;
				
				_textLabel.width = _width - _textLabel.x * 2 - _accessory.width;
			}
			else{
				_textLabel.width = _width - _textLabel.x*2;
			}
			
			line.width = _width * 0.95;
			line.x = _width - line.width;
			line.y = _height - line.height;	
			
			if(onUpdateSize != null)
				onUpdateSize();
			
			if(autoSize){
				btDelete.height = line.y;
				btDelete.labelSize = _estimatedHeight * 0.45;
			}
			btDelete.x = _width - btDelete.width;
		}
		public function readjustLayout():void {
			updateElements();
		}
		public function OnMouse(e:MouseEvent):void {	
			//btDelete
			if(e.target == btDelete){
				if(e.type == MouseEvent.MOUSE_UP){
					returnToOrigin();
					//callback
					if(didCommitEditing != null)
						didCommitEditing(this)
				}
			}
			//bg
			if(e.target == messageContainer){				
				if(e.type == MouseEvent.MOUSE_DOWN){
					onMouseDownHandler();
				}
				else if(e.type == MouseEvent.MOUSE_UP || e.type == MouseEvent.RELEASE_OUTSIDE){
					stopDragging();
				}
			}
		}
		public function startDragItem():void {
			if(!dragging){
				selected = false;
				dragging = true;
				messageContainer.startDrag(false,new Rectangle( -btDelete.width, messageContainer.y, btDelete.width, 0));
				
				//callback
				if(didStartDragging != null)
					didStartDragging(this);
			}
		}
		public function stopDragging():void {
			if(dragging){
				messageContainer.stopDrag();
				
				messageContainer.removeEventListener(MouseEvent.MOUSE_UP, OnMouse);
				messageContainer.removeEventListener(MouseEvent.RELEASE_OUTSIDE, OnMouse);
				
				if(messageContainer.x != -btDelete.width){
					returnToOrigin();
				}
				else{
					dragging = false;
					editing = true;
					
					//callback
					if(didEndDragging != null)
						didEndDragging(this);
				}
			}
		}
		public function returnToOrigin(e:MouseEvent = null):void {
			messageContainer.removeEventListener(MouseEvent.MOUSE_UP, returnToOrigin);
			TweenLite.to(messageContainer, 0.3, {x: 0});			
			dragging = false;
			editing = false;
			
			if(didReturnCell != null)
				didReturnCell(this);
			
		}
		//Mouse DOWN
		public function onMouseDownHandler():void {
			if(_allowsSelection){
				if(!allowMultipleSelection){
					selected = true;
				}
				
				firstTouch = new Point(stage.mouseX, stage.mouseY);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
				
				messageContainer.addEventListener(MouseEvent.MOUSE_UP, OnMouse);
				messageContainer.addEventListener(MouseEvent.RELEASE_OUTSIDE, OnMouse);
				
				messageContainer.addEventListener(MouseEvent.MOUSE_UP, onSelectItem);				
			}else{
				if(editing)
					messageContainer.addEventListener(MouseEvent.MOUSE_UP, returnToOrigin);
					
			}
		}
		//Mouse MOVE
		public function onMouseMoveHandler(e:MouseEvent):void {
			if(firstTouch == null)
				return;
			
			const deltaX:int = firstTouch.x - stage.mouseX;
			const deltaY:int = Math.abs(firstTouch.y - stage.mouseY);
			if(deltaX > 30){
				if(canDrag){
					startDragItem();
					onMouseOutHandler();
				}
					
			}
			if(deltaY > 30){
				onMouseOutHandler();
			}			
		}
		//Mouse UP
		public function onSelectItem(e:MouseEvent = null):void {
			if(_allowsSelection){
				if(allowMultipleSelection){
					selected = !selected;
					if(onClick != null)
						onClick(this);
				}
				else{
					if(selected){					
						onMouseOutHandler();
						if(onClick != null)
							onClick(this);
					}
				}
				
			}
					
		}
		//Mouse OUT
		public function onMouseOutHandler(e:MouseEvent = null):void {
			if(!allowMultipleSelection){
				selected = false;
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			messageContainer.removeEventListener(MouseEvent.MOUSE_UP, onSelectItem);
		}
		
		public function get showLine():Boolean { return line.visible; }
		public function set showLine(value:Boolean):void {
			line.visible = value;
		}
		public override function set width(value:Number):void {
			_width = value;
			updateElements();
		}
		public override function set height(value:Number):void {
			_height = value;
			updateElements();
		}
		
		//background color
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			ChangeColor.Change(_backgroundColor, background);
		}
		public function get backgroundColorDown():uint { return _backgroundColorDown; }
		public function set backgroundColorDown(value:uint):void {
			_backgroundColorDown = value;
		}
		
		public function get background():Shape { return _background; }
		public function get textLabel():TextField { return _textLabel; }
		
		public function get allowsSelection():Boolean { return _allowsSelection; }
		public function set allowsSelection(value:Boolean):void {
			_allowsSelection = value;
			
			if(onUpdateRowData != null)
				onUpdateRowData(this);
		}
		public function get accessory():DisplayObject { return _accessory; }
		public function set accessory(value:DisplayObject):void {
			if(_accessory == null){
				_accessory = new UIMovieClipView(_background.height * 0.35, _background.height * 0.35);
				_accessory.showBackground = false;
				messageContainer.addChild(_accessory);
			}
			if(value)
				_accessory.movieClip = value;
			
			updateElements();
		}
		public function get showAccessory():Boolean { return _accessory.visible; }
		public function set showAccessory(value:Boolean):void {
			if(_accessory)
				_accessory.visible = value;
		}
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			_selected = value;
			if(value)
				ChangeColor.Change(_backgroundColorDown, _background);
			else
				ChangeColor.Change(_backgroundColor, _background, 0.4);
			
			if(onUpdateRowData != null)
				onUpdateRowData(this);
		}
		public override function addChild(value:DisplayObject):DisplayObject {
			return messageContainer.addChild(value);
		}
		public override function addChildAt(object:DisplayObject, index:int):DisplayObject {
			return messageContainer.addChildAt(object, index);
		}
	}
	
}
