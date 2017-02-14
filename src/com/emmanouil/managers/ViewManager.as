package com.emmanouil.managers {
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import com.emmanouil.ui.UIView;
	import com.emmanouil.ui.types.UIViewTransitionAnimation;
	import com.emmanouil.core.Capabilities;
	
	public class ViewManager {

		private static var changingView:Boolean;
		
		public static var activeView:UIView;
		public static var lastView:UIView;
		private static var viewsArray:Array = new Array();
		
		public static var preventChange:Boolean = false;
		
		public static function AddViews(view:UIView, id:String):void {
			
			if(viewsArray.length < 1){
				activeView = view;
				activeView.Start();
			}
			else{
				view.visible = false;
			}
			
			view.id = id;
			viewsArray.push(view);
			
			trace("[View Manager] - Add - " + id);			
			
		}
		public static function ChangeViewTo(id:String, animation:String = "rightToLeft"):void {
			if(!preventChange){
				goToView(ViewWithID(id), animation);
			}
			//volta para o default
			preventChange = false;		
		}
		private static function goToView(_activeView:UIView, _animationType:String):void {
			if(!changingView){
				changingView = true;
				
				lastView = activeView;
				activeView = _activeView;			
				
				activeView.visible = true;			
				
				//Se não repetir a tela
				if(lastView != activeView){					
					
					switch(_animationType){
						case UIViewTransitionAnimation.FADE_OUT:
							activeView.alpha = 0;				
							TweenLite.to(activeView, 0.5, {alpha: 1, onStart: onStart, onComplete: onComplete});
						break;
						case UIViewTransitionAnimation.PAGED:
							//se a tela anterior estiver na esquerda - animar da direita p/ esquerda
							const factor:Number = (lastView.page > activeView.page) ? -1.5 : 1.5;
							_activeView.x = Capabilities.GetWidth() * factor;
							lastView.visible = false;
							TweenLite.to(activeView, 0.5, {x: 0, alpha: 1, ease: Expo.easeOut, onStart: onStart, onComplete: onComplete});							
						break;
						case UIViewTransitionAnimation.RIGTH_TO_LEFT:
							_activeView.x = Capabilities.GetWidth() * 1.5;
							lastView.visible = false;
							TweenLite.to(activeView, 0.5, {x: 0, alpha: 1, ease: Expo.easeOut, onStart: onStart, onComplete: onComplete});
						break;
						case UIViewTransitionAnimation.LEFT_TO_RIGTH:
							_activeView.x = Capabilities.GetWidth() * -1.5;
							lastView.visible = false;
							TweenLite.to(activeView, 0.5, {x: 0, alpha: 1, ease: Expo.easeOut, onStart: onStart, onComplete: onComplete});
						break;
					}
				}
				else{					
					changingView = false;
					activeView.GoHome();
				}
			}			
		}
		private static function onStart():void {			
			lastView.StopAwake();
			activeView.StartAwake();
			
			//verifica orientação da tela
			//DeviceScreenManager.CheckViewOrientation(activeView);
			
			checkAwakeViews();
		}
		private static function onComplete():void {
			trace("[View Manager] - Navegated - " + activeView.name);
			
			changingView = false;
			
			lastView.alpha = 1;
			lastView.visible = false;
			checkViews();
			
			lastView.Stop();
			activeView.Start();
			
		}
		private static function checkAwakeViews():void {
			
		}
		private static function checkViews():void {
						
		}
		private static function ViewWithID(id:String):UIView {
			for(var i:int = 0; i < viewsArray.length; i++){
				if(viewsArray[i].id == id){
					return viewsArray[i];
				}
			}
			throw new Error("Não achou o item: " + id);
			return viewsArray[0];
		}
	}
	
}
