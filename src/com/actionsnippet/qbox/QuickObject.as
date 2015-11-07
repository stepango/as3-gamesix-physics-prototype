﻿package com.actionsnippet.qbox{	import flash.display.*;	import flash.events.*;	import Box2D.Dynamics.*;	import Box2D.Collision.*;	import Box2D.Collision.Shapes.*;	import Box2D.Common.Math.*;	import Box2D.Dynamics.Joints.*;    /**	The QuickObject class wraps nearly all the Box2D classes neccessary for rigid body instantiation - such as b2BodyDef, b2Body, b2Shape and b2DistanceJointDef. The QuickObject class also wraps a few properties of b2Body to enable easy alteration of position and rotation.		There is no need to instantiate a QuickObject directly. You should use the QuickBox2D add methods:	{@link com.actionsnippet.qbox.QuickBox2D#addBox()}	{@link com.actionsnippet.qbox.QuickBox2D#addCircle()}	{@link com.actionsnippet.qbox.QuickBox2D#addPoly()}	{@link com.actionsnippet.qbox.QuickBox2D#addGroup()}	{@link com.actionsnippet.qbox.QuickBox2D#addJoint()}		@author Zevan Rosser	@version 1.0	*/	public class QuickObject {        /** The b2BodyDef for this QuickObject. */		public var bodyDef:b2BodyDef;				/** The b2Body for this QuickObject. This property is important as it gives access to all b2Body methods such as <code>ApplyImpulse()</code> and <code>ApplyForce()</code>. */		public var body:b2Body;				/** The b2Shape for this QuickObject. This property is dynamic - it is either an Array of b2Shape objects or a single b2Shape. For group objects this will be an array, for all other QuickObjects (including polygons) it will be a single b2ShapeDef.*/		public var shape:*;				/** The b2ShapeDef for this QuickObject. This property is dynamic - it is either an Array of b2ShapeDef objects or a single b2ShapeDef. For polygons and groups this will be an array, for all other QuickObjects it will be a single b2ShapeDef.*/		public var shapeDef:*;				/** The b2DistanceJoint if this QuickObject is a JointObject. */		public var joint:b2Joint;				private var loc:b2Vec2;				protected var defaults:Object;				public var params:Object;				protected var type:String;				protected var w:b2World;				protected var qbox:QuickBox2D;				/**		The userData property from the b2Body or b2Joint. This will usually be a DisplayObject populated by QuickBox2D.		*/        public function get userData():*{			return body.m_userData;		}				public function set userData(object:*):*{			body.m_userData = object;		}				// wrappers for position				/**		Sets the x and y location of the rigid body.		@param x The x location.		@param y The y location.		*/		public function setLoc(x:Number, y:Number):void{			loc.x = x;			loc.y = y;			body.SetXForm(loc, body.GetAngle());		}				/**		The x location of the rigid body.		*/		public function set x(val:Number):void{			loc = body.GetPosition();			loc.x = val;			body.SetXForm(loc, body.GetAngle());		}		public function get x():Number{			return body.GetPosition().x;		}				/**		The y location of the rigid body.		*/		public function set y(val:Number):void{			loc = body.GetPosition();			loc.y = val;			body.SetXForm(loc, body.GetAngle());		}				public function get y():Number{			return body.GetPosition().y;		}				/**		The angle of the rigid body.		*/		public function set angle(val:Number):void{			loc = body.GetPosition();			body.SetXForm(loc, val);		}		public function get angle():Number{			return body.GetAngle();		}				/**	    @exclude		*/		public function QuickObject(qbox:QuickBox2D, params:Object=null) {			init(qbox, params);		}        // template method		private final function init(qbox:QuickBox2D, params:Object=null):void {			this.qbox = qbox;						this.params=params;			            defineDefaults();			setDefaults();            // make sure we aren't a joint            if (params.vecA == null){			  setupBodyDef(params);			}			this.w  = qbox.w;						// template hook			 build();			 if (!qbox.debug){				   if (userData is DisplayObject){					 userData.x = params.x * QuickBox2D.SCALE;					 userData.y = params.y * QuickBox2D.SCALE;					 userData.rotation = params.angle / Math.PI * 180;				     qbox.main.addChild(userData);				   }			  }			 			 // make sure we aren't a joint			 if (body != null){				if (params.mass != null){					body.SetMassFromShapes();					var m:b2MassData = new b2MassData();					m.mass = params.mass;					m.center = body.GetLocalCenter();					m.I = body.m_I;					body.SetMass(m);				}else{					body.SetMassFromShapes();				}			 }		}        internal function handCursor():void{		    if (!qbox.debug){				   if (userData is DisplayObject){					 if (params.draggable == true && params.density != 0){						 userData.buttonMode = true; 					}				   }		    }		}		        // all bodyDefs are initialized the same way        private function setupBodyDef(p:Object):void{			bodyDef = new b2BodyDef();			if (!(p.skin is DisplayObject)){			bodyDef.position.x = p.x;			bodyDef.position.y = p.y;			bodyDef.angle = p.angle;			}else{			bodyDef.position.x = p.skin.x / QuickBox2D.SCALE;			bodyDef.position.y = p.skin.y / QuickBox2D.SCALE;			bodyDef.angle = p.skin.rotation * Math.PI/180;			}			loc = new b2Vec2(p.x, p.y);						bodyDef.linearDamping = p.linearDamping;			bodyDef.angularDamping = p.angularDamping;			bodyDef.fixedRotation = p.fixedRotation;			bodyDef.isBullet = p.isBullet;			bodyDef.isSleeping = p.isSleeping;			bodyDef.allowSleep = p.allowSleep;		}		        private function defineDefaults():void{			defaults = {x:3, y:3, linearDamping:0, angularDamping:0, isBullet:false,			                   fixedRotation:false,							   allowSleep: true, 							   isSleeping:false, 							   scaleSkin:true,		                       density:1.0, friction:0.5, restitution:0.2, angle:0.0, 							   maskBits:0xFFFF, categoryBits:1, groupIndex:0,							   draggable: true,						       lineColor:0x000000, lineAlpha:1,							   lineThickness:0,						       fillColor:0xCCCCCC, fillAlpha:1} 						// template hook			defaultParams(defaults);									// set any parameters that are default for the QuickBox2D instance			qbox.defaultParams(params);		}           // hook for Object Specific params		protected function defaultParams(p:Object):void{}				// hook for box2D initialization		protected function build():void {			trace("You must override the build() method of QuickObject");		}						 		/**		Destroys all composed Box2D instances (b2Shape, b2Body, b2Joint) and removes the DisplayObject associated with this QuickObject instance (if there is one). QuickObjects will only truly be destroyed at the end of the QuickBox2D internal loop - allowing for you to call this method inside of contact event listener functions.		*/		public final function destroy():void{		  		   qbox.destroyable.push(this);		}				/**	    @exclude		*/		public final function fullDestroy():void{			if (userData is DisplayObject){				if (userData.parent){					userData.parent.removeChild(userData);				}			}			if (shape is b2Shape){				body.DestroyShape(shape);				w.DestroyBody(body);				return;			}			if (joint){				w.DestroyJoint(joint as b2Joint);				return;			}			if (shape is Array){				var leng:int = shape.length;				for (var i:int= 0; i<leng; i++){					body.DestroyShape(shape[i]);				}				w.DestroyBody(body);				return;			}					}		private function setDefaults():void {			if (params==null) {				params = new Object();			}			for (var key:String in defaults) {				if (params[key]==null) {					params[key]=defaults[key];				}			}		}	}}