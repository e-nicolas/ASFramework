package com.emmanouil.ui {
	
	/*
	 * author Emmanouil Nicolas Papadimitropoulos
	 * UISliderView based on Apple iOS SDK (Swift 2.0)
	 */
	
	import flash.display.Sprite;
	import flash.display.Shape;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.geom.Rectangle;	
	import flash.geom.Point;
	
	import com.emmanouil.utils.ChangeColor;
	import com.emmanouil.core.Capabilities;
	
	public class UISliderView extends Sprite{
		
		private var _width:Number;
		private var _height:Number;
		private var _isRound:Boolean = true;
		private var _enabled:Boolean = true;
		private var _value:Number = 0;
		private var _minimumValue:Number = 0;
		private var _maximumValue:Number = 1;
		
		private var seekBar:Shape;
		private var _seekBarColor:uint = 0xb6b6b6;
		
		private var trackBar:Shape;
		private var _trackBarColor:uint = 0x057afd;
		
		public var seek:UIButton;	
		public var _seekColor:uint = 0xdddddd;
		
		//delegates
		public var onChangeValue:Function;
		public var onClick:Function;
		public var onRelease:Function;
		
		public function UISliderView(width:Number) {
			// constructor code
			
			_width = width;
			_height = Capabilities.GetHeight() * 0.01;
			
			const round = (_isRound) ? _height : 0;
			seekBar = new Shape();
			seekBar.graphics.beginFill(_seekBarColor);
			seekBar.graphics.drawRoundRect(0, 0, _width, _height, round);
			seekBar.graphics.endFill();
			this.addChild(seekBar);
			
			trackBar = new Shape();
			trackBar.graphics.beginFill(_trackBarColor);
			trackBar.graphics.drawRoundRect(0, 0, 0, 0, round);
			trackBar.graphics.endFill();
			this.addChild(trackBar);
			
			const circleSeek:Shape = new Shape();
			circleSeek.graphics.beginFill(_seekColor);
			circleSeek.graphics.drawRoundRect(0, 0, 1,1,1);
			circleSeek.graphics.endFill();
			
			seek = new UIButton(_height * 30, _height * 30, 0);
			seek.label = "";
			seek.image = circleSeek;
			seek.imageScale = 0.7;
			seek.x = int(-seek.width/2);
			seek.y = seekBar.y + (seekBar.height - seek.height)/2;
			this.addChild(seek);
			
			enabled = true;
			
			value = minimumValue;
			
		}
		private function updateElements():void {
			//update seekBar
			isRound = isRound;
		}
		private function updateTrackBar():void {
			const round = (_isRound) ? _height : 0;	
			trackBar.graphics.clear();
			trackBar.graphics.beginFill(_trackBarColor);
			trackBar.graphics.drawRoundRect(0, 0, int(seek.x + seek.width/2), _height, round);
			trackBar.graphics.endFill();
		}
		public function startDragSeek(e:MouseEvent):void {
			if(onClick != null)
				onClick();
			
			//seekHandler("isSeeking");
			seek.startDrag(false, new Rectangle(int(-seek.width/2), seek.y, seekBar.width, 0));
			this.addEventListener(MouseEvent.MOUSE_UP, stopSeekDrag);
			this.addEventListener(MouseEvent.RELEASE_OUTSIDE, stopSeekDrag);
			
			this.addEventListener(Event.ENTER_FRAME, draggingEvent);			
			
		}
		public function draggingEvent(e:Event):void {			
			updateTrackBar();
			
			if(onChangeValue != null)
				onChangeValue();
		}
		public function stopSeekDrag(e:MouseEvent):void {
			//seekHandler("onRelease");
			this.removeEventListener(MouseEvent.MOUSE_UP, stopSeekDrag);
			this.removeEventListener(MouseEvent.RELEASE_OUTSIDE, stopSeekDrag);
			this.removeEventListener(Event.ENTER_FRAME, draggingEvent);
			seek.stopDrag();
			
			updateTrackBar();
			
			if(onRelease != null)
				onRelease();
		}
		public function get value():Number {
			var seekPos: Number = (int(seek.x + seek.width/2) * (maximumValue - minimumValue)) / seekBar.width;
			var videoPos: Number = int(seekPos * 100)/100;
			
			return videoPos + minimumValue;
			
		}
		public function set value(newValue:Number):void {
			_value = newValue;
			
			var videoPos:Number = (_value * 100)/ _maximumValue;
			seek.x = ((videoPos * seekBar.width)/100) -int(seek.width/2);
			
			updateTrackBar();
		}
		public function get maximumValue():Number { return _maximumValue;}
		public function set maximumValue(newValue:Number):void {
			_maximumValue = newValue;
		}
		public function get minimumValue():Number { return _minimumValue;}
		public function set minimumValue(newValue:Number):void {
			_minimumValue = newValue;
		}
		public function get enabled():Boolean {	return _enabled;}
		public function set enabled(newValue:Boolean):void {			
			_enabled = newValue;
			
			if(newValue){
				seek.addEventListener(MouseEvent.MOUSE_DOWN, startDragSeek);
				ChangeColor.Change(_seekColor, seek.image);
			}							
			else{
				seek.removeEventListener(MouseEvent.MOUSE_DOWN, startDragSeek);	
				ChangeColor.Change(_seekBarColor, seek.image);
			}
						
		}
		
		public function get isRound():Boolean { return _isRound; }
		public function set isRound(newValue:Boolean):void {
			_isRound = newValue;
			
			const round = (_isRound) ? _height : 0;
			seekBar.graphics.clear();
			seekBar.graphics.beginFill(_seekBarColor);
			seekBar.graphics.drawRoundRect(0, 0, _width, _height, round);
			seekBar.graphics.endFill();
		}
		
		public function get seekColor():uint { return _seekColor; }
		public function set seekColor(newValue:uint):void {
			_seekColor = newValue;
			ChangeColor.Change(_seekColor, seek.image);
		}
		
		public function get seekBarColor():uint { return _seekBarColor; }
		public function set seekBarColor(newValue:uint):void {
			_seekBarColor = newValue;
			ChangeColor.Change(_seekBarColor, seekBar);
		}
		
		public function get trackBarColor():uint { return _trackBarColor; }
		public function set trackBarColor(newValue:uint):void {
			_trackBarColor = newValue;
			ChangeColor.Change(_trackBarColor, trackBar);
		}
		
		public function get seekBarAlpha():Number { return seekBar.alpha; }
		public function set seekBarAlpha(newValue:Number):void {
			seekBar.alpha = newValue;
		}
		
		public override function get width():Number { return _width; }
		public override function set width(newValue:Number):void {
			_width = newValue;
			updateElements();
		}
		public override function get height():Number { return _height; }
		public override function set height(newValue:Number):void {
			//do nothing
		}

	}
	
}
