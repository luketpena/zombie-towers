var _currentWeapon = weapon.currentWeapon();
for (var i=0; i<_currentWeapon.roundsInClip; i++) {
	draw_sprite_ext(s_ui_ammo, 0, 20 + (8 * i), 16, 1, 1, 0, c_white, 1);	
}
log(_currentWeapon.stats.weaponValue);
draw_sprite_ext(s_ui_weaponHudIcons, _currentWeapon.stats.weaponValue ?? 0, 0, 12, 1, 1, 0, c_white, 1);

draw_set_color(c_red);
draw_set_alpha(1);

draw_text(4, 40, "BULLETS: " + string(weapon.ammo.bullets));
draw_text(4, 52, "SHELLS: " + string(weapon.ammo.shells));

var _healthScale = hp / 100;
draw_set_color(merge_color(c_red, c_lime, _healthScale));
draw_rectangle(0, 0, 200 * _healthScale, 12, false);

draw_set_color(c_fuchsia);
draw_text(4, 64, "ECTO: " + string(global.ecto));