package com.emmanouil.media
{
	
	/*
	 * author Emmanouil Nicolas Papadimitropoulos
	 * VideoPlayer v.0.1, uses the flash video engine.
	 * Documentation: 
	 * NetStream - 		http://help.adobe.com/pt_BR/FlashPlatform/reference/actionscript/3/flash/net/NetStream.html
	 * NetConnection -  http://help.adobe.com/pt_BR/FlashPlatform/reference/actionscript/3/flash/net/NetConnection.html
	 * Video - 			http://help.adobe.com/pt_BR/FlashPlatform/reference/actionscript/3/flash/media/Video.html
	 * StageVideo - 	http://help.adobe.com/pt_BR/FlashPlatform/reference/actionscript/3/flash/media/StageVideo.html
	 */
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle;

	import flash.net.NetStream;
	import flash.net.NetConnection;	
	
	import flash.media.Video;
	import flash.media.StageVideo;
	
	import flash.media.StageVideoAvailability;
	import flash.events.StageVideoAvailabilityEvent;
	
	import flash.media.SoundTransform;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	
	import com.emmanouil.utils.URLStreamParser;	
	import com.emmanouil.utils.ChangeColor;
	
	public class VideoPlayer extends Sprite {
		
		private var _backgroundColor:uint = 0;
		
		//Flash video
		private var _netConnection:NetConnection;
		private var _netStream:NetStream;
		private var video:Video;
		public var stageVideo:StageVideo;
		
		private var defaultWidth:Number = 640;
		private var defaultHeight:Number = 360;
		private var oldWidth:Number;
		private var oldHeight:Number;
		private var videoNativeWidth:Number = -1;
		private var videoNativeHeight:Number = -1;
		private var _videoRotation:int = 0;
		
		public var isOnDemand:Boolean;
		
		private var _videoSource:String;
		private var _server:String;
		
		//resize		
		private var containerRect:Rectangle;	
		private var videoRect:Rectangle;	
		private var playerMask:Sprite;
		
		private var stageVideoAvailability:Boolean;
		private var _isStageVideo:Boolean;
		private var _resizable:Boolean = true;
		
		private var _duration:Number;
		private var _playing:Boolean;
		
		private var _title:String;
		
		//delegate
		public var onUpdateTime:Function;
		public var onNetStatusEvent:Function;
		public var onFinishedVideo:Function;
		public var onChangePlayingState:Function;
		public var onVideoReady:Function;
		
		public function VideoPlayer(width:Number = 640, height:Number = 360, disableHardwareAcceleration:Boolean = false) {
			defaultWidth = width;
			defaultHeight = height;
			
			//constructor
			containerRect = new Rectangle(0, 0, defaultWidth, defaultHeight);
			videoRect = containerRect;
			
			videoNativeWidth = containerRect.width;
			videoNativeHeight = containerRect.height;			
			
			playerMask = new Sprite();
			playerMask.graphics.beginFill(_backgroundColor, 1);
			playerMask.graphics.drawRect(0, 0, containerRect.width , containerRect.height);
			playerMask.graphics.endFill();
			playerMask.x = containerRect.x;
			playerMask.y = containerRect.y;
			this.addChild(playerMask);;	
			
			_isStageVideo = !disableHardwareAcceleration;
			
		}
		public function play(videoPath:String):void {
			dispose();
			
			const sourcePath:Object = URLStreamParser.Parse(videoPath);			
			
			//isOnDemand = sourcePath.onDemand;
			
			//On demand file
			if(sourcePath.protocol == "http"){
				_videoSource = videoPath;
			}
			//live stream "rtmp"
			else{
				_server = sourcePath.urlStream;
				_videoSource = sourcePath.stream;
			}
				
			//sourcePath.protocol;
			//sourcePath.fileType;
			//sourcePath.onDemand;
			startVideoComponent();
		}
		private function startVideoComponent():void {
			if(!_isStageVideo){
				disableStageVideo();
				initStream();
				return;
			}
			if(!stageVideoAvailability){
				if(stage == null){
					trace("[Video Player] - Stage is null!");	
					disableStageVideo();
					initStream();
				}
				else{
					stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailability);
				}
			}
			else{
				enableStageVideo();			
				initStream();
			}
				
		}
		private function onStageVideoAvailability(e:StageVideoAvailabilityEvent):void {
			stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailability);			
			
			if (e.availability)
				enableStageVideo();
			else 				
				disableStageVideo();
			
			initStream();
		}
		private function enableStageVideo() : void {
			stageVideoAvailability = true;
			if(_isStageVideo){
				trace("[Video Player] - Stage Video available!");
				
				if(stage.stageVideos.length > 0){
					stageVideo = stage.stageVideos[0];					
					stageVideo.viewPort = videoRect;
				}
				else{
					disableStageVideo();
				}								
			}
			else{
				disableStageVideo();
			}			
		}		
		private function disableStageVideo() : void {
			stageVideo = null;

			video = new Video(containerRect.width, containerRect.height);
			//this.addChildAt(video,0);
			this.addChild(video);
			
			_isStageVideo = false;
		}
		private function initStream() : void {
			trace("[Video Player] - Initializing stream...");
			_netConnection = null;
			_netConnection = new NetConnection();
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_netConnection.connect(_server);			
		}
		private function onNetStatus(e:NetStatusEvent): void {
			trace("[Video Player] - " + e.info.code)
			switch (e.info.code) {
				case "NetConnection.Connect.Success":
						playPlaybackVideo();
					break;
				case "NetConnectio.Connect.Closed":
					//
					break;	
				case "NetStream.Play.Start":
					//
					playerMask.alpha = 0;
					playing = true;
					break;
				case "NetStream.Buffer.Full":
					//	
					break;
				case "NetStream.Buffer.Empty":
					//	
					break;
				case "NetStream.Unpause.Notify":
					//
					playing = true;
					break;
				case "NetStream.Pause.Notify":
					//
					playing = false;
					break;
				case "NetStream.Play.UnpublishNotify":
					_playing = false;
					if(video)
						video.clear();
					//
					break;
				case "NetStream.Play.Stop":
					//
					_playing = false;
					if(video)
						video.clear();
					break;				
				case "NetStream.Play.StreamNotFound":
					if(_server != null && _server != "")
						trace("[Video Player] - StreamNotFound in - " + _server + _videoSource);
					else
						trace("[Video Player] - StreamNotFound in - " + _videoSource);
					_playing = false;
					if(video)
						video.clear();
					//
					break;
				case "NetStream.Video.DimensionChange":
					if(_isStageVideo){
						if(stageVideo){
							videoNativeWidth = stageVideo.videoWidth;
							videoNativeHeight = stageVideo.videoHeight;
						}
					}else{
						if(video){
							videoNativeWidth = video.videoWidth;
							videoNativeHeight = video.videoHeight;
						}						
						if(_videoRotation == 0)
							refreshViewPort();
					}					
					refreshViewPort();	
					break;
				case "NetStream.SeekStart.Notify":
					
				break;
				case "NetStream.Seek.Notify":
					if(_playing){
						return;
					}else{
						this.addEventListener(Event.ENTER_FRAME, updateTime);
					}
				break;
			}
			
			if(onNetStatusEvent != null){
				onNetStatusEvent(e.info.code);
			}
		}
		public function playPlaybackVideo():void {
			try{				
				_netStream = null;
				_netStream = new NetStream(_netConnection);
				_netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_netStream.client = {onMetaData: onMetaData};
				_netStream.bufferTime = 0;
				_netStream.play(_videoSource);
				
				if(_isStageVideo)
					stageVideo.attachNetStream(_netStream);
				else
					video.attachNetStream(_netStream);
				
			}
			catch(error:Error){
				trace(error);				
			}			
			
		}
		private function onMetaData(info:Object):void {
			videoNativeWidth = info.width;
			videoNativeHeight = info.height;
						
			_duration = info.duration;
			
			if(info.hasOwnProperty("rotation")){
				_videoRotation = info.rotation;
			}
			refreshViewPort();			
			
			this.addEventListener(Event.ENTER_FRAME, updateTime);
			
			if(onVideoReady != null)
				onVideoReady();
			
			if(onNetStatusEvent != null){
				onNetStatusEvent("NetStream.Play.Ready");
			}
		}
		private function updateTime(e:Event):void {
			if(_duration){
				
				if(Math.floor(currentTime) >= Math.floor(_duration)){					
					trace("[Video Player] - Video Finished!");
					this.removeEventListener(Event.ENTER_FRAME, updateTime);
					playing = false;
					if(onNetStatusEvent != null){
						onNetStatusEvent("NetStream.Play.Finished");
					}
					if(onFinishedVideo != null)
						onFinishedVideo();
					return;
				}			
				
				if(onUpdateTime != null){
					onUpdateTime();
				}
			}
		}
		
		public function resume():void {
			if(_netStream){
				playing = true;
				_netStream.resume();
			}
			
		}
		public function pause():void {
			if(_netStream){
				playing = false;
				_netStream.pause();
			}			
		}
		public function setSize(_width:Number, _height:Number):void {
			containerRect.width = _width;
			containerRect.height = _height;
			
			refreshViewPort();
		}
		public function move(_x:Number, _y:Number):void {
			containerRect.x = _x;
			containerRect.y = _y;
			
			refreshViewPort();
		}
		private function refreshViewPort():void {
			
			//Apply values
			if(_resizable){
				
				var relacaoWidth: Number;
				var relacaoHeight: Number;
				
				if(_videoRotation == 0){
					relacaoWidth = (containerRect.width) / videoNativeWidth;
				    relacaoHeight = (containerRect.height) /  videoNativeHeight;
				}
				else{
					relacaoWidth = (containerRect.height) / videoNativeWidth;
				    relacaoHeight = (containerRect.width) /  videoNativeHeight;
				}
				
				const ratio:Number = (relacaoWidth < relacaoHeight) ? relacaoWidth : relacaoHeight;
				
				const mWidth:Number = videoNativeWidth * ratio;
				const mHeight:Number = videoNativeHeight * ratio;
				
				const mX:Number = containerRect.x + (containerRect.width - mWidth)/2;			
				const mY:Number = containerRect.y + (containerRect.height - mHeight)/2;
				
				videoRect = new Rectangle(mX, mY, mWidth, mHeight);
			}
			else{
				videoRect = containerRect;
			}
			
			updateVideoViewPort();
		}		
		
		private function updateVideoViewPort():void {
			
			//Apply to video object
			if(_isStageVideo){
				if(stageVideo){
					stageVideo.viewPort = videoRect;
				}								
			}
			else{
				if(video){
					video.rotation = 0;

					video.width = videoRect.width;
					video.height = videoRect.height;
					
					if(_videoRotation == 0){
						video.x = videoRect.x;
						video.y = videoRect.y;
					}
					else if(_videoRotation == 90){
						video.x = containerRect.x + (video.height + containerRect.width)/2;
						video.y = containerRect.y + (video.width + containerRect.height)/2 - video.width;
					}
					else if(_videoRotation == -90){
						video.x = containerRect.x + (video.height + containerRect.width)/2 - video.height;
						video.y = containerRect.y + (video.width + containerRect.height)/2;
					}
					
					video.rotation = _videoRotation;
				}				
			}
			
			playerMask.graphics.clear();
			playerMask.graphics.beginFill(0, 1);
			playerMask.graphics.drawRect(0, 0, containerRect.width , containerRect.height);
			playerMask.graphics.endFill();
			playerMask.x = containerRect.x;
			playerMask.y = containerRect.y;
			
		}
		public function dispose():void{
			this.removeEventListener(Event.ENTER_FRAME, updateTime);
			
			playerMask.alpha = 1;
			
			if(_netConnection){
				_netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_netConnection.close();
			}
				
			if(_netStream){
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_netStream.close();
			}
			
			if(_isStageVideo){
				if(stageVideo){
					stageVideo.attachNetStream(null);
					stageVideo = null;
				}				
			}							
			else{
				if(video){
					video.clear();
					video.attachNetStream(null);
					this.removeChild(video);
					video = null;
				}
			}
			
			_server = null;
			_videoSource = null;
			_playing = false;
			
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			
			trace("[Video Player] - Disposed!");
		}
		
		public override function get x():Number { return containerRect.x; }
		public override function set x(value:Number):void {
			containerRect.x = value;
			refreshViewPort();
		}
		public override function get y():Number { return containerRect.y; }
		public override function set y(value:Number):void {
			containerRect.y = value;
			refreshViewPort();
		}
		public override function get width():Number { return containerRect.width; }
		public override function set width(value:Number):void {
			containerRect.width = value;
			refreshViewPort();
		}
		public override function get height():Number { return containerRect.height; }
		public override function set height(value:Number):void {
			containerRect.height = value;
			refreshViewPort();
		}
		public function get videoRotation():Number { return _videoRotation; }
		public function set videoRotation(value:Number):void {
			_videoRotation = value;
			refreshViewPort();
		}		
		public function set isResizable(value:Boolean):void {
			_resizable = value;
		}		
		public function get isResizable():Boolean {return _resizable;}
		
		public function get isStageVideo():Boolean {return _isStageVideo;}
		
		public function get playing():Boolean {return _playing;}
		public function set playing(value:Boolean):void {
			_playing = value;
			if(onChangePlayingState != null)
				onChangePlayingState(value);
		}
		/*
		 * Current Time
		 */
		public function get currentTime():Number {
			if(_netStream != null){
				return _netStream.time;
			}
			//else
			return 0;
		}
		public function set currentTime(value:Number):void {
			if(_netStream != null){
				_netStream.seek(value);
			}
		}
		/*
		 * Volume
		 */
		public function get volume():Number {
			if(_netStream)
				return _netStream.soundTransform.volume; 
			return 0;
		}
		public function set volume(value:Number):void {
			if(_netStream)
				_netStream.soundTransform = new SoundTransform(value);
		}
		public function get duration():Number {return _duration;}
		public function get netStream():NetStream {return _netStream;}
		
		public function set showVideo(value:Boolean):void {
			var netStream:NetStream = null;
			if(value){
				netStream = _netStream;
			}
			
			if(_isStageVideo){
				if(stageVideo){
					stageVideo.attachNetStream(netStream);
				}				
			}							
			else{				
				if(video){
					video.attachNetStream(netStream);
				}
			}
		}
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			ChangeColor.Change(_backgroundColor, playerMask);
		}
		public function get backgroundColor():uint { return _backgroundColor; }
		
		public override function set visible(value:Boolean):void {
			super.visible = value;
						
			//StageVideo cannot be invisible
			//you can set the position out of the stage
			//
			
			if(!_isStageVideo){
				if(video){
					video.visible = value;
				}				
			}
		}
			
	}//end Class	
}//end Package
