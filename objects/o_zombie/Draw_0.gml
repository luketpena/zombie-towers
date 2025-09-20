

if (path_exists(myPath)) {
	draw_path(myPath, x, y, true);	
}

draw_sprite_ext(s_arrow, 0, x, y, 1, 1, moveDirection, pathActive ? c_lime : c_red, 1);

draw_sprite_ext(s_arrow, 0, ogTargetX, ogTargetY, 1, 1, 270, c_teal, 1);
draw_sprite_ext(sprite_index, image_index, x, y, face, 1, 0, c_white, 1);
if (awareness == Awareness.Unaware) {
	var _viewUnit = (viewAngle * 2) / 8
	draw_set_color(c_lime);
	draw_set_alpha(.1);
	draw_primitive_begin(pr_trianglefan);
		draw_vertex(x, y);
		for(var i=0; i<8; i++) {
			var _angle = moveDirection - viewAngle + (_viewUnit * i);
			var _x = x + lengthdir_x(viewDistance, _angle);
			var _y = y + lengthdir_y(viewDistance, _angle);
			draw_vertex(_x, _y);
		}
	draw_primitive_end();
}

draw_set_color(c_red);
draw_set_alpha(1);

if instance_exists(target) draw_circle(target.x, target.y, 16, true);

draw_text(x, y+8, state);
//draw_text(x, y+8, movePatience);


//draw_sprite_ext(s_mask_xs, 0, testX, testY, 1, 1, 0, c_red, 1);