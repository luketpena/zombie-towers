switch(mode) {
	case CameraMode.Object:
		if (instance_exists(target)) {
			if (variable_instance_exists(target, "focusPos")) {
				focus.set(target.focusPos.x, target.focusPos.y);
			} else {
				focus.set(target.x, target.y);	
			}
			var _focus_dis_current = point_distance(focus.x, focus.y, target.x, target.y);
			var _cam_dir = point_direction(focus.x, focus.y, target.x, target.y);
			var _cam_len = _focus_dis_current/2;
	
			target_x = focus.x - global.hzw + lengthdir_x(_cam_len, _cam_dir);
			target_y = focus.y - global.hzh + lengthdir_y(_cam_len, _cam_dir);		
		}
	break;
	
	case CameraMode.Location:
		// Nada
		break;
}