
class Main extends hxd.App {

	var world : bullet.World;

	override function init() {
		world = new bullet.World(s3d);
		world.setGravity(0,0,-9.81);

		var floor = new bullet.Body(bullet.Shape.createBox(100,100,1),0, world);
		var mesh = floor.initObject();
		mesh.material.color.setColor(0x800000);

		new h3d.scene.fwd.DirLight(new h3d.Vector(1, 2, -4), s3d);

		var shapes = [bullet.Shape.createSphere(0.5), bullet.Shape.createBox(1,1,1)];
		for( i in 0...100 ) {
			var id = Std.random(shapes.length);
			var b = new bullet.Body(shapes[id], 0.5, world);
			var m = b.initObject();
			m.x = Math.random() * 10;
			m.y = Math.random() * 10;
			m.z = 10 + Math.random() * 10;
			b.loadPosFromObject();


			var mt = new h3d.Matrix();
			mt.identity();
			mt.colorHue(Math.random() * Math.PI * 2);
			m.material.color.set(0.5, 0.3, 0);
			m.material.color.transform(mt);
		}

		new h3d.scene.CameraController(80, s3d);
	}

	override function update(dt:Float) {
		world.stepSimulation(dt, 10);
		world.sync();
		// check correct memory gc
		for( i in 0...1000 )
			bullet.Shape.createSphere(0.5);
	}

	static function main() {
		new Main();
	}

}