package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.actionsnippet.qbox.QuickBox2D;
	import com.actionsnippet.qbox.QuickContacts;
	import com.actionsnippet.qbox.QuickObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import org.casalib.util.ArrayUtil;
	import Package21_fla.Explosion3_4;
	
	/**
	 * ...
	 * @author Sone
	 */
	public class GameArea
	{
		private var expObjects:Array;
		private var environment:Array;
		private var sim:QuickBox2D;
		private var mainHero:MainHero;
		private var stage:Stage;
		private var contacts:QuickContacts;
		private var screen:Sprite;
		private var score:int;
		private var blows:Array;

		public function GameArea(qBox:QuickBox2D, s:Stage, c:Sprite)
		{
			expObjects = new Array();
			environment = new Array();
			sim = qBox;
			stage = s;
			screen = c;
			score = 0;
			init();
		}

		private function init():void {
			environment.push(sim.addCircle( { x:13, y:13, density: 0.0 } ));
			environment.push(sim.addCircle( { x:12, y:13, density: 0.0 } ));
			environment.push(sim.addBox( { x:1, y:17, width:50, height:3, density:0.0, skin:AnimatedBox } ));
			environment.push(sim.addBox( { x: -15, y:0, width:1, height:50, density:0.0 } ));
			environment.push(sim.addBox( { x:15, y:0, width:1, height:50, density:0.0 } ));
			mainHero = new MainHero(sim, 7, 14);
			expObjects.push(new BadGuy(sim, expObjects, 9, 9));
			stage.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			contacts = sim.addContactListener();
			contacts.addEventListener(QuickContacts.ADD, onAdd, false,0,true);
		}

		public function get mainHeroBody():Array {
			return mainHero.getMainHeroBodies();
		}

		public function get hero():MainHero {
			return mainHero;
		}

		private function update(e:Event):void {
			
			for (var i:int = 0; i < expObjects.length; i++ ) {
				if (expObjects[i] != null){
					expObjects[i].update();
				}
			}
			var cart:b2Body = mainHero.centerBody;
			screen.x = 320 - (mainHero.x * QuickBox2D.SCALE) *0.65;
			screen.y = (400 - mainHero.y * QuickBox2D.SCALE) *0.65;
		}

		private function onAdd(e:Event):void {
			for (var i:int = 0; i<expObjects.length; i++){
				var box:ExpObject = expObjects[i];
				if(box != null){
					var qObject:QuickObject = box.quickObject;
					var bodies:Array = mainHero.getMainHeroBodies();
					for (var j:int = 0; j < bodies.length; j++ ) {
						var mainHeroBody:QuickObject = bodies[j];
						if (contacts.isCurrentContact(qObject, mainHeroBody)){
							mainHero.setLinearVelocity(box.expVector);
							animateExplosion(qObject.x, qObject.y);
							qObject.destroy();
							delete expObjects[i];
							expObjects[i] = null;
						}
					}
				}
			}
			if (ArrayUtil.contains(expObjects, null)) {
				ArrayUtil.removeItem(expObjects, null);
			}
		}

		private function animateExplosion(x:Number, y:Number):void {
			var exp1:Explosion3_4 = new Explosion3_4();
			exp1.x = x * QuickBox2D.SCALE;
			exp1.y = y * QuickBox2D.SCALE;
			exp1.name = "blow";
			screen.addChild(exp1);
		}
	}
}

