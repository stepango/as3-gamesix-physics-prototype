package
{
	import com.actionsnippet.qbox.QuickBox2D;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Sone
	 */
	public class MainHeroController
	{
		private var sim:QuickBox2D;
		private var mainHero:MainHero;
		private var stage:Stage;
		private var controlPoint:Boolean = true; // needed for better control

		public function MainHeroController(qBox:QuickBox2D, s:Stage, hero:MainHero) {
			sim = qBox;
			stage = s;
			mainHero = hero;
		}
		
		public function init():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false,0,true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false,0,true);
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			if(e.keyCode == Keyboard.RIGHT){
				mainHero.moveRight();
				controlPoint = true;
			}
			if(e.keyCode == Keyboard.LEFT){
				mainHero.moveLeft();
				controlPoint = true;
			}
		}

		private function onKeyUp(e:KeyboardEvent):void {
			if (controlPoint){
				if((e.keyCode == Keyboard.LEFT)||(e.keyCode == Keyboard.RIGHT) ){
					mainHero.stop();
					controlPoint = false;
				}
			}
		}
	}
}

