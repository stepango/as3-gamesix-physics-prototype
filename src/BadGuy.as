package
{
	import Box2D.Common.Math.b2Vec2;
	import com.actionsnippet.qbox.QuickBox2D;
	import com.actionsnippet.qbox.QuickObject;
	/**
	 * ...
	 * @author Sone
	 */
	public class BadGuy implements ExpObject
	{

		private var sim:QuickBox2D;
		private var badGuy:QuickObject;
		private var speed:b2Vec2;
		private var attackTimer:Number;
		private var bombs:Array;

		public function BadGuy(qBox:QuickBox2D, expArray:Array, posX:Number, posY:Number)
		{
			sim = qBox;
			create(posX, posY, new b2Vec2(15, 10));
			speed = new b2Vec2(0.1, 10);
			attackTimer = 60;
			bombs = expArray;
		}

		public function create(posX:Number, posY:Number, vec:b2Vec2):void {
			badGuy = sim.addBox( { x:posX, y:posY , width:1.5, height: 0.5, density: 0.0, skin:AnimatedBox} );
		}

		public function update():void {
			if (badGuy.body != null){
				badGuy.body.SetXForm(new b2Vec2(badGuy.x + speed.x, badGuy.y), 0);
				if (badGuy.x > 20) {
					speed.x = -0.1;
				}
				if (badGuy.x < 1) {
					speed.x = 0.1;
				}
				attackTimer--;
				if (attackTimer < 0) {
					attackTimer = 60;
					bombs.push(new Missile(sim, badGuy.x, badGuy.y + 0.5));
				}
			}
		}

		public function get badGuyQObject():QuickObject {
			return badGuy;
		}

		public function get expVector():b2Vec2 {
			return new b2Vec2(Math.random() * 4 - 2, -14 + Math.random() * 4);
		}

		public function get price():int {
			return 100;
		}

		public function get quickObject():QuickObject{
			return badGuy;
		}
	}
}

