function Weapon(
	_fireFn,
	_FireMode,
	_ReloadMode,
	_rateOfFire,
	_clipSize,
	_reloadTime,
	_AmmoType,
	_ammoCostPerRound
) constructor {
	fireFn = _fireFn;
	fireMode = _FireMode;
	reloadMode = _ReloadMode;
	rateOfFire = _rateOfFire;
	clipSize = _clipSize;
	reloadTime = _reloadTime;
	ammoType = _AmmoType;
	ammoCostPerRound = _ammoCostPerRound;
}

enum AmmoType {
	None,
	Bullets,
	Shells,
	Fuel,
	Projectiles,
	Explosives,
}

enum ReloadMode {
	Clip,
	Single
}

enum FireMode {
	Auto,
	Semi,
}

enum WeaponValue {
	Pistol,
	Shotgun,
	AK47,
}

function initWeaponry() {
	return {
		/* WEAPON SLOTS */
		equipped: [
			{
				stats: -1,
				roundsInClip: 0,
			},
			{
				stats: -1,
				roundsInClip: 0,
			},
		],
		equippedSlot: 0,
		
		swap: function() {
			var _swapIndex = abs(equippedSlot - 1);
			var _swapWeapon = equipped[_swapIndex];
			// We only swap the weapon if the alternate weapon exists.
			if (!!_swapWeapon.stats) {
				equippedSlot = _swapIndex;
			}
		},

		equip: function(_WeaponValue, _slot) {
			var _weapon = getWeapon(_WeaponValue);
			equipped[_slot] = {
				stats: _weapon,
				roundsInClip: _weapon.clipSize
			}
		},
		
		currentWeapon: function() {
			return equipped[equippedSlot];	
		},
		
		/* COOLDOWNS */
		fireCooldown: 0,
		reloadCooldown: -1,
		
		/* LISTENING ACTION */
		checkForFire: function(_x, _y, _direction, _owner) {
			var _currentWeapon = currentWeapon();
			var _stats = _currentWeapon.stats;
			
			if (_stats = -1) return;
			
			// Cooldown between shots
			if (fireCooldown > 0) {
				fireCooldown--;
				return;
			}
			
			// Reloading
			if (reloadCooldown > -1) {
				if (reloadCooldown > 0) reloadCooldown-- else {
					var _ammoCount = ammo.getCount(_stats.ammoType);
					switch(_stats.reloadMode) {
						case ReloadMode.Clip:
							// Fill up entire clip as much as it can, either to the clip size or with to the remaining amount of ammo
							_currentWeapon.roundsInClip = min(_stats.clipSize, _ammoCount);
							reloadCooldown = -1;
							break;
						case ReloadMode.Single:
							// Fill up clip one at a time, as long as there is ammo left to fill
							_currentWeapon.roundsInClip = min(_currentWeapon.roundsInClip + _stats.ammoCostPerRound, _ammoCount);
							if (_currentWeapon.roundsInClip == _stats.clipSize || _currentWeapon.roundsInClip == _ammoCount) {
								reloadCooldown = -1;	
							} else {
								reload();	
							}
							break;
					}
					
				}
				
				// Clip reloads don't allow firing if reloading while the clip is empty
				if (_stats.reloadMode == ReloadMode.Clip && _currentWeapon.roundsInClip == 0) {
					return;	
				}
			}
			
			var _enoughAmmoToReload = ammo.getCount(_stats.ammoType) >= _stats.ammoCostPerRound;
			var _reloadReady = reloadCooldown == -1;
			var _readyToReload = (_enoughAmmoToReload && _reloadReady);
			
			// Reloading in the middle of a clip
			if (_readyToReload && _currentWeapon.roundsInClip < _stats.clipSize) {
				if (gamepad_button_check_pressed(0, gp_face3)) reload()
			}
			
			// Trigger reload at end of clip, block firing if nothing in clip to fire
			if (_currentWeapon.roundsInClip < _stats.ammoCostPerRound) {
				if (_readyToReload) reload();
				return;	
			}
			
			// Triggering shot
			var _triggerActive = _stats.fireMode == FireMode.Semi ? gamepad_button_check_pressed(0, gp_shoulderrb) : gamepad_button_check(0, gp_shoulderrb);
			if (_triggerActive) {
				// Firing while reloading cancels reload
				if (reloadCooldown > 0) {
					reloadCooldown = -1;	
				}
				
				_stats.fireFn(_x, _y, _direction, _owner);
				fireCooldown = _stats.rateOfFire;
				
				// Take ammo cost
				_currentWeapon.roundsInClip = max(_currentWeapon.roundsInClip - _stats.ammoCostPerRound, 0);
				ammo.add(_stats.ammoType, -_stats.ammoCostPerRound);
			}
		},

		reload: function() {
			reloadCooldown = currentWeapon().stats.reloadTime;	
		},
		
		/* AMMO */
		ammo: {
			bullets: 100,
			shells: 15,
			fuel: 100,
			projectiles: 50,
			explosives: 25,
	
			bulletsMax: 250,
			shellsMax: 60,
			fuelMax: 100,
			projectilesMax: 50,
			explosivesMax: 25,
			
			getMax: function(_AmmoType) {
				switch(_AmmoType) {
					case AmmoType.Bullets: return bulletsMax;
					case AmmoType.Shells: return shellsMax;						
				}
			},
	
			add: function(_AmmoType, _change) {
				switch(_AmmoType) {
					case AmmoType.Bullets:
						bullets = clamp(bullets + _change, 0, bulletsMax);
						break;
					case AmmoType.Shells:
						shells = clamp(shells + _change, 0, shellsMax);
						break;
					case AmmoType.Fuel:
						fuel = clamp(fuel + _change, 0, fuelMax);
						break;
					case AmmoType.Projectiles:
						projectiles = clamp(projectiles + _change, 0, projectilesMax);
						break;
					case AmmoType.Explosives:
						explosives = clamp(explosives + _change, 0, explosivesMax);
						break;	
				}
			},
			
			getCount: function(_AmmoType) {
				switch(_AmmoType) {
					case AmmoType.Bullets: return bullets;
					case AmmoType.Shells: return shells;
					case AmmoType.Fuel: return fuel;
					case AmmoType.Projectiles: return projectiles;
					case AmmoType.Explosives: return explosives;	
				}
			}
		}
	}
}

