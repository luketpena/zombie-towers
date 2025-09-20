active = CONFIG.spawners_active;
gameRound = 0;
mobCountStart = 100;
mobCountPerRound = 0;
mobNextRoundThreshold = 3;

function getRandomSpawner() {
	var _spawnerIndex = irandom_range(1, instance_number(o_spawnPoint)) - 1;
	return instance_find(o_spawnPoint, _spawnerIndex);
}