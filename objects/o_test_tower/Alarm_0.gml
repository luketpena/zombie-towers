if (!CONFIG.towers_active) exit;

var _list = ds_list_create();
collision_circle_list(x, y, radius, prnt_enemy, false, true, _list, true);

var _len = ds_list_size(_list);
for (var i=0; i<_len; i++) {
	var _target = _list[| i];
	var _hasLineOfSight = collision_line(x, y, _target.x, _target.y, prnt_block, false, true) == noone;
	if (_hasLineOfSight) {
		instance_create_layer(x, y, "Instances", prnt_bullet, {
			moveDirection: point_direction(x, y, _target.x, _target.y)
		});
		break;
	}
}

ds_list_destroy(_list);
alarm[0] = alarmSet;