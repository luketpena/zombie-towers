type = choose(AmmoType.Bullets, AmmoType.Shells);

switch(type) {
	case AmmoType.Bullets:
		sprite_index = s_test_ammo_bullets;
		break;
	case AmmoType.Shells:
		sprite_index = s_test_ammo_shells;
		break;
}

function pickup(_target) {
	var _max = _target.weapon.ammo.getMax(type);
	var _ammoCount = round(_max * .1);
	_target.weapon.ammo.add(type, _ammoCount);
}