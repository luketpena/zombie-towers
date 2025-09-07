enum Awareness {
	Unaware, // Idling, doesn't know where player is
	Active, // Has line of sight, is moving towards the player
	Hunting // No longer has line of sight, is moving to last known location
}

function notifyRadius(_x, _y, _source, _radius) {
	var _enemiesInRadius = ds_list_create();
	collision_circle_list(_x, _y, _radius, prnt_enemy, false, true, _enemiesInRadius, false);
	var _count = ds_list_size(_enemiesInRadius);
	if (_count > 0) {
		for (var i=0; i<_count; i++) {
			var _enemy = _enemiesInRadius[| i];
			_enemy.notify(_source);
		}
	}
}