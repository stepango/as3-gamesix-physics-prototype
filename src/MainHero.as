package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import com.actionsnippet.qbox.QuickBox2D;
	import com.actionsnippet.qbox.QuickObject;
	/**
	 * ...
	 * @author Sone
	 */
	public class MainHero
	{

		private var sim:QuickBox2D;
		private var wheel1:QuickObject, wheel2:QuickObject, wheel3:QuickObject;
		private var engine1:QuickObject, engine2:QuickObject, engine3:QuickObject;
		private var mainCircle:QuickObject, faceCircle: QuickObject;
		private var mainGroup:QuickObject;
		private var joint:b2RevoluteJoint;
		private var partArray:Array;

		private const WHEEL_SPEED:Number = 40;
		private const GROUPE_INDEX:Number = -123;
		private const MAIN_CIRCLE_RADIUS:Number = 0.5;
		private const WHEEL_RADIUS:Number = 0.3;
		private const WHEEL_FRICTION:Number = 2;
		private const WHEEL_JOINT_RADIUS:Number = 1;
		private const MAX_MOTOR_TORQUE:Number = 100;
		private const wheel1PosX:Number = 0, wheel1PosY:Number =  -1 * WHEEL_JOINT_RADIUS;
		private const wheel2PosX:Number = Math.sin(3/Math.PI) * WHEEL_JOINT_RADIUS, wheel2PosY:Number = 0.5 * WHEEL_JOINT_RADIUS;
		private const wheel3PosX:Number = -Math.sin(3/Math.PI) * WHEEL_JOINT_RADIUS, wheel3PosY:Number = 0.5 * WHEEL_JOINT_RADIUS;

		private var leftForce:b2Vec2 = new b2Vec2( -40, 10), rightForce:b2Vec2 = new b2Vec2(40, 10);

		public function MainHero(qBox:QuickBox2D, posX:Number, posY:Number)
		{
			sim = qBox;
			create(posX, posY);
		}

		public function create(posX:Number, posY:Number):void {
			mainCircle = sim.addCircle( { x:posX, y:posY, radius:MAIN_CIRCLE_RADIUS , lineAlpha:0 , fillAlpha:0 , groupIndex: GROUPE_INDEX , density: 2} );
			faceCircle = sim.addCircle( { x:posX, y:posY, radius:MAIN_CIRCLE_RADIUS , skin:Face , groupIndex: GROUPE_INDEX , fixedRotation:true, density: 0.01} );
			sim.addJoint({type:"revolute", a:faceCircle.body, b:mainCircle.body});
			wheel1 = sim.addCircle( { x:posX + wheel1PosX, y:posY + wheel1PosY, radius:WHEEL_RADIUS , friction:WHEEL_FRICTION, allowSleep:true, groupIndex: GROUPE_INDEX, skin:Wheel} );
			wheel2 = sim.addCircle( { x:posX + wheel2PosX, y:posY + wheel2PosY, radius:WHEEL_RADIUS , friction:WHEEL_FRICTION, allowSleep:true, groupIndex: GROUPE_INDEX, skin:Wheel} );
			wheel3 = sim.addCircle( { x:posX + wheel3PosX, y:posY + wheel3PosY, radius:WHEEL_RADIUS , friction:WHEEL_FRICTION, allowSleep:true, groupIndex: GROUPE_INDEX, skin:Wheel} );
			engine1 = sim.addJoint( { type:"revolute" , x1:wheel1.x, y1:wheel1.y, a:mainCircle.body, b:wheel1.body, enableMotor:true , maxMotorTorque: MAX_MOTOR_TORQUE } );
			engine2 = sim.addJoint( { type:"revolute" , x1:wheel2.x, y1:wheel2.y, a:mainCircle.body, b:wheel2.body, enableMotor:true , maxMotorTorque: MAX_MOTOR_TORQUE } );
			engine3 = sim.addJoint( { type:"revolute" , x1:wheel3.x, y1:wheel3.y, a:mainCircle.body, b:wheel3.body, enableMotor:true , maxMotorTorque: MAX_MOTOR_TORQUE } );
			partArray = new Array(mainCircle, wheel1, wheel2 , wheel3)
		}

		private function setWheelsSpeed(speed:Number):void {

			joint = engine1.joint as b2RevoluteJoint;
			joint.SetMotorSpeed(speed);

			joint = engine2.joint as b2RevoluteJoint;
			joint.SetMotorSpeed(speed);

			joint = engine3.joint as b2RevoluteJoint;
			joint.SetMotorSpeed(speed);
		}

		private function addForce(force: b2Vec2, offsetY:Number):void {
			mainCircle.body.ApplyForce(force, new b2Vec2(mainCircle.x, mainCircle.y + offsetY));
		}

		public function getMainHeroBodies():Array {
			return partArray;
		}

		public function setLinearVelocity(vec:b2Vec2):void {
			for (var i:int = 0; i < partArray.length; i++) {
				partArray[i].body.SetLinearVelocity(vec);
			}
		}

		public function moveLeft():void {
			setWheelsSpeed( -WHEEL_SPEED);
			addForce(leftForce, -0.05);
		}

		public function moveRight():void {
			setWheelsSpeed(WHEEL_SPEED);
			addForce(rightForce, 0.05);
		}

		public function stop():void {
			setWheelsSpeed(0);
		}
		
		public function get x():Number {
			return mainCircle.x;
		}
		
		public function get y():Number {
			return mainCircle.y;
		}
		
		public function get centerBody():b2Body {
			return mainCircle.body;
		}
	}
}
