package bullet;

@:enum abstract Axis(Int) {
	var X = 0;
	var Y = 1;
	var Z = 2;
}

abstract Shape(Native.CollisionShape) {

	inline function new(v) {
		this = v;
	}

	inline function getInstance() {
		return this;
	}

	public static function createBox( sizeX : Float, sizeY : Float, sizeZ : Float ) : Shape {
		var vec3 = new Native.Vector3(sizeX * 0.5, sizeY * 0.5, sizeZ * 0.5);
		var sh = new Shape(new Native.BoxShape(vec3));
		vec3.delete();
		return sh;
	}

	public static function createSphere( radius : Float ) : Shape {
		return new Shape(new Native.SphereShape(radius));
	}

	public static function createCapsule( axis : Axis, radius : Float, length : Float ) : Shape {
		throw "TODO";
	}

	public static function createCylinder( axis : Axis, sizeX : Float, sizeY : Float, sizeZ : Float ) : Shape {
		var vec3 = new Native.Vector3(sizeX * 0.5, sizeY * 0.5, sizeZ * 0.5);
		var sh = new Shape(switch( axis ) {
		case X: new Native.CylinderShapeX(vec3);
		case Y: new Native.CylinderShape(vec3);
		case Z: new Native.CylinderShapeZ(vec3);
		});
		vec3.delete();
		return sh;
	}

	public static function createCone( axis : Axis, radius : Float, length : Float ) : Shape {
		throw "TODO";
	}

	public static function createCompound( shapes : Array<{ shape : Shape, mass : Float, position : h3d.col.Point, rotation : h3d.Quat }> ) {
		var comp = new Native.CompoundShape(true);
		for( s in shapes ) {
			var tr = new Native.Transform(new Native.Quaternion(s.rotation.x, s.rotation.y, s.rotation.z, s.rotation.w), new Native.Vector3(s.position.x, s.position.y, s.position.z));
			comp.addChildShape(tr,s.shape.getInstance());
		}
		return { shape : new Shape(comp), rotation : new h3d.Quat(), position : new h3d.col.Point() };
	}

}
