package com.emmanouil.ui {
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import com.emmanouil.core.Capabilities;
	import com.emmanouil.utils.ChangeColor;
	import com.emmanouil.managers.ViewManager;
	import com.emmanouil.utils.Text;
	import com.emmanouil.assets.Assets;
	import flash.display.Bitmap;
	
	public class UINavigationBar extends Sprite {
		
		private var _width:Number;
		private var _height:Number;
		private var _title:String = "Title";
		
		private var bgBar:Shape;
		private var lineBar:Shape;
		private var titleField:TextField;
		
		//Bar Button Items
		private var _leftItem:UIButton;
		public var onClickLeftItem:Function;
				
		public function UINavigationBar() {
			
			_width = Capabilities.GetWidth();
			_height = Capabilities.GetHeight() * 0.12;
			
			bgBar = new Shape();
			bgBar.graphics.beginFill(0xeeeeee);
			bgBar.graphics.drawRect(0,0 , _width, _height);
			bgBar.graphics.endFill();
			this.addChild(bgBar);
			
			lineBar = new Shape();
			lineBar.graphics.beginFill(0x666666);
			lineBar.graphics.drawRect(0,0, bgBar.width, 1);
			lineBar.graphics.endFill();
			lineBar.y = bgBar.y + bgBar.height - lineBar.height;
			this.addChild(lineBar);
			
			const textFormat:TextFormat = new TextFormat("Times New Roman", _height * 0.33, 0x666666);
			titleField = new TextField();
			titleField.autoSize = "left";
			titleField.text = _title;
			titleField.setTextFormat(textFormat);
			titleField.defaultTextFormat = textFormat;
			titleField.x = (bgBar.width - titleField.width)/2;
			titleField.y = bgBar.y + (bgBar.height - titleField.height)/2;
			titleField.mouseEnabled = false;
			this.addChild(titleField);
			
			_leftItem = new UIButton(150, bgBar.height, 0);
			_leftItem.label = "Back";
			_leftItem.y = titleField.y + (titleField.height - _leftItem.height)/2;
			_leftItem.visible = false;
			const arrow:Bitmap = new Assets.Icon_Left_ArrowPNG() as Bitmap;	
			ChangeColor.Change(_leftItem.labelColor, arrow);
			_leftItem.image = arrow;
			_leftItem.imageScale = 0.4;
			_leftItem.align = "left";
			_leftItem.addEventListener(MouseEvent.CLICK, onMouseClickHandler);
			this.addChild(_leftItem);
		}
		private function updateElements():void {
			bgBar.width = _width;
			bgBar.height = _height;
			
			lineBar.width = bgBar.width;
			lineBar.y = bgBar.y + bgBar.height - lineBar.height;
			
			updateTitle();			
		}
		private function updateTitle():void {
			const textFormat:TextFormat = new TextFormat("Times New Roman", _height * 0.33, 0x666666);
			titleField.text = _title;
			titleField.setTextFormat(textFormat);
			titleField.defaultTextFormat = textFormat;
			titleField.x = (bgBar.width - titleField.width)/2;
			titleField.y = bgBar.y + (bgBar.height - titleField.height)/2;
		}
		private function onMouseClickHandler(e:MouseEvent):void {
			if(e.target == _leftItem){
				if(onClickLeftItem != null){
					onClickLeftItem();
				}
			}		
		}		
		public function get title():String { return _title; }
		public function set title(value:String):void {
			_title = Text.limitText(value, 22);;
			
			updateTitle();
		}		
		public override function set visible(value:Boolean):void {			
			super.visible = value;				
		}
		public function get leftItem():UIButton { return _leftItem; }		
		
	}	
}
