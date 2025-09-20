var _lookActive = false;
if (viewCheckTimer > 0) viewCheckTimer-- else {
	viewCheckTimer = irandom_range(viewCheckTimerSet[0], viewCheckTimerSet[1]);
	_lookActive = true;
}

var _playerInView = noone;
var _targetLineOfSight = false;

if (stateTimer > 0) stateTimer--;
switch(state) {
	// Moving to and around the target zone
	case "neutral":
		if (!pathActive) moveToTargetZone();
		_playerInView = _lookActive ? lookForTarget(o_player) : noone;
		if (_playerInView) {
			target = _playerInView
			state = "chasing";	
			moveMode = "direct";
			pathActive = false;
		}
		break;
		
	// Can see and is moving towards a player target
	case "chasing":
		if (instance_exists(target)) {
			_targetLineOfSight = _lookActive ? instanceInLineOfSight(target) == noone : true;
			if (_targetLineOfSight) {
				accelerateTowardsTarget();
				triggerAttack();
			} else {
				state = "hunting";
				createNewPath(target.x, target.y);
			}
		} else {
			// TODO: handle target does not exist	
		}
		break;
		
	// Lost sight of the player target, but will move to where they were last seen
	case "hunting":
		// Looking for the player while hunting
		_playerInView = _lookActive ? lookForTarget(o_player, viewAngleWide) : noone;
		if (_playerInView) {
			target = _playerInView;
			state = "chasing";
			moveMode = "direct";
			pathActive = false;
		}
		// What do we do at the end of our hunting path?
		if (!pathActive) {
			state = "searching";
			wanderTimer = wanderTimerSet[1];
			stateTimer = seconds_range(10, 15);
		}
		break;
	
	// Arrived at last seen location, but player is not there. Wanders around for a bit before returning to target zone
	case "searching":
		_playerInView = _lookActive ? lookForTarget(o_player, viewAngleWide) : noone;
		if (_playerInView) {
			target = _playerInView;
			state = "chasing";
			moveMode = "direct";
			pathActive = false;
		}
		if (stateTimer > 0) stateTimer-- else {
			state = "neutral";
		}
		triggerWandering();
		break;
		
	// Something is in the way - destroy it, then return to original path
	case "destroy-barricade":
		if (instance_exists(target)) {
			accelerateTowardsTarget();
			triggerAttack();
		} else {
			state = "hunting";
			log("TARGET NO LONGER EXISTS");
			createNewPath(ogTargetX, ogTargetY);
		}
		break;
}

//switch(awareness) {
//	case Awareness.Unaware:
//		if (!pathActive) {
//			// If wandering outside of the zone for too long, return back after a while
//			if (!inTheZone) {
//				if (wanderPatience > 0) wanderPatience-- else {
//					moveToTargetZone();	
//				}
//			}
//			triggerWandering();
//		}
		
//		if (_lookActive) lookForTarget();
			
//		break;
		
//	case Awareness.Active:
//		if (instance_exists(target)) {
//			var _viewClear = collision_line(x, y, target.x, target.y, prnt_block, false, true) == noone;
//			if (_viewClear) {
//				accelerateTowardsTarget();
//				triggerAttack();
//			} else {
//				setAwareness(Awareness.Hunting);
//				createNewPath(target.x, target.y);
//			}
//		} else {
//			afterTargetDestroy();	
//		}
//		break;
		
//	case Awareness.Hunting:
//		if (_lookActive) {
//			var _viewClearHunting = collision_line(x, y, target.x, target.y, prnt_block, false, true) == noone;
//			if (_viewClearHunting) {
//				setAwareness(Awareness.Active);
//			}
//		}
//		break;
//}

if (attackCooldown > 0) attackCooldown--;

if (path_exists(myPath) && pathActive) {
	// Sample a small step ahead along the path
	var px = path_get_x(myPath, path_position)
	var py = path_get_y(myPath, path_position)
	var _distanceToPoint = point_distance(x, y, px, py);
	
	// Only move along path if it is visible and within a certain range
	var _canSeePoint = _lookActive ? collision_line(x, y, px, py, prnt_block, false, true) == noone : true;
	if (_distanceToPoint < moveSpeed * 8 && _canSeePoint) {
		path_position += path_position == 0 ? (pathSpeed * 8) : pathSpeed; // advance along path
	}
	
	// Sample the new path coords after path_position moved
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
		pathActive = false;
	}
			
	if (currentSpeed > moveSpeedMinThreshold) {
		setVelocityTarget(vx, vy);				
	}
}

if (stunned) {
	stopVelocity(.95);
} else {
	var _speedAboveThreshold = currentSpeed > moveSpeedMinThreshold;
	var _movingToPath = moveMode == "path" && pathActive && point_distance(x, y, pathEndX, pathEndY) > 16;
	var _movingToTarget = moveMode == "direct" && target != noone && distanceToTarget > 16;
	isMoving = _speedAboveThreshold && (_movingToPath || _movingToTarget);
	
	if (isMoving) {
		move();
	} else {
		stopVelocity();	
	}
}

if (isMoving) {
	// Move patience running out (kicks them out of their path if blocked for long enough)
	var _distanceMoved = point_distance(phy_position_x, phy_position_y, phy_position_xprevious, phy_position_yprevious);
	if (_distanceMoved < moveSpeed * .1) {
		if (state != "destroy-barricade") {
			// Check for destructable obstruction
			var _checkDis = moveSpeed + 4;
			var _collisionInPath = collision_circle(x + lengthdir_x(_checkDis, moveDirection), y + lengthdir_y(_checkDis, moveDirection), _checkDis, prnt_destructable, false, true);
			// Move to destroy obstruction if it is in front
			if (_collisionInPath != noone) {
				state = "destroy-barricade";
				pathActive = false;
				// Restart the original path
				var _targetExists = instance_exists(target);
				ogTargetX = pathActive ? pathEndX : (_targetExists && target.object_index == o_player ? target.x : ogTargetX);
				ogTargetY = pathActive ? pathEndY : (_targetExists && target.object_index == o_player ? target.y : ogTargetY);
				target = _collisionInPath;
			}
		}
		
		if (movePatience > 0)
			then movePatience--
			else {
				moveToTargetZone();
			}
	} 	
} else {
	movePatience = movePatienceSet;	
}
