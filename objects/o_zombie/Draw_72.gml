var _moveDirectionX = lengthdir_x(1, moveDirection);
switch(face) {
	case 1:
		if (_moveDirectionX < -.1) face = -1;
		break;
	case -1:
		if (_moveDirectionX > .1) face = 1;
		break;
}

if (isMoving) {
	sprite_index = s_test_zombie_walk;
	image_speed = lerp(1, 1.5, moveSpeedLerp);
} else {
	sprite_index = s_test_zombie_stand;
	image_speed = 1;
}