function getWeapon(_WeaponValue) {
	switch(_WeaponValue) {
		case WeaponValue.Pistol:
			return new Weapon(
				function(_x, _y, _direction, _owner) {
					notifyRadius(_x, _y, _owner, 512);
					instance_create_layer(_x, _y, "Instances", prnt_bullet, {
						moveDirection: _direction,
						owner: _owner,
					});
				},
				FireMode.Semi,
				ReloadMode.Clip,
				1, 12, seconds(1.5),
				AmmoType.Bullets, 1
			);
			
		case WeaponValue.Shotgun:
			return new Weapon(
				function(_x, _y, _direction, _owner) {
					notifyRadius(_x, _y, _owner, 512);
					repeat(8) {
						instance_create_layer(_x, _y, "Instances", prnt_bullet, {
							moveDirection: _direction + random_range(-15, 15),
							moveSpeed: random_range(7, 10),
							duration: seconds_range(.20, .30),
							owner: _owner,
						});
					}
				},
				FireMode.Semi,
				ReloadMode.Single,
				1, 12, seconds(.5),
				AmmoType.Shells, 2
			);
			
		case WeaponValue.AK47:
			return new Weapon(
				function(_x, _y, _direction, _owner) {
					notifyRadius(_x, _y, _owner, 512);
					instance_create_layer(_x, _y, "Instances", prnt_bullet, {
						moveDirection: _direction + random_range(-3, 3),
						moveSpeed: random_range(7, 10),
						owner: _owner,
					});
				},
				FireMode.Auto,
				ReloadMode.Clip,
				seconds(.1), 60, seconds(1.8),
				AmmoType.Bullets,
				1
			);
			
	}
}

