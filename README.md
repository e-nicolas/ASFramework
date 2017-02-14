# ASFramework

Framework developed in Action Script 3 for Adobe AIR applications.

[Source files](src/com/emmanouil)

### Components

##### UITableView
```actionscript
var uitableView:UITableView = new UITableView(500, 500);
uitableView.AddReusableCellWithIdentifier("default", new UITableViewCell(stage.stageWidth, 50));
uitableView.cellForRowAtIndexPath = cellForRowAtIndexPath;
uitableView.numberOfRowsInSection = numberOfRowsInSection;
this.addChild(uitableView);

//create data
var array:Array = new Array();
for(var i:int = 0; i < 100; i++){
    array.push(i);
}

//load cells
uitableView.reloadData();

//data sources
private function numberOfRowsInSection():int {
    return array.length;
}
private function cellForRowAtIndexPath(indexPath:Object):UITableViewCell {
	var cell:UITableViewCell = uitableView.dequeueReusableCellWithIdentifier("default") as UITableViewCell;
	cell.textLabel.text = array[indexPath.row]
	return cell;
}
```
##### ToastControllerView
```actionscript
var toastScreenMessage:UIToastControllerView = new UIToastControllerView();
this.addChild(toastScreenMessage);
toastScreenMessage.mensagem = "Teste";
//toastScreenMessage.showActivityIndicator = true;
toastScreenMessage.showWithTimer(ToastScreenAnimation.MID_CENTER, 2);
```
##### UIAlertControllerView
```actionscript
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
```
##### UISliderView
```actionscript
var sliderView:UISliderView = new UISliderView(200);
sliderView.minimumValue = 0;
sliderView.maximumValue = 10;
this.addChild(sliderView);
```
##### UISwitcher
```actionscript
var switcherView:UISwitcher = new UISwitcher(50, false);
this.addChild(switcherView);
```
##### UIButton
```actionscript
var button:UIButton = new UIButton(50, 50, 0);
button.label = "CLICK ME";
//button.borderColor = 0x000000;
//button.backgroundColor = 0x000000;
//button.labelColor = 0x000000;
//button.addEventListener(MouseEvent.CLICK, onClick);
this.addChild(button);
```
##### UITextField
```actionscript
var editor:InputTextOptions = new InputTextOptions(InputTextType.LINE, false);
//editor.softKeyboardType = SoftKeyboardType.EMAIL;
editor.color = 0x333333;
var textInput:UITextField = new UITextField(editor, null);
textInput.width = 250;
textInput.height = 40;
textInput.placeholder = "Text me!";
textInput.backgroundColor = 0x333333;
textInput.focusColor = 0x111111;
this.addChild(textInput);
```
##### CameraEncoder
```actionscript
var cameraEncoder:CameraEncoder = new CameraEncoder(false);
cameraEncoder.width = stage.stageWidth;
cameraEncoder.height = stage.stageHeight;
cameraEncoder.StartCamera("0", null);
cameraEncoder.StartStream("rtmp://myServer/myPublishPoint", "streamName");
this.addChild(cameraEncoder);
```
##### VideoPlayer
```actionscript
var videoPlayer:VideoPlayer = new VideoPlayer(stage.stageWidth, stage.stageHeight);
videoPlayer.play("http://www.w3schools.com/html/mov_bbb.mp4");
this.addChild(videoPlayer);
```
##### ViewManager
```actionscript
//create views
var masterView1:UIView = new UIView();
this.addChild(masterView1);
var masterView2:UIView = new UIView();
this.addChild(masterView2);

//add views to the manager
ViewManager.AddViews(masterView1, "masterView1");
ViewManager.AddViews(masterView2, "masterView2");

//perform navigation
ViewManager.ChangeViewTo("masterView2", UIViewTransitionAnimation.LEFT_TO_RIGTH);
```
##### SubViewController
```actionscript
var subViewController:SubViewController = new SubViewController();
this.addChild(subViewController);

//first View (parent view)
const first:FirstViewSubView = new FirstViewSubView(Capabilities.GetWidth(), Capabilities.GetHeight());
first.name = "First";
first.orientationMode = "portrait";

//second View
const second:SecondViewSubView = new SecondViewSubView(Capabilities.GetWidth(), Capabilities.GetHeight());
second.name = "Second";
second.orientationMode = "portrait";

//add views to controller
subViewController.AddViews(first, "first");
subViewController.AddViews(second, "second");

//add segue
subViewController.AddSegues("gotosecond", first, second);

//perform segue
first.performSegueWithIdentifier("gotosecond");	
```

## Libraries
[Air-Mobile-ScrollController](https://github.com/freshplanet/Air-Mobile-ScrollController)

[TweenLite](https://greensock.com/tweenlite-as)

License
----

MIT

**Free Software**
