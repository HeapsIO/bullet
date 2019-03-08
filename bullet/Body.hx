package bullet;

class Body {

	static inline var ACTIVE_TAG = 1;
	static inline var DISABLE_DEACTIVATION = 4;
	static inline var DISABLE_SIMULATION = 5;

	var state : Native.MotionState;
	var inst : Native.RigidBody;
	var _pos = new Point();
	var _vel = new Point();
	var _avel = new Point();
	var _q = new h3d.Quat();
	var _tmp = new Array<Float>();

	public var world(default,null) : World;

	public var shape(default,null) : Shape;
	public var mass(default,null) : Float;
	public var position(get,never) : Point;
	public var velocity(get,set) : Point;
	public var angularVelocity(get,set) : Point;
	public var rotation(get,never) : h3d.Quat;
	public var object(default,set) : h3d.scene.Object;
	public var alwaysActive(default,set) = false;

	public function new( shape : Shape, mass : Float, ?world : World ) {
		var inertia = new Native.Vector3(shape.inertia.x * mass, shape.inertia.y * mass, shape.inertia.x * mass);
		state = new Native.DefaultMotionState();
		var inf = new Native.RigidBodyConstructionInfo(mass, state, @:privateAccess shape.getInstance(), inertia);
		inst = new Native.RigidBody(inf);
		inertia.delete();
		inf.delete();
		this.shape = shape;
		this.mass = mass;
		_tmp[6] = 0.;
		if( world != null ) addTo(world);
	}

	function set_alwaysActive(b) {
		inst.setActivationState(b ? DISABLE_DEACTIVATION : ACTIVE_TAG);
		return alwaysActive = b;
	}

	function set_object(o) {
		if( object != null ) object.remove();
		object = o;
		if( object != null && object.parent == null && world != null && world.parent != null ) world.parent.addChild(object);
		return o;
	}

	public function addTo( world : World ) {
		if( this.world != null ) remove();
		@:privateAccess world.addRigidBody(this);
	}

	public function remove() {
		if( world == null ) return;
		@:privateAccess world.removeRigidBody(this);
	}

	public function setFriction( f ) {
		inst.setFriction(f);
	}

	public function setRollingFriction( f ) {
		inst.setRollingFriction(f);
	}

	public function addAxis( length = 1. ) {
		if( object == null ) throw "Missing object";
		var g = new h3d.scene.Graphics(object);
		g.lineStyle(1,0xFF0000);
		g.lineTo(length,0,0);
		g.lineStyle(1,0x00FF00);
		g.moveTo(0,0,0);
		g.lineTo(0,length,0);
		g.lineStyle(1,0x0000FF);
		g.moveTo(0,0,0);
		g.lineTo(0,0,length);
		g.material.setDefaultProps("ui");
	}

	public function setTransform( p : Point, ?q : h3d.Quat ) {
		var t = inst.getCenterOfMassTransform();
		var v = new Native.Vector3(p.x, p.y, p.z);
		t.setOrigin(v);
		v.delete();
		if( q != null ) {
			var qv = new Native.Quaternion(q.x, q.y, q.z, q.w);
			t.setRotation(qv);
			qv.delete();
		}
		inst.setCenterOfMassTransform(t);
		inst.activate();
	}

	public function resetVelocity() {
		inst.setAngularVelocity(zero);
		inst.setLinearVelocity(zero);
		_vel.set(0,0,0);
		_avel.set(0,0,0);
		if( world != null ) @:privateAccess world.clearBodyMovement(this);
	}

	public function initObject() {
		if( object != null ) return object.toMesh();
		var o = new h3d.scene.Mesh(shape.getPrimitive());
		object = o;
		return o;
	}

	public function delete() {
		inst.delete();
		state.delete();
	}

	public function loadPosFromObject() {
		setTransform(new Point(object.x, object.y, object.z), object.getRotationQuat());
	}

	function get_position() {
		var t = inst.getCenterOfMassTransform();
		var p = t.getOrigin();
		_pos.assign(p);
		p.delete();
		return _pos;
	}

	function get_rotation() {
		var t = inst.getCenterOfMassTransform();
		var q = t.getRotation();
		var qw : Native.QuadWord = q;
		_q.set(qw.x(), qw.y(), qw.z(), qw.w());
		q.delete();
		return _q;
	}

	function get_velocity() {
		var v = inst.getLinearVelocity();
		_vel.assign(v);
		return _vel;
	}

	function set_velocity(v) {
		if( v != _vel ) _vel.load(v);
		var p = new Native.Vector3(v.x, v.y, v.z);
		inst.setLinearVelocity(p);
		p.delete();
		return v;
	}

	function get_angularVelocity() {
		var v = inst.getAngularVelocity();
		_avel.assign(v);
		return _avel;
	}

	function set_angularVelocity(v) {
		if( v != _avel ) _avel.load(v);
		var p = new Native.Vector3(v.x, v.y, v.z);
		inst.setAngularVelocity(p);
		p.delete();
		return v;
	}

	@:allow(bullet) static var zero = new Native.Vector3(0,0,0);

	/**
		Updated the linked object position and rotation based on physical simulation
	**/
	public function sync() {
		if( object == null ) return;
		var pos = position;
		object.x = pos.x;
		object.y = pos.y;
		object.z = pos.z;
		var q = rotation;
		object.getRotationQuat().load(q); // don't share reference
	}

}
