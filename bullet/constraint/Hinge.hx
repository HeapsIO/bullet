package bullet.constraint;

@:hlNative("bullet")
class Hinge extends Constraint {

	var hg : Native.HingeConstraint;

	public function new( body : Body, pivot : Point, axis : Point, body2 : Body, pivot2 : Point, axis2 : Point, ?world : World ) {
		var pv : Native.Vector3 = pivot == null ? Body.zero : pivot;
		var pv2 : Native.Vector3 = pivot2 == null ? Body.zero : pivot2;
		var ax : Native.Vector3 = axis;
		var ax2 : Native.Vector3 = axis2;
		@:privateAccess hg = new Native.HingeConstraint(body.inst, cast body2.inst, cast pv, cast pv2, ax, ax2);
		if( pivot != null ) pv.delete();
		if( pivot2 != null ) pv2.delete();
		ax.delete();
		ax2.delete();
		super(hg, world);
	}

	public function setMotor( targetSpeed : Float, maxImpulse : Float ) {
		hg.enableAngularMotor(true,targetSpeed,maxImpulse);
	}

}
