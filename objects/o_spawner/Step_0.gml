var _mobCount = instance_number(prnt_enemy);

if (_mobCount < mobNextRoundThreshold) {
	gameRound++;
	var _mobsToSpawn = mobCountStart + (mobCountPerRound * gameRound);
	for (var i=0; i<_mobsToSpawn; i++) {
		var _spawner = getRandomSpawner();
		var _o = instance_create_layer(_spawner.x, _spawner.y, "Instances", o_zombie);
		_o.moveToTargetZone();
	}
}