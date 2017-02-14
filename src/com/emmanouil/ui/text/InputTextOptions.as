	package  com.emmanouil.ui.text {
	
	public class InputTextOptions {
		
		public var softKeyboardType:String = "default";
		public var returnKeyLabel:String = "default";
		public var fontFamily:String = "Times New Roman";
		public var fontPosture:String = "normal";
		public var fontWeight:String = "normal";
		public var textAlign:String = "left";
		public var autoCapitalize:String = "none";
		public var restrict:String = null;
		public var maxChars:int = 0;
		public var color:uint = 0;
		
		public var autoCorrect:Boolean = false;
		public var displayAsPassword:Boolean = false;
		
		private var _multiline:Boolean = false;
		private var _inputTextType:String = InputTextType.QUAD;
		
		public function InputTextOptions(inputTextType:String, multiline:Boolean) {
			// constructor code
			
			_inputTextType = inputTextType;
			_multiline = multiline;
			
		}
		
		public function get multiline():Boolean {return _multiline;}
		public function get inputTextType():String {return _inputTextType;}
	}
	
}
