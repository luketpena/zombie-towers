// Moving camera to location
cam_x += (target_x - (width  * .5) - cam_x) * cam_speed;
cam_y += (target_y - (height * .5) - cam_y) * cam_speed;

var _new_x = cam_x - global.hzw;
var _new_y = cam_y - global.hzh;

camera_set_view_pos(view_camera[0], _new_x, _new_y);
cam_set(true);
