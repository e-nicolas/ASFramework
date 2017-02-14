package com.emmanouil.media.camera {

	/*
	 *	@author Emmanouil Nicolas
	 *  v0.1
	 */

	import flash.display.Sprite;
	import flash.media.Video;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.display.Shape;
	import flash.events.NetStatusEvent;
	import flash.media.VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.SoundCodec;
	import flash.media.VideoCodec;
	import flash.desktop.NativeApplication;
	
	import flash.events.MouseEvent;
	
	import flash.media.H264VideoStreamSettings;
	import flash.media.H264Profile;
	import flash.media.H264Level;
		
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.emmanouil.utils.ChangeColor;
	import com.emmanouil.core.Capabilities;
	import com.emmanouil.media.camera.CameraResolution;

	/*
	 * IMPORTANT
	 *
	 * The PermissionStatus is only usable if you are using Adobe Air 24 or above,
	 * for Android API 23+
	 */
	 
	//import flash.permissions.PermissionStatus;
	//import flash.events.PermissionEvent;	

	public class CameraEncoder extends Sprite {

		private var _backgroundColor: uint = 0;
		private var background: Shape;
		private var foreground: Shape;

		private var _netConnection: NetConnection;
		private var _netStream: NetStream;
		private var _server: String;
		private var _streamName: String;
		private var _isOnline: Boolean = false;

		private var _kbps: Number;
		private var _keyFrameInterval: int;
		private var _fps: Number = 30;
		private var _resolutionX: Number;
		private var _resolutionY: Number;

		private var cameraContainer: Sprite;
		private var camera: Camera;
		private var microphone: Microphone;
		private var video: Video;
		private var currentWidthMode: Number;
		private var currentHeightMode: Number;

		private var containerRect: Rectangle;

		private var _isMobile: Boolean;
		private var _activeCamera: String;

		//callbacks
		public var stateHandler: Function;
		public var onRecording: Function;
		
		private var timer:Timer;		
		
		private var onCompleteStartCamera:Function;

		public function CameraEncoder(isMobile: Boolean) {
			_isMobile = isMobile;

			if (_isMobile)
				_activeCamera = "0";

			kbps = 500;

			cameraContainer = new Sprite();
			this.addChild(cameraContainer);

			background = new Shape();
			background.graphics.beginFill(_backgroundColor);
			background.graphics.drawRect(0, 0, 320, 240);
			background.graphics.endFill();
			cameraContainer.addChild(background);

			video = new Video();
			cameraContainer.addChild(video);
			containerRect = new Rectangle(0, 0, video.width, video.height);

			foreground = new Shape();
			foreground.graphics.beginFill(0, 0);
			foreground.graphics.drawRect(0, 0, 320, 240);
			foreground.graphics.endFill();
			cameraContainer.addChild(foreground);

			SetResolution(CameraResolution._1280x720);
			
		}
		
		public function StartCamera(name:String, onComplete:Function): void {
			onCompleteStartCamera = onComplete;
						
			if (Camera.isSupported) {
				if (name)
					_activeCamera = name;

				camera = Camera.getCamera(_activeCamera);				
				
				if (!Capabilities.isAndroid()){
					connectCamera();
					return;
				}
					
				
				/*
				 * Just needed for Android API 23+ with Adobe Air 24 or above	
				 *
				
				if (Camera.permissionStatus != PermissionStatus.GRANTED) {
					camera.addEventListener(PermissionEvent.PERMISSION_STATUS,
					function (e: PermissionEvent): void {
						if (e.status == PermissionStatus.GRANTED){					
							connectCamera();
						}
						else {
							// permission denied
						}
					});
					try {
						camera.requestPermission();
					} 
					catch (e: Error) {
						//another request is in progress
					}
				}	
				*/
			}			
		}

		private function connectCamera(): void {
			StartMicrophone();
			refreshViewPort();
			RegisterStateHandler("Camera.Start");
		}
		
		public function SwitchCamera(): void {
			if (_isMobile) {

				if (_activeCamera == "0")
					_activeCamera = "1";
				else
					_activeCamera = "0";

				RegisterStateHandler("Camera.Switch");
				StartCamera(_activeCamera, null);
			}

		}
		public function StopCamera(): void {
			video.clear();
			
			if (!Capabilities.isAndroid()) {
				camera = null;
				video.attachCamera(null);
			}
			else{
				/*
				if(Camera.permissionStatus == PermissionStatus.GRANTED){
					camera = null;
					video.attachCamera(null);
				}
				*/				
			}			
			
			//[BUG FIX] false e true/ para atualizar o frame do vídeo e funcionar o .clear()
			video.visible = false;
			video.visible = true;
			//[BUG FIX]

			RegisterStateHandler("Camera.Stop");
		}
		private function StartMicrophone(): void {
			
			//For enhancedMicrophone
			//microphone = Microphone.getEnhancedMicrophone();
			//if (microphone == null)
			microphone = Microphone.getMicrophone();
			
			if (!Capabilities.isAndroid()) {
				setMicrophone();
				return
			}
			
			/*
			if (Microphone.permissionStatus != PermissionStatus.GRANTED) {
				microphone.addEventListener(PermissionEvent.PERMISSION_STATUS,
				function (e: PermissionEvent): void {
					if (e.status == PermissionStatus.GRANTED) {							
						setMicrophone();
					} 
					else {
						// permission denied
					}
				});
				try {
					microphone.requestPermission();
				} 
				catch (e: Error) {
					// another request is in progress
				}
			} 
			else {
				setMicrophone();
			}
			*/
		}
		
		private function setMicrophone():void{
			//Speex inclui a detecção de atividade de voz (VAD) e automaticamente reduz a largura de banda quando nenhuma voz é descoberta.
			microphone.codec = SoundCodec.SPEEX;
			//Se você usar o codec Speex, a taxa de amostra será definida como 16 kHz.
			//microphone.rate = 11;
			microphone.setLoopBack(false);
			microphone.setUseEchoSuppression(true);
			//Ao usar o codec Speex, o adobe recomenda que você estabeleça o nível de silêncio como 0
			microphone.setSilenceLevel(0);
			//A qualidade de fala codificada ao usar o codec Speex
			//Os possíveis valores são de 0 a 10. O valor padrão é 6.
			microphone.encodeQuality = 6;
			//Os valores válidos são 0 a 100. O valor padrão é 50.
			microphone.gain = 70;
			
			if(onCompleteStartCamera != null)
				onCompleteStartCamera();
		}
		
		private function StopMicrophone(): void {			
			if (!Capabilities.isAndroid()) {
				microphone = null;
				return;
			}
			
			/*
			if (Microphone.permissionStatus == PermissionStatus.GRANTED) 
				microphone = null;
			*/
		}
		public function StartStream(server: String, streamName: String): void {
			_server = server;
			_streamName = streamName;

			_netConnection = new NetConnection();
			_netConnection.connect(_server);
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);

		}
		public function StopStream(): void {

			if (_netConnection) {
				_netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_netConnection.close();
			}

			if (_netStream) {
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_netStream.close();
			}

			_server = null;
			_streamName = null;

			_isOnline = false;

			RegisterStateHandler("Stream.Stop");
		}
		public function Dispose(): void {
			StopStream();
			StopCamera();
			StopMicrophone();
		}
		private function onNetStatus(e: NetStatusEvent): void {			
			trace("Camera Player -  " + e.info.code);
			switch (e.info.code) {
				case "NetConnection.Connect.Success":					
					iniciaStream();
					break;
				case "NetConnection.Connect.Failed":
					_isOnline = false;
					break;
				case "NetConnection.Connect.Closed":
					_isOnline = false;
					break;
				case "NetStream.Publish.Start":
					RegisterStateHandler("Stream.Start");
					_isOnline = true;
					break;
			}
		}
		private function iniciaStream(): void {
			_netStream = new NetStream(_netConnection);
			_netStream.attachCamera(camera);
			_netStream.attachAudio(microphone);

			/*
			 * For Publish with H264 Encoding
			 * DOES NOT WORK IN MOBILE
			
			const streamSettings:H264VideoStreamSettings = new H264VideoStreamSettings();
			streamSettings.setProfileLevel(H264Profile.MAIN, H264Level.LEVEL_2_1);
			_netStream.videoStreamSettings = streamSettings;
			*/

			//mp4: for forcing mp4 file
			//flv: for forcing flv file
			//_netStream.publish("mp4:" + _streamName, "append");
			_netStream.publish(_streamName, "append");
			sendMetaData();
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		private function sendMetaData(): void {
			const metaData: Object = new Object();
			metaData.videodevice = camera.name;
			metaData.framerate = _fps;
			metaData.width = camera.width;
			metaData.height = camera.height;
			metaData.audiodevice = microphone.name;
			metaData.audiosamplerate = microphone.rate;
			metaData.audiocodecid = microphone.codec;
			metaData.isMobile = _isMobile;
			metaData.rotation = cameraContainer.rotation;
			metaData.scaleX = video.scaleX;
			metaData.scaleY = video.scaleY;
			_netStream.send("@setDataFrame", "onMetaData", metaData);
		}
		private function RegisterStateHandler(state: String): void {
			if (stateHandler != null)
				stateHandler(state);
		}
		public function setSize(width: Number, height: Number): void {
			containerRect.width = width;
			containerRect.height = height;

			refreshViewPort();
		}
		public function setPosition(x: Number, y: Number): void {
			containerRect.x = x;
			containerRect.y = y;

			refreshViewPort();
		}
		private function refreshViewPort(): void {

			const largura: Number = (_isMobile) ? containerRect.height : containerRect.width;
			const altura: Number = (_isMobile) ? containerRect.width : containerRect.height;

			background.width = largura;
			background.height = altura;

			foreground.width = largura;
			foreground.height = altura;


			const relacaoWidth: Number = (largura) / _resolutionX;
			const relacaoHeight: Number = (altura) / _resolutionY;

			const ratio: Number = (relacaoWidth < relacaoHeight) ? relacaoWidth : relacaoHeight;

			const newLargura: int = _resolutionX * ratio;
			const newAltura: int = _resolutionY * ratio;

			video.width = newLargura;
			video.height = newAltura;
			video.x = (background.width - video.width) / 2;
			video.y = (background.height - video.height) / 2;

			//rotação do vídeo para se ajustar em portrait
			if (_isMobile) {
				if (Capabilities.isAndroid() && _activeCamera == "1") {
					cameraContainer.rotation = -90;
					cameraContainer.x = containerRect.x;
					cameraContainer.y = containerRect.y + largura;

					video.scaleY *= -1;
					video.x += containerRect.y / 2;
					video.y = containerRect.width - video.y;
				} else {
					cameraContainer.rotation = 90;
					cameraContainer.x = containerRect.x + altura;
					cameraContainer.y = containerRect.y;
					video.x -= containerRect.y / 2;
				}
			} else {
				cameraContainer.x = containerRect.x;
				cameraContainer.y = containerRect.y;
				video.y -= containerRect.y / 2;
			}

			currentWidthMode = _resolutionX;
			currentHeightMode = _resolutionY;

			if (camera) {
				if (Capabilities.isAndroid())
					camera.setMode(currentWidthMode, currentHeightMode, _fps);
				else
					camera.setMode(currentWidthMode, currentHeightMode, _fps);

				camera.setKeyFrameInterval(_keyFrameInterval);
				camera.setQuality(_kbps, 0);
				video.attachCamera(camera);
			}
		}
		public function SetResolution(cameraResolution: String): void {
			const _x: int = int(cameraResolution.substr(0, cameraResolution.indexOf("x")));
			const _y: int = int(cameraResolution.substr(cameraResolution.indexOf("x") + 1, int.MAX_VALUE));

			_resolutionX = _x;
			_resolutionY = _y;

			refreshViewPort();
		}
		public function SetBitrate(bitrate: String): void {
			kbps = Number(bitrate.substr(0, bitrate.indexOf(" ")));

			if (camera)
				camera.setQuality(_kbps, 0);
		}
		public function SetInterval(interval: String): void {
			_keyFrameInterval = int(interval.substr(0, interval.indexOf(" ")));

			if (camera)
				camera.setKeyFrameInterval(_keyFrameInterval);
		}

		public function get resolution(): String {
			return _resolutionX + "x" + _resolutionY;
		}
		public function get keyFrameInterval(): int {
			return _keyFrameInterval;
		}

		public function get kbps(): int {
			return _kbps;
		}
		public function set kbps(value: int): void {
			_kbps = (value * 1024) / 8;
		}

		public function get fps(): int {
			return _fps;
		}
		public function set fps(value: int): void {
			_fps = value;
		}

		public function get resolutionX(): int {
			return _resolutionX;
		}
		public function get resolutionY(): int {
			return _resolutionY;
		}

		public function get isOnline(): Boolean {
			return _isOnline;
		}

		public function set backgroundColor(value: uint): void {
			_backgroundColor = value;
			ChangeColor.Change(_backgroundColor, background);
		}
		public function get backgroundColor(): uint {
			return _backgroundColor;
		}

		public override function get width(): Number {
			return containerRect.width;
		}
		public override function get height(): Number {
			return containerRect.height;
		}

		public function get rotacao(): Number {
			return cameraContainer.rotation;
		}


	}

}