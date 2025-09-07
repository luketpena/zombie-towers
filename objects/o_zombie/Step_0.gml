var _lookActive = false;
if (viewCheckTimer > 0) viewCheckTimer-- else {
	viewCheckTimer = irandom_range(viewCheckTimerSet[0], viewCheckTimerSet[1]);
	_lookActive = true;
}

switch(awareness) {
	case Awareness.Unaware:
		if (!pathActive) {
			// If wandering outside of the zone for too long, return back after a while
			if (!inTheZone) {
				if (wanderPatience > 0) wanderPatience-- else {
					moveToTargetZone();	
				}
			}
			// Wandering around when idle
			if (wanderTimer > 0) wanderTimer-- else  {
				wanderTimer = irandom_range(wanderTimerSet[0], wanderTimerSet[1]);
				wander();	
			}
		}
		
		if (_lookActive) lookForTarget();
			
		break;
		
	case Awareness.Active:
		var _viewClear = collision_line(x, y, target.x, target.y, prnt_block, false, true) == noone;
		if (_viewClear) {
			moveDirection = point_direction(x, y, target.x, target.y) + pathWobbleOffset;
			distanceToTarget = point_distance(x, y, target.x, target.y);
			currentSpeed =  min(distanceToTarget, moveSpeed);
			if (currentSpeed > .25 && distanceToTarget > 16) {
				var _vx = lengthdir_x(moveSpeed, moveDirection);
				var _vy = lengthdir_y(moveSpeed, moveDirection);
				setVelocityTarget(_vx, _vy);
			}
			
			if (distanceToTarget < 24 && attackCooldown <= 0) {
				attackCooldown = seconds_range(2, 4);
				var _attackX = x + lengthdir_x(16, moveDirection);
				var _attackY = y + lengthdir_y(12, moveDirection);
				instance_create_layer(_attackX, _attackY, "Instances", o_zombieMeleeAttack);
			}
		} else {
			setAwareness(Awareness.Hunting);
			createNewPath(target.x, target.y);
		}
		break;
		
	case Awareness.Hunting:
		var _viewClearHunting = collision_line(x, y, target.x, target.y, prnt_block, false, true) == noone;
		if (_viewClearHunting) {
			setAwareness(Awareness.Active);
		}
		break;
}

if (attackCooldown > 0) attackCooldown--;


if (path_exists(myPath) && pathActive) {
	// Sample a small step ahead along the path
	var _pathSpeed = moveSpeed / path_get_length(myPath);
	var px = path_get_x(myPath, path_position)
	var py = path_get_y(myPath, path_position)
	var _distanceToPoint = point_distance(x, y, px, py);
	var _canSeePoint = _lookActive ? collision_line(x, y, px, py, prnt_block, false, true) == noone : true;
	if (_distanceToPoint < 48 && _canSeePoint) {
		path_position += path_position == 0 ? (_pathSpeed * 8) : _pathSpeed; // advance along path
	}
	
	px = path_get_x(myPath, path_position);
	py = path_get_y(myPath, path_position);
	moveDirection = point_direction(x, y, px, py) + pathWobbleOffset;
	
	var _distanceToTarget = point_distance(x, y, px, py);
	if (_distanceToTarget > 96) {
		createNewPath(pathEndX, pathEndY);	
	}
	
	var _distanceToEnd = point_distance(x, y, pathEndX, pathEndY);
	currentSpeed =  min(_distanceToTarget, moveSpeed);
	var vx = lengthdir_x(currentSpeed, moveDirection);
	var vy = lengthdir_y(currentSpeed, moveDirection);
	
	if (_distanceToEnd < 16) {
		setAwareness(Awareness.Unaware);
	}
			
	if (currentSpeed > .25) {
		setVelocityTarget(vx, vy);

		// Move patience running out (kicks them out of their path if blocked for long enough)
		var _distanceMoved = point_distance(phy_position_x, phy_position_y, phy_position_xprevious, phy_position_yprevious);
		if (_distanceMoved < moveSpeed * .5) {
			if (movePatience > 0)
				then movePatience--
				else {
					setAwareness(Awareness.Unaware);
				}
		} else {
			movePatience = movePatienceSet;	
		}
					
	} else {
		setAwareness(Awareness.Unaware);
	}
}

if (stunned) {
	stopVelocity(.95);
} else {
	var _speedAboveThreshold = currentSpeed > .25;
	var _movingToPath = pathActive && point_distance(x, y, pathEndX, pathEndY) > 16;
	var _movingToTarget = target != noone && distanceToTarget > 16;
	isMoving = _speedAboveThreshold && (_movingToPath || _movingToTarget);

	if (isMoving) {
		pathWobble = pathWobble + pathWobbleRate mod 360;
		pathWobbleOffset = lengthdir_x(pathWobbleDistance, pathWobble);
	
		var _vDiffX = vTargetX - phy_linear_velocity_x;
		var _vDiffY = vTargetY - phy_linear_velocity_y;
	
		var _vPushX = clamp(_vDiffX, -vAccel, vAccel);
		var _vPushY = clamp(_vDiffY, -vAccel, vAccel);
	
		phy_linear_velocity_x += _vPushX;
		phy_linear_velocity_y += _vPushY;
	} else {
		stopVelocity();	
	}
}