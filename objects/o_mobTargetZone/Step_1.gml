var _list = ds_list_create();
collision_rectangle_list(x, y, r, b, prnt_enemy, false, true, _list, false);
var _length = ds_list_size(_list);

for (var i=0; i<_length; i++) {
	_list[| i].inTheZone = true;	
}
