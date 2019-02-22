package bullet;

typedef Native = haxe.macro.MacroType<[webidl.Module.build({ idlFile : "bullet/bullet.idl", chopPrefix : "bt", autoGC : true, nativeLib : "bullet" })]>;
