hit = function(_target) {
	var _hitDirection = point_direction(x, y, _target.x, _target.y);
	_target.shove(_hitDirection, 10);
}

event_inherited();
alarm[0] = 30;

