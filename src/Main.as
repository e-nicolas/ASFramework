package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.SoftKeyboardType;
	
	import com.emmanouil.ui.UITableView;
	import com.emmanouil.ui.UITableViewCell;
	import com.emmanouil.ui.UISwitcher;
	import com.emmanouil.ui.UIActivityIndicatorView;
	import com.emmanouil.ui.message.UIToastControllerView;
	import com.emmanouil.ui.types.ToastScreenAnimation;
	import com.emmanouil.ui.types.UIViewTransitionAnimation;
	import com.emmanouil.ui.message.UIAlertControllerView;
	import com.emmanouil.ui.message.UIAlertType;
	import com.emmanouil.ui.UISliderView;
	import com.emmanouil.ui.UIButton;
	import com.emmanouil.ui.text.UITextField;
	import com.emmanouil.ui.text.InputTextOptions;
	import com.emmanouil.ui.text.InputTextType;
	import com.emmanouil.media.camera.CameraEncoder;
	import com.emmanouil.media.VideoPlayer;
	import com.emmanouil.managers.ViewManager;
	import com.emmanouil.managers.SubViewController;	
	
	import views.MasterView;
	
	/**
	 * ...
	 * @author Emmanouil Nicolas Papadimitropoulos
	 */
	
	public class Main extends Sprite
	{
		
		public function Main()
		{
			
		/*
		 * UITableView
		
		   var uitableView:UITableView = new UITableView(500, 500);
		   uitableView.AddReusableCellWithIdentifier("default", new UITableViewCell(stage.stageWidth, 50));
		   uitableView.cellForRowAtIndexPath = cellForRowAtIndexPath;
		   uitableView.numberOfRowsInSection = numberOfRowsInSection;
		   this.addChild(uitableView);
		
		   var array:Array = new Array();
		   for(var i:int = 0; i < 100; i++){
		   array.push(i);
		   }
		   uitableView.reloadData();
		   function numberOfRowsInSection():int {
		   return array.length;
		   }
		   function cellForRowAtIndexPath(indexPath:Object):UITableViewCell {
		   var cell:UITableViewCell = uitableView.dequeueReusableCellWithIdentifier("default") as UITableViewCell;
		   cell.textLabel.text = array[indexPath.row]
		   return cell;
		   }
		 **/
		
		/*
		 * ToastControllerView
		 *
		   var toastScreenMessage:UIToastControllerView = new UIToastControllerView();
		   this.addChild(toastScreenMessage);
		   toastScreenMessage.mensagem = "Teste";
		   //toastScreenMessage.showActivityIndicator = true;
		   toastScreenMessage.showWithTimer(ToastScreenAnimation.MID_CENTER, 2);
		 **/
		
		/*
		 * UIAlertControllerView
		 *
		
		   var alertController:UIAlertControllerView = new UIAlertControllerView();
		   this.addChild(alertController);
		   alertController.title = "Title";
		   alertController.message = "Test Message";
		   alertController.button1Text = "OK";
		   alertController.button2Text = "CANCEL";
		   alertController.funcao1 = null;
		   alertController.funcao2 = null;
		   alertController.alertType = UIAlertType.DEFAULT;
		   alertController.show();
		 **/
		
		/*
		 * UISliderView
		 *
		
		   var sliderView:UISliderView = new UISliderView(200);
		   sliderView.x = 100;
		   sliderView.y = 100;
		   sliderView.minimumValue = 0;
		   sliderView.maximumValue = 10;
		   this.addChild(sliderView);
		**/
		
		/*
		 * UISwitcher
		 *
		   var switcherView:UISwitcher = new UISwitcher(50, false);
		   switcherView.x = 100;
		   switcherView.y = 100;
		   this.addChild(switcherView);
		 **/
		
		/*
		 * UIButton
		 *
		
		   var button:UIButton = new UIButton(50, 50, 0);
		   button.x = 100;
		   button.y = 100;
		   button.label = "CLICK ME";
		   //button.borderColor = 0x000000;
		   //button.backgroundColor = 0x000000;
		   //button.labelColor = 0x000000;
		   //button.addEventListener(MouseEvent.CLICK, onClick);
		   this.addChild(button);
		 **/
		
		/*
		 * UITextField
		 *
		   var editor:InputTextOptions = new InputTextOptions(InputTextType.LINE, false);
		   //editor.softKeyboardType = SoftKeyboardType.EMAIL;
		   editor.color = 0x333333;
		   var textInput:UITextField = new UITextField(editor, null);
		   textInput.x = 10;
		   textInput.y = 50;
		   textInput.width = 250;
		   textInput.height = 40;
		   textInput.placeholder = "Text me!";
		   textInput.backgroundColor = 0x333333;
		   textInput.focusColor = 0x111111;
		   this.addChild(textInput);
		 **/
		
		/*
		 * Camera Encoder
		
		   var cameraEncoder:CameraEncoder = new CameraEncoder(false);
		   cameraEncoder.width = stage.stageWidth;
		   cameraEncoder.height = stage.stageHeight;
		   cameraEncoder.StartCamera("0", null);
		   cameraEncoder.StartStream("rtmp://myServer/myPublishPoint", "streamName");
		   this.addChild(cameraEncoder);
		 **/
		
		/*
		 * Video Player
		
		   var videoPlayer:VideoPlayer = new VideoPlayer(stage.stageWidth, stage.stageHeight);
		   videoPlayer.play("http://www.w3schools.com/html/mov_bbb.mp4");
		   this.addChild(videoPlayer);
		 **/
		
		/*
		 * View controllers
		 **/
		
		 var myView:MasterView = new MasterView();
		 this.addChild(myView);
		}
	
	}

}