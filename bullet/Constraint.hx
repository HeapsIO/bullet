package bullet;

class Constraint {

	var cst : Native.TypedConstraint;
	public var world(default,null) : World;
	public var disableCollisionsBetweenLinkedBodies(default, set) : Bool = false;

	function new( cst, ?world : World ) {
		this.cst = cst;
		if( world != null ) addTo(world);
	}

	public function addTo( world : World ) {
		if( this.world != null ) remove();
		@:privateAccess world.addConstraint(this);
	}

	public function remove() {
		if( world == null ) return;
		@:privateAccess world.removeConstraint(this);
	}

	public function delete() {
		cst.delete();
	}

	function set_disableCollisionsBetweenLinkedBodies(b) {
		if( disableCollisionsBetweenLinkedBodies == b ) return b;
		disableCollisionsBetweenLinkedBodies = b;
		var w = world;
		if( w != null ) {
			remove();
			addTo(w);
		}
		return b;
	}

}
