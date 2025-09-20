playerSlot = 0;
aimDirection = 0;
moveDirection = 0;
hp = 100;
function heal(_amount) {
	hp = min(hp + _amount, 100);
}

function damage(_amount) {
	hp = max(hp - _amount, 0);	
}

phy_fixed_rotation = true;

vTargetX = 0;
vTargetY = 0;
vAccel = 10;

focusPos = new Pos(x, y);

stats = {
	moveSpeed: 1.5,
	runSpeed: 3
}

running = false;
staminaSet = seconds(8);
stamina = staminaSet;

weapon = initWeaponry();
weapon.equip(WeaponValue.Bazooka, 0);
weapon.equip(WeaponValue.AK47, 1);

// Alerts enemies nearby when you are running
runningSoundTimerSet = seconds(.5);
runningSoundTimer = runningSoundTimerSet;

// Building
isBuilding = false;
buildIsClear = false;
buildPos = new Pos();

pickupRange = 24;
closestPickup = noone;
function checkForPickup() {
	var _nearest = instance_nearest(x, y, prnt_grab);
	if (_nearest) {
		var _dis = point_distance(x, y, _nearest.x, _nearest.y);
		if (_dis < pickupRange) {
			_nearest.active = true;
			if (gamepad_button_check_pressed(0, gp_face3)) {
				
				instance_create_layer(x, y, "Instances", prnt_weaponPickup, {
					weaponString: weaponValueToString(weapon.currentWeapon().stats.weaponValue)
				});
				weapon.equip(_nearest.weaponValue, weapon.equippedSlot);
				instance_destroy(_nearest);
			}
		}
	}
}