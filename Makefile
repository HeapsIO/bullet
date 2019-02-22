genhl:
	haxe -lib webidl --macro "bullet.Generator.generateCpp()"
	
genjs:
	haxe -lib webidl --macro "bullet.Generator.generateJs()"
