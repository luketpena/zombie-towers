function hit(_target) {
	if (is_callable(_target.shove)) {
		var _hitDir = point_direction(x, y, _target.x, _target.y);
		_target.shove(_hitDir, 15);
	}
}

event_inherited();

alarm[0] = 5;