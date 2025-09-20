hit = function(_target) {
	//var _hitDirection = point_direction(x, y, _target.x, _target.y);
	// TODO: add shoving to players
	//_target.shove(_hitDirection, 10);
	//_target.hp -= 5;
	_target.damage(5);
}

event_inherited();
alarm[0] = 30;

