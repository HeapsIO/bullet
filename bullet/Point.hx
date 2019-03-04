package bullet;

@:forward
abstract Point(h3d.col.Point) from h3d.col.Point to h3d.col.Point {
	public inline function new(x=0.,y=0.,z=0.) {
		this = new h3d.col.Point(x,y,z);
	}

	public inline function assign( v : Native.Vector3 ) {
		this.set(v.x(), v.y(), v.z());
	}

	@:from static inline function fromVec3( v : Native.Vector3 ) {
		return new Point(v.x(), v.y(), v.z());
	}

	@:to inline function toVec3() : Native.Vector3 {
		return new Native.Vector3(this.x,this.y,this.z);
	}
}