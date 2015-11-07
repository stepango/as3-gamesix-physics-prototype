package
{
	import com.actionsnippet.qbox.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import org.casalib.display.CasaSprite;

	/**
	 * ...
	 * @author Sone
	 */

	//[SWF(width = "640", height = "480", backgroungColor = "0xFFFFFFFF", frameRate = "60")]

	public class Main extends CasaSprite
	{

		private var sim:QuickBox2D;

		private var gameArea:GameArea;
		private var mainHeroController:MainHeroController;
		CONFIG::debug {
			private var time:int;
			private var prevTime:int = 0;
			private var fps:int;
			private var fps_txt:TextField;
			private var drawTime:int = 0;
		}

		public function Main():void
		{
			init();
			gameArea = new GameArea(sim, stage, this);
			mainHeroController = new MainHeroController(sim, stage, gameArea.hero);
			mainHeroController.init();
			sim.start();
			CONFIG::debug{
				sim.mouseDrag();
				fps_txt = new TextField();
				fps_txt.x = 100;
				fps_txt.y = 100;
				addChild(fps_txt);
				//
				addEventListener(Event.ENTER_FRAME, getFps);
			}
		}

		private function init():void {
			stage.focus = this;
			initPhisics();
		}

		private function initPhisics():void {
			sim = new QuickBox2D(this, { gravityY: 10, timeStep: 1 / 60, iterations: 10, frim: false } );
		}
		CONFIG::debug{
			private function getFps(e:Event):void{
				//
				time = getTimer();
				fps = 1000 / (time - prevTime);
				//
				drawTime++;
				if (drawTime == 60){
					fps_txt.text = "fps: " + fps;
					drawTime = 0;
				}
				//
				prevTime = getTimer();
			}
		}
	}
}

