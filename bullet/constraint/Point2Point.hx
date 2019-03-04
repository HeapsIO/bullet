package bullet.constraint;

@:hlNative("bullet")
class Point2Point extends Constraint {

	var p2p : Native.Point2PointConstraint;

	public function new( body : Body, ?pivot : Point, ?body2 : Body, ?pivot2 : Point, ?world : World ) {
		var pv : Native.Vector3 = pivot == null ? Body.zero : pivot;
		var pv2 : Native.Vector3 = pivot2 == null ? Body.zero : pivot2;
		@:privateAccess if( body2 == null )
			p2p = new Native.Point2PointConstraint(body.inst, pv);
		else
			p2p = new Native.Point2PointConstraint(body.inst, body2.inst, pv, pv2);
		if( pivot != null ) pv.delete();
		if( pivot2 != null ) pv2.delete();
		super(p2p, world);
	}

}
