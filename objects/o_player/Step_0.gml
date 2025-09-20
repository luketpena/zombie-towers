// Movement
var _moveAxisH = gamepad_axis_value(playerSlot, gp_axislh);
var _moveAxisV = gamepad_axis_value(playerSlot, gp_axislv);
var _isMoving = abs(_moveAxisH) > 0 || abs(_moveAxisV) > 0;

if (gamepad_button_check_pressed(0, gp_shoulderl) && _isMoving && stamina > 0) {
	running = true;
	runningSoundTimer = runningSoundTimerSet;
}

if (running) {
	// Trigger mob notifications while running on an interval
	if (runningSoundTimer > 0) runningSoundTimer-- else {
		notifyRadius(x, y, self, 64);
		runningSoundTimer = runningSoundTimerSet;
	}
	
	if (stamina > 0 && _isMoving) stamina-- else {
		running = false;	
	}
} else {
	if (stamina < staminaSet) stamina = min(stamina + .75, staminaSet);
}

if (_isMoving) {
	// Move direction only set while moving
	moveDirection = point_direction(0, 0, _moveAxisH, _moveAxisV);
	var _aimMoveDiff = abs(angle_difference(moveDirection, aimDirection)) / 180;
	var _targetMoveSpeed = running ? stats.runSpeed : stats.moveSpeed;
	vTargetX = _targetMoveSpeed * _moveAxisH * 50; 
	vTargetY = _targetMoveSpeed * _moveAxisV * 50;
	
	vTargetX = lerp(vTargetX, vTargetX * .5, _aimMoveDiff);
	vTargetY = lerp(vTargetY, vTargetY * .5, _aimMoveDiff);
	
	var _vDiffX = vTargetX - phy_linear_velocity_x;
	var _vDiffY = vTargetY - phy_linear_velocity_y;
	
	var _vPushX = clamp(_vDiffX, -vAccel, vAccel);
	var _vPushY = clamp(_vDiffY, -vAccel, vAccel);
	
	phy_linear_velocity_x += _vPushX;
	phy_linear_velocity_y += _vPushY;
} else {
	phy_linear_velocity_x *= .8;	
	phy_linear_velocity_y *= .8;	
}


// Combat
var _aimAxisH = gamepad_axis_value(playerSlot, gp_axisrh);
var _aimAxisV = gamepad_axis_value(playerSlot, gp_axisrv);
var _isAiming = abs(_aimAxisH) > 0 || abs(_aimAxisV) > 0

// Aim direction defaults to moveDirection if not actively aiming
var _sourceAimDirection = _isAiming ? point_direction(0, 0, _aimAxisH, _aimAxisV) : moveDirection;
aimDirection = _sourceAimDirection;
focusPos.set(x + _aimAxisH * 128, y + _aimAxisV * 96);

// Swap weapon
if (gamepad_button_check_pressed(0, gp_face4)) {
	weapon.swap();
}

weapon.checkForFire(x, y, aimDirection, id);

// Building
isBuilding = gamepad_button_check(0, gp_shoulderl);
if (isBuilding) {
	buildPos.set(
		x + lengthdir_x(24, aimDirection),
		y + lengthdir_y(16, aimDirection)
	);
	buildIsClear = collision_rectangle(buildPos.x - 8, buildPos.y - 6, buildPos.x + 8, buildPos.y + 6, [prnt_block], false, true) == noone;
	if (buildIsClear && global.ecto >= 15 && gamepad_button_check_pressed(0, gp_shoulderr)) {
		global.ecto -= 15;
		instance_create_layer(buildPos.x, buildPos.y, "Instances", o_test_tower);
	}
}

checkForPickup()