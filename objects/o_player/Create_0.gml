playerSlot = 0;
aimDirection = 0;
moveDirection = 0;
hp = 100;
function heal(_amount) {
	hp = min(hp + _amount, 100);
}

phy_fixed_rotation = true;

vTargetX = 0;
vTargetY = 0;
vAccel = 10;

stats = {
	moveSpeed: 1.5,
	runSpeed: 3
}

running = false;
staminaSet = seconds(8);
stamina = staminaSet;

weapon = initWeaponry();
weapon.equip(WeaponValue.Shotgun, 0);
weapon.equip(WeaponValue.AK47, 1);

// Alerts enemies nearby when you are running
runningSoundTimerSet = seconds(.5);
runningSoundTimer = runningSoundTimerSet;

// Building
isBuilding = false;
buildIsClear = false;
buildPos = new Pos();