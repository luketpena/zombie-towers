phy_fixed_rotation = true;

hp = 5;
awareness = Awareness.Unaware;

moveSpeedLerp = random(1)
moveSpeed = lerp(.5, 1, moveSpeedLerp);
currentSpeed = 0;
moveDirection = random(360);
target = noone;
distanceToTarget = 0;
hasLineOfSight = false;
viewAngle = 45;
viewDistance = 400;
viewTargetList = ds_list_create();
viewCheckTimerSet = [seconds(.25), seconds(2)];
viewCheckTimer = irandom_range(viewCheckTimerSet[0], viewCheckTimerSet[1]);
velocitySlowRate = .8;

// Attack
attackCooldown = 0;

// Stun
stunTimer = 0;
stunned = false;
function stun(_duration) {
	stunTimer = _duration;	
}

face = 1;

/* PATH */
myPath = -1;
pathActive = false;
pathEndX = x;
pathEndY = y;
// Wobble makes the path wave back and forth
pathWobbleRate = random_range(1, 5);
pathWobble = random(360);
pathWobbleDistance = random_range(10, 40);
pathWobbleOffset = 0;

// Move-patience lets them "give up" if they are continually blocked from moving to their path-goal
movePatienceSet = 3 * 60;
movePatience = movePatienceSet;

// Velocity target = how fast the char wants to move
vTargetX = 0;
vTargetY = 0;
vAccel = 10; // Rate of acceleration towards target velocity
isMoving = false;

// Wandering around while idle
inTheZone = false;
wanderTimerSet = [seconds(2), seconds(16)];
wanderTimer = 0;
wanderPatienceSet = seconds(30); // How long it wanders before moving to the target zone
wanderPatience = wanderPatienceSet;

///@description Sets a path for a random point within the mob target zone
function moveToTargetZone() {
	var _pos = o_mobTargetZone.getPosition();
	while(!place_empty(_pos.x, _pos.y, prnt_block)) {
		_pos = o_mobTargetZone.getPosition();
	}
	createNewPath(_pos.x, _pos.y);
}

///@description Inflict damage, notify other NPCs in radius
function damage(_dmg, _source = noone) {
	hp -= _dmg;
	// If damage has source, set source and notify all in radius
	if (_source != noone) notifyRadius(x, y, _source, 48);
	// If damage pushed HP at or below 0, then KO the NPC
	if (hp <= 0) ko();
}

///@description Kill the NPC
function ko() {
	var _spawnPickup = roll(5);
	if (_spawnPickup) {
		instance_create_layer(x, y, "l_pickups", choose(o_pickup_ammo, o_pickup_medpack));	
	}
	global.ecto += ectoValue;
	instance_destroy();	
}

///@description Push the NPC in a direction
function shove(_direction, _strength) {
	var _vx = lengthdir_x(_strength, _direction);
	var _vy = lengthdir_y(_strength, _direction);
	physics_apply_impulse(phy_position_x, phy_position_y, _vx, _vy);	
}

///@description Sets a target and starts movement towards that target
function notify(_source, _overrideTarget = false) {
	if (target == noone || _overrideTarget) {
		target = _source;
		createNewPath(_source.x, _source.y);
		setAwareness(Awareness.Hunting);
	}
}

///@description Set the awareness level of the NPC
function setAwareness(_Awareness) {
	awareness = _Awareness;
	switch(_Awareness) {
		case Awareness.Active:
			pathActive = false;
			break;
		case Awareness.Unaware:
			target = noone;
			pathActive = false;
			break;
	}
}

///@description Move the NPC around to random locations within eyeline
function wander() {
	var _vx, _vy;
	var _attempts = 0;
	var _maxAttempts = 4;
	do {
		var _wanderDistance = random(128);
		var _wanderAngle = random(360);
		_vx = x + lengthdir_x(_wanderDistance, _wanderAngle);
		_vy = y + lengthdir_y(_wanderDistance, _wanderAngle);
		_attempts++;
	} until place_empty(_vx, _vy, prnt_block) || _attempts == _maxAttempts;
	if (_attempts != _maxAttempts) {
		createNewPath(_vx, _vy);
	}
}

// Looks to see if there is a viable target in line-of-sight
function lookForTarget() {
	// Detecting line of sight
	ds_list_clear(viewTargetList);
	collision_circle_list(x, y, viewDistance, o_player, false, true, viewTargetList, true);
	var _viewTargetListSize = ds_list_size(viewTargetList);
	// Test if target is in range
	if (_viewTargetListSize > 0) {
		// Test if targets exist
		for (var i=0; i<_viewTargetListSize; i++) {
			var _target = viewTargetList[| i];
			// Test if anything is in the way
			var _viewClear = collision_line(x, y, _target.x, _target.y, prnt_block, false, true) == noone;
			if (_viewClear) {
				// Test if target is within the view angle
				var _angleToTarget = abs(moveDirection - point_direction(x, y, _target.x, _target.y));
				if (_angleToTarget < viewAngle) {
					target = _target;
					setAwareness(Awareness.Active);
				}
			}
		}
	}	
}


///@description Create and begin to follow a new path
function createNewPath(_x, _y) {
	 // Delete old path
    if (path_exists(myPath)) path_delete(myPath);
    myPath = path_add();
	
    // Attempt to find path toward a point
    if (mp_grid_path(global.pathGrid, myPath, x, y, _x, _y, true)) {
		pathActive = true;
		movePatience = movePatienceSet;
		pathEndX = _x;
		pathEndY = _y;
        path_set_kind(myPath, path_action_stop);
        path_set_precision(myPath, 1);
		// Making sure the starting point is ahead at all times
		var _pathStartOffset = 32 / path_get_length(myPath);
        path_position = _pathStartOffset;
    }	
}

///@description Velocity target is 8, slow down current velocity by the rate
function stopVelocity(_velocitySlowRate = velocitySlowRate) {
	vTargetX = 0;
	vTargetY = 0;
	phy_linear_velocity_x *= _velocitySlowRate;	
	phy_linear_velocity_y *= _velocitySlowRate;	
}

///@description Set the target velocity for NPC movement
function setVelocityTarget(_vx, _vy) {
	vTargetX = _vx * 50; 
	vTargetY = _vy * 50; 	
}