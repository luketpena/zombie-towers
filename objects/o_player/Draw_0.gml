draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, c_lime, 1);
draw_arrow(x, y, x + lengthdir_x(512, aimDirection), y + lengthdir_y(512, aimDirection), 8);

if (isBuilding) {
	draw_sprite_ext(s_block_center, 0, buildPos.x, buildPos.y, 1, 1, 0, buildIsClear ? c_white : c_red, .5);
}