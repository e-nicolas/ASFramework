package com.emmanouil.managers {	
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;	
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import com.emmanouil.ui.UIView;
	import com.emmanouil.ui.types.UIViewTransitionAnimation;
	import com.emmanouil.ui.UISubView;
	import com.emmanouil.ui.UINavigationBar;
	import com.emmanouil.core.Capabilities;
	
	public class SubViewController extends Sprite {
		
		private var _navigationBar:UINavigationBar;
		
		private var changingView:Boolean;
		
		public var parentView:UIView;
		public var activeView:UIView;
		public var lastView:UIView;
		
		private var arraySequenceOfViews:Array;
		
		private var viewsArray:Array;
		private var seguesArray:Array;
		
		private var blockScreen:Shape;
		
		public function SubViewController() {
			// constructor code
			
			_navigationBar = new UINavigationBar();
			_navigationBar.leftItem.visible = false;
			_navigationBar.onClickLeftItem = backToLastView;
			this.addChild(_navigationBar);
			
			viewsArray = new Array();
			seguesArray = new Array();
			arraySequenceOfViews = new Array();
			
			blockScreen = new Shape();
			
		}
		public function StartAwake():void {
			activeView.StartAwake();
		}
		public function Start():void {
			activeView.Start();
		}
		public function StopAwake():void {
			activeView.StopAwake();
		}
		public function Stop():void {
			activeView.Stop();
		}
		public function Pause():void {
			activeView.Pause();
		}
		public function Resume():void {
			activeView.Resume();
		}
		public function ReturnToParent(animation:Boolean = true):void {
			if(activeView != parentView){
				arraySequenceOfViews = new Array();
				if(animation)
					returnView(parentView);
				else{
					activeView.visible = false;
					goToView(parentView, UIViewTransitionAnimation.RIGTH_TO_LEFT);					
				}
					
			}
		}
		public function AddViews(view:UISubView, viewID:String):void {
			
			if(viewsArray.length == 0){
				parentView = view;
				activeView = parentView;
				
				_navigationBar.title = parentView.name;
				this.addChildAt(parentView, 0);
			}
						
			view.id = viewID;
			view.performSegueWithIdentifierHandler = PerformSegueWithIdentifier;
			view.navigationBar = _navigationBar;
			view.subViewController = this;
			view.ReadyToBuildView();
			viewsArray.push(view);
			
			trace(" --[SubView Manager] - Add - " + viewID);
		}
		public function AddSegues(identifier:String, from:UIView, destinationView:UIView):void {
			from.addSegues(identifier, destinationView);
		}
		public function PerformSegueWithIdentifier(segueIdentifier:String, sender:UIView, destinationView:UIView):void {
			sender.prepareForSegue(segueIdentifier, destinationView);
			goToView(destinationView, "rightToLeft");
		}
		public function ResetSequencesView():void {
			arraySequenceOfViews = new Array();
		}
		public function backToLastView():void {
			//volta para a ultima tela na fila de sequencia
			const destinationView:UIView = ViewWithIdentifier(arraySequenceOfViews[arraySequenceOfViews.length-1]) as UIView			
			returnView(destinationView);
		}
		public function mainView():void {
			goToView(parentView, UIViewTransitionAnimation.LEFT_TO_RIGTH);
		}
		public function goToView(destinationView:UIView, _animationType:String):void {
			if(!changingView){
				//Se não repetir a tela
				if(destinationView != activeView){
					changingView = true;
					
					//view anterior é a que estava
					lastView = activeView;
					activeView = destinationView;
					activeView.visible = true;
					
					activeView.subViewParent = lastView;
					arraySequenceOfViews.push(lastView.id);
					
					/*
					viewBar.rightItem.image = null;
					viewBar.onClickRightItem = null;
					*/
					
					blockScreen.graphics.clear();
					blockScreen.graphics.beginFill(0);
					blockScreen.graphics.drawRect(0, 0, Capabilities.GetWidth(), Capabilities.GetHeight());
					blockScreen.graphics.endFill();
					blockScreen.alpha = 0;
					this.addChildAt(blockScreen, this.getChildIndex(lastView) + 1);
					TweenLite.killTweensOf(blockScreen);
					TweenLite.to(blockScreen, 0.5, {alpha: 0.3, ease: Expo.easeOut});
					
					this.addChildAt(activeView, this.getChildIndex(lastView) + 2);
				
					switch(_animationType){
						case UIViewTransitionAnimation.FADE_OUT:
							activeView.alpha = 0;				
							TweenLite.to(activeView, 0.5, {alpha: 1, onStart: onStart, onComplete: onComplete});
						break;
						case UIViewTransitionAnimation.PAGED:
							//se a tela anterior estiver na esquerda - animar da direita p/ esquerda
							const factor:Number = (lastView.page > activeView.page) ? -1.5 : 1.5;
							destinationView.x = Capabilities.GetWidth() * factor;
							TweenLite.to(activeView, 0.5, {x: 0, alpha: 1, ease: Expo.easeOut, onStart: onStart, onComplete: onComplete});							
						break;
						case UIViewTransitionAnimation.RIGTH_TO_LEFT:
							destinationView.x = Capabilities.GetWidth() * 1.5;
							TweenLite.to(activeView, 0.5, {x: 0, alpha: 1, ease: Expo.easeOut, onStart: onStart, onComplete: onComplete});
						break;
						case UIViewTransitionAnimation.LEFT_TO_RIGTH:
							destinationView.x = Capabilities.GetWidth() * -1.5;
							TweenLite.to(activeView, 0.5, {x: 0, alpha: 1, ease: Expo.easeOut, onStart: onStart, onComplete: onComplete});
						break;
					}
				}
				else{
					changingView = false;
					activeView.StartAwake();
					activeView.Start();
				}
			}			
		}
		private function returnView(destinationView:UIView):void {
			if(!changingView){
				changingView = true;
				
				//remove a ultima view na lista de telas navegadas
				arraySequenceOfViews.pop();
				
				(activeView as UISubView).willMoveToParentViewController(destinationView);
				//view anterior é a que estava
				lastView = activeView;
				//nova view é a anterior
				activeView = destinationView;
				activeView.x = 0;
				if(this.getChildIndex(lastView) - 1 > 0){
					this.addChildAt(activeView, this.getChildIndex(lastView) -1);
				}
				else {
					this.addChildAt(activeView, 0);
				}				
				
				TweenLite.to(lastView, 0.5, {x: Capabilities.GetWidth(), alpha: 1, ease: Expo.easeOut, onStart: onStart, onComplete: onComplete});
				
				blockScreen.graphics.clear();
				blockScreen.graphics.beginFill(0);
				blockScreen.graphics.drawRect(0, 0, Capabilities.GetWidth(), Capabilities.GetHeight());
				blockScreen.graphics.endFill();
				blockScreen.alpha = 0.7;
				this.addChildAt(blockScreen, this.getChildIndex(activeView) +1);
				TweenLite.killTweensOf(blockScreen);
				TweenLite.to(blockScreen, 0.7, {alpha: 0, ease: Expo.easeOut});
			}
		}
		private function onStart():void {
			/*
			viewBar.onClickRightItem = null;
			viewBar.rightItem.enabled = true;
			*/
			
			
			
			if(activeView != parentView && arraySequenceOfViews.length >0)			
				_navigationBar.leftItem.visible = true;			
			else
				_navigationBar.leftItem.visible = false;
			
			_navigationBar.visible = true;
			_navigationBar.title = activeView.name;
			
			lastView.StopAwake();	
			activeView.StartAwake();
			
			//verifica orientação da tela
			//DeviceScreenManager.CheckViewOrientation(activeView);
			
			checkAwakeViews();
		}
		private function onComplete():void {
			trace("[SubViewView Manager] - Navegated - " + activeView.name);
			
			changingView = false;
			
			checkViews();
			
			lastView.Stop();
			activeView.Start();
			
			this.removeChild(lastView);
			this.removeChild(blockScreen);
		}
		private function checkAwakeViews():void {
			
		}
		private function checkViews():void {
			
		}
		private function ViewWithIdentifier(viewID:String):UIView {
			for(var i:int = 0; i < viewsArray.length; i++){
				if(viewsArray[i].id == viewID){
					return viewsArray[i];
				}
			}
			throw new Error("Não achou o item: " + viewID);
			return viewsArray[0];
		}
		
		public function get navigationBar():UINavigationBar { return _navigationBar; }

	}
	
}
