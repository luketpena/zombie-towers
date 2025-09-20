draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, image_angle, c_white, active ? 1 : .5);

if (active) {
	draw_sprite_ext(s_arrow, 0, x, y - 8, 1, 1, 270, c_white, 1);
}
