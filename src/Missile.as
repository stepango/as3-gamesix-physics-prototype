package  
{
	import Box2D.Common.Math.b2Vec2;
	import com.actionsnippet.qbox.QuickBox2D;
	import com.actionsnippet.qbox.QuickObject;
	/**
	 * ...
	 * @author Sone
	 */
	public class Missile implements ExpObject
	{
		private var sim:QuickBox2D;
		private var missile:QuickObject;
		
		public function Missile(qBox:QuickBox2D, x:Number , y:Number) 
		{
			sim = qBox;
			missile = sim.addCircle({radius:0.2, x:x , y:y, skin:AnimatedCircle});
		}
		
		public function get expVector():b2Vec2 {
			return new b2Vec2(Math.random() * 4 - 2, -12 + Math.random() * 4);
		}
		
		public function get price():int {
			return 10;
		}
		
		public function update():void { 
		}
		
		public function get quickObject():QuickObject {
			return missile;
		}
	}
}